#!/usr/bin/env python3
# python3 base.py --build --csr-csv=test/csr.csv

from migen import *

from litex.gen import *

from litex_boards.platforms import digilent_arty

from litex.soc.interconnect.csr import *
from litex.soc.interconnect import wishbone

from litex.soc.cores.clock import *
from litex.soc.integration.soc import SoCRegion
from litex.soc.integration.soc_core import *
from litex.soc.integration.builder import *

from litex.soc.cores.uart import UARTWishboneBridge
from litex.soc.cores.led import LedChaser
from litex.soc.cores.xadc import XADC
from litex.soc.cores.dna  import DNA

from litedram.modules import MT41K128M16
from litedram.phy import s7ddrphy

from liteeth.phy.mii import LiteEthPHYMII

# CRG ------------------------------------------------------------------

class _CRG(LiteXModule):
    def __init__(self, platform, sys_clk_freq, with_dram=True, with_rst=True):
        self.rst    = Signal()
        self.cd_sys = ClockDomain()
        self.cd_eth = ClockDomain()
        if with_dram:
            self.cd_sys4x     = ClockDomain()
            self.cd_sys4x_dqs = ClockDomain()
            self.cd_idelay    = ClockDomain()

        # # #

        # Clk/Rst.
        clk100 = platform.request("clk100")
        rst    = ~platform.request("cpu_reset") if with_rst else 0

        # PLL.
        self.pll = pll = S7PLL(speedgrade=-1)
        self.comb += pll.reset.eq(rst | self.rst)
        pll.register_clkin(clk100, 100e6)
        pll.create_clkout(self.cd_sys, sys_clk_freq)
        pll.create_clkout(self.cd_eth, 25e6)
        self.comb += platform.request("eth_ref_clk").eq(self.cd_eth.clk)
        platform.add_false_path_constraints(self.cd_sys.clk, pll.clkin) # Ignore sys_clk to pll.clkin path created by SoC's rst.
        if with_dram:
            pll.create_clkout(self.cd_sys4x,     4*sys_clk_freq)
            pll.create_clkout(self.cd_sys4x_dqs, 4*sys_clk_freq, phase=90)
            pll.create_clkout(self.cd_idelay,    200e6)

        # IdelayCtrl.
        if with_dram:
            self.idelayctrl = S7IDELAYCTRL(self.cd_idelay)

# BaseSoC ------------------------------------------------------------------

class BaseSoC(SoCMini):
    def __init__(self, variant="a7-35", toolchain="vivado", sys_clk_freq=100e6,
        with_xadc       = False,
        with_dna        = False,
        with_ethernet   = False,
        with_etherbone  = False,
        eth_ip          = "192.168.1.50",
        eth_dynamic_ip  = False,
        with_led_chaser = True,
        with_buttons    = False,
        with_pmod_gpio  = False,
        with_analyzer   = True,
        **kwargs):
        platform = digilent_arty.Platform(variant=variant, toolchain=toolchain)

        # CRG --------------------------------------------------------------------------------------
        with_dram = (kwargs.get("integrated_main_ram_size", 0) == 0)
        self.crg  = _CRG(platform, sys_clk_freq, with_dram)

        SoCMini.__init__(self, platform, sys_clk_freq, csr_data_width=32,
        ident="LiteX Accel System", ident_version=True)

        # No CPU, use Serial to control Wishbone bus
        self.submodules.serial_bridge = UARTWishboneBridge(platform.request("serial"), sys_clk_freq)
        self.add_wb_master(self.serial_bridge.wishbone)

        # XADC -------------------------------------------------------------------------------------
        if with_xadc:
            self.xadc = XADC()

        # DNA --------------------------------------------------------------------------------------
        if with_dna:
            self.dna = DNA()
            self.dna.add_timing_constraints(platform, sys_clk_freq, self.crg.cd_sys.clk)

        self.submodules.leds = LedChaser(pads=platform.request_all("user_led"), sys_clk_freq=sys_clk_freq)

        # DDR3 SDRAM -------------------------------------------------------------------------------
        if not self.integrated_main_ram_size:
            self.ddrphy = s7ddrphy.A7DDRPHY(platform.request("ddram"),
                memtype        = "DDR3",
                nphases        = 4,
                sys_clk_freq   = sys_clk_freq)
            self.add_sdram("sdram",
                phy           = self.ddrphy,
                module        = MT41K128M16(sys_clk_freq, "1:4"),
                l2_cache_size = kwargs.get("l2_size", 8192)
            )
        from acc import HLSAccAXI
        self.submodules.hls = HLSAccAXI('sandpile')
        self.bus.add_slave("s_hls", self.hls.s_axilite, SoCRegion(
            origin=0x2000_0000,
            size=0x100
        ))
        self.bus.add_master("m_hls", self.hls.m_axi)
        self.platform.add_source_dir("../hls/ma_prj/solution/impl/verilog")

        # if with_analyzer:
        #     from litescope import LiteScopeAnalyzer
        #     analyzer_signals = [self.hls.m_axi.aw.valid,
        #                         self.hls.m_axi.aw.ready,
        #                         self.hls.m_axi.aw.addr,
        #                         self.hls.m_axi.aw.len,

        #                         self.hls.m_axi.w.valid,
        #                         self.hls.m_axi.w.ready,
        #                         self.hls.m_axi.w.data,

        #                         self.hls.m_axi.ar.valid,
        #                         self.hls.m_axi.ar.ready,
        #                         self.hls.m_axi.ar.addr,
        #                         self.hls.m_axi.ar.len,

        #                         self.hls.m_axi.r.valid,
        #                         self.hls.m_axi.r.ready,
        #                         self.hls.m_axi.r.data,
                                
        #                         self.hls.m_axi.b.valid,
        #                         self.hls.m_axi.b.ready,
        #                         self.hls.m_axi.b.resp,
                                
        #                         self.hls.s_axilite.ar.valid,
        #                         self.hls.s_axilite.ar.ready,
        #                         self.hls.s_axilite.ar.addr,
                                
        #                         self.hls.s_axilite.r.valid,
        #                         self.hls.s_axilite.r.ready,
        #                         self.hls.s_axilite.r.data,
                                
        #                         self.hls.s_axilite.aw.valid,
        #                         self.hls.s_axilite.aw.ready,
        #                         self.hls.s_axilite.aw.addr,
                                
        #                         self.hls.s_axilite.w.valid,
        #                         self.hls.s_axilite.w.ready,
        #                         self.hls.s_axilite.w.data,
                                
        #                         self.hls.s_axilite.b.valid,
        #                         self.hls.s_axilite.b.ready,
        #                         self.hls.s_axilite.b.resp,
        #                                              ]
        #                         # self.bus.main_ram.stb,
        #                         # self.bus.main_ram.ack,
        #                         # self.bus.main_ram.adr,
        #                         # self.bus.main_ram.dat_w,
        #                         # self.bus.main_ram.dat_r,
        #                         # self.bus]
                               
        #     self.submodules.analyzer = LiteScopeAnalyzer(analyzer_signals,
        #         depth        = 2048,
        #         clock_domain = "sys",
        #         csr_csv      = "analyzer.csv")

def main(customizations=None):
    from litex.build.parser import LiteXArgumentParser
    parser = LiteXArgumentParser(platform=digilent_arty.Platform, description="LiteX SoC on Arty A7.")
    parser.add_target_argument("--flash",        action="store_true",       help="Flash bitstream.")
    parser.add_target_argument("--variant",      default="a7-35",           help="Board variant (a7-35 or a7-100).")
    parser.add_target_argument("--sys-clk-freq", default=100e6, type=float, help="System clock frequency.")
    parser.add_target_argument("--with-xadc",    action="store_true",       help="Enable 7-Series XADC.")
    parser.add_target_argument("--with-dna",     action="store_true",       help="Enable 7-Series DNA.")
    ethopts = parser.target_group.add_mutually_exclusive_group()
    ethopts.add_argument("--with-ethernet",        action="store_true",    help="Enable Ethernet support.")
    ethopts.add_argument("--with-etherbone",       action="store_true",    help="Enable Etherbone support.")
    parser.add_target_argument("--eth-ip",         default="192.168.1.50", help="Ethernet/Etherbone IP address.")
    parser.add_target_argument("--eth-dynamic-ip", action="store_true",    help="Enable dynamic Ethernet IP addresses setting.")
    parser.add_target_argument("--with-analyzer", action="store_true", help="Add Analyzer")

    args = parser.parse_args()

    assert not (args.with_etherbone and args.eth_dynamic_ip)

    soc = BaseSoC(
        variant        = args.variant,
        toolchain      = args.toolchain,
        sys_clk_freq   = args.sys_clk_freq,
        with_xadc      = args.with_xadc,
        with_dna       = args.with_dna,
        with_ethernet  = args.with_ethernet,
        with_etherbone = args.with_etherbone,
        eth_ip         = args.eth_ip,
        eth_dynamic_ip = args.eth_dynamic_ip,
        **parser.soc_argdict
    )

    builder = Builder(soc, **parser.builder_argdict)
    if args.build:
        builder.build(**parser.toolchain_argdict)

    if args.load:
        prog = soc.platform.create_programmer()
        prog.load_bitstream(builder.get_bitstream_filename(mode="sram"))

    if args.flash:
        prog = soc.platform.create_programmer()
        prog.flash(0, builder.get_bitstream_filename(mode="flash"))
    
    if customizations:
        customizations(soc)

if __name__ == "__main__":
    main()

