open_project -reset ma_prj

set_top sandpile

add_files ./sandpile.hls.cpp

add_files -tb ./sandpile_TB.cpp

open_solution "solution" -flow_target vivado

# set_part {xcvu37p-fsvh2892-2L-e}

set_part {xc7a35ticsg324-1L}

create_clock -period 10 -name default
config_interface --m_axi_addr64=false
# config_dataflow -default_channel fifo -fifo_depth 2
# config_dataflow -scalar_fifo_depth 6

# Simulation
csim_design

# Synth to Verilog/VHDL
csynth_design

# Cosim
cosim_design

exit
