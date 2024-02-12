# Sandpile stabilizer computed from hardware

![Sandpile](./sandpile.png)

|                      |          Status         |
|----------------------|-------------------------|
| Implementation       | Done                    |
| Simulation           | Done                    |
| CSim                 | Done                    |
| Synth                | Done                    |
| CoSim                | Done                    |
| Artix7               | Done                    |
| Ultrascale or AWS F1 |                         |

## Building and testing

To run the cpp functional simulation

```
make sandpile.test.cpp
```

This simulation captures the data in the json *actual.json*, this can be plotted using the python script in the same directory.

```
python plot.py
```

---

The build_hls.tcl script can create a HLS project and run csim, synthesis and cosim.

The `Makefile` has a rule to create the HLS code from the Dahlia and call Vitis HLS with the `build_hls.tcl` script.

```
make synthesis
```
---
## Litex SoC based accelerator

To run the design in Arty A7 board, run the `base.py` which adds our design as a submodule into the SoC. Build and load the bitstream into the FPGA board.

```
python3 base.py --build --load --csr-csv=csr.csv
```
* ### Using UART :
Start the litex server to communicate with the board via UART.

```
litex_server --uart --uart-port=/dev/ttyUSB1
```

Run the `run_acc.py` to start the accelerator and check the results.

```
python3 run_acc.py
```

## Report

```
    * Version:        2022.2 (Build 3670227 on Oct 13 2022)
    * Project:        ma_prj
    * Solution:       solution (Vivado IP Flow Target)
    * Product family: artix7
    * Target device:  xc7a35ti-csg324-1L
    
+ Performance & Resource Estimates: 
    
    PS: '+' for module; 'o' for loop; '*' for dataflow
    +----------------------------------------+------+------+---------+-----------+----------+---------+------+----------+--------+----+-----------+------------+-----+
    |                 Modules                | Issue|      | Latency |  Latency  | Iteration|         | Trip |          |        |    |           |            |     |
    |                 & Loops                | Type | Slack| (cycles)|    (ns)   |  Latency | Interval| Count| Pipelined|  BRAM  | DSP|     FF    |     LUT    | URAM|
    +----------------------------------------+------+------+---------+-----------+----------+---------+------+----------+--------+----+-----------+------------+-----+
    |+ sandpile                              |     -|  0.00|        -|          -|         -|        -|     -|        no|  2 (2%)|   -|  1484 (3%)|  3391 (16%)|    -|
    | o VITIS_LOOP_19_1                      |     -|  7.30|      150|  1.500e+03|        15|        -|    10|        no|       -|   -|          -|           -|    -|
    |  + sandpile_Pipeline_VITIS_LOOP_22_2   |     -|  0.00|       13|    130.000|         -|       13|     -|        no|       -|   -|   50 (~0%)|    87 (~0%)|    -|
    |   o VITIS_LOOP_22_2                    |     -|  7.30|       11|    110.000|         3|        1|    10|       yes|       -|   -|          -|           -|    -|
    | o VITIS_LOOP_29_3                      |     -|  7.30|      150|  1.500e+03|        15|        -|    10|        no|       -|   -|          -|           -|    -|
    |  + sandpile_Pipeline_VITIS_LOOP_32_4   |     -|  0.79|       12|    120.000|         -|       12|     -|        no|       -|   -|   15 (~0%)|    75 (~0%)|    -|
    |   o VITIS_LOOP_32_4                    |     -|  7.30|       10|    100.000|         2|        1|    10|       yes|       -|   -|          -|           -|    -|
    | o VITIS_LOOP_39_5                      |     -|  7.30|      150|  1.500e+03|        15|        -|    10|        no|       -|   -|          -|           -|    -|
    |  + sandpile_Pipeline_VITIS_LOOP_42_6   |     -|  0.79|       12|    120.000|         -|       12|     -|        no|       -|   -|   11 (~0%)|    89 (~0%)|    -|
    |   o VITIS_LOOP_42_6                    |     -|  7.30|       10|    100.000|         2|        1|    10|       yes|       -|   -|          -|           -|    -|
    | o VITIS_LOOP_49_7                      |     -|  7.30|        -|          -|       474|        -|     -|        no|       -|   -|          -|           -|    -|
    |  o VITIS_LOOP_52_8                     |     -|  7.30|      472|  4.720e+03|        59|        -|     8|        no|       -|   -|          -|           -|    -|
    |   + sandpile_Pipeline_VITIS_LOOP_55_9  |     -|  0.15|       55|    550.000|         -|       55|     -|        no|       -|   -|  234 (~0%)|    758 (3%)|    -|
    |    o VITIS_LOOP_55_9                   |    II|  7.30|       53|    530.000|        12|        6|     8|       yes|       -|   -|          -|           -|    -|
    | o VITIS_LOOP_93_10                     |     -|  7.30|      160|  1.600e+03|        16|        -|    10|        no|       -|   -|          -|           -|    -|
    |  + sandpile_Pipeline_VITIS_LOOP_96_11  |     -|  0.00|       13|    130.000|         -|       13|     -|        no|       -|   -|   42 (~0%)|    86 (~0%)|    -|
    |   o VITIS_LOOP_96_11                   |     -|  7.30|       11|    110.000|         3|        1|    10|       yes|       -|   -|          -|           -|    -|
    +----------------------------------------+------+------+---------+-----------+----------+---------+------+----------+--------+----+-----------+------------+-----+

```
### Cosim

```
Solution          : solution.
Simulation tool   : xsim.

+----------+----------+-----------------------------------------------+-----------------------------------------------+----------------------+
|          |          |             Latency(Clock Cycles)             |              Interval(Clock Cycles)           | Total Execution Time |
+   RTL    +  Status  +-----------------------------------------------+-----------------------------------------------+    (Clock Cycles)    +
|          |          |      min      |      avg      |      max      |      min      |      avg      |      max      |                      |
+----------+----------+-----------------------------------------------+-----------------------------------------------+----------------------+
|      VHDL|        NA|             NA|             NA|             NA|             NA|             NA|             NA|                    NA|
|   Verilog|      Pass|          14804|          14804|          14804|             NA|             NA|             NA|                 14804|
+----------+----------+-----------------------------------------------+-----------------------------------------------+----------------------+

