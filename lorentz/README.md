# Lorentz ODE Solver

Port of github.com/google/jax/blob/main/cloud_tpu_colabs/Lorentz_ODE_Solver.ipynb

Using a second order RK for now

Reference for Runge Kutta `Numerical Recipes in C - The Art of Scientific Computing`

This has been run on Vitis HLS 2022.2

|                      |          Status         |
|----------------------|-------------------------|
| Implementation       | Done(POC,TODOs pending) |
| CSim                 | Working                 |
| Synth                | Working                 |
| CoSim                | Working                 |
| Artix7               |                         |
| Ultrascale or AWS F1 |                         |

## Building and testing

The build_hls.tcl script can create a HLS project and run csim, synthesis and cosim.

The `Makefile` has a rule to create the HLS code from the Dahlia and call Vitis HLS with the `build_hls.tcl` script.

```
make synthesis
```

## Report

### Synthesis

```
    * Version:        2022.2 (Build 3670227 on Oct 13 2022)
    * Project:        lorentz_prj
    * Solution:       solution (Vivado IP Flow Target)
    * Product family: virtexuplus
    * Target device:  xcvu37p-fsvh2892-2L-e
    

+ Performance & Resource Estimates: 
    
    PS: '+' for module; 'o' for loop; '*' for dataflow
    +------------------------------+------+------+---------+-----------+----------+---------+------+----------+---------+----+------------+------------+-----+
    |            Modules           | Issue|      | Latency |  Latency  | Iteration|         | Trip |          |         |    |            |            |     |
    |            & Loops           | Type | Slack| (cycles)|    (ns)   |  Latency | Interval| Count| Pipelined|  BRAM   | DSP|     FF     |     LUT    | URAM|
    +------------------------------+------+------+---------+-----------+----------+---------+------+----------+---------+----+------------+------------+-----+
    |+ lorentz                     |     -|  0.00|     3083|  3.083e+04|         -|     3084|     -|        no|  6 (~0%)|   -|  1094 (~0%)|  1628 (~0%)|    -|
    | + lorentz_Pipeline_out_loop  |     -|  0.00|     3075|  3.075e+04|         -|     3075|     -|        no|  6 (~0%)|   -|   114 (~0%)|   141 (~0%)|    -|
    |  o out_loop                  |    II|  7.30|     3073|  3.073e+04|         5|        3|  1024|       yes|        -|   -|           -|           -|    -|
    +------------------------------+------+------+---------+-----------+----------+---------+------+----------+---------+----+------------+------------+-----+

```

### Cosim

```
Simulation tool   : xsim.

+----------+----------+-----------------------------------------------+-----------------------------------------------+----------------------+
|          |          |             Latency(Clock Cycles)             |              Interval(Clock Cycles)           | Total Execution Time |
+   RTL    +  Status  +-----------------------------------------------+-----------------------------------------------+    (Clock Cycles)    +
|          |          |      min      |      avg      |      max      |      min      |      avg      |      max      |                      |
+----------+----------+-----------------------------------------------+-----------------------------------------------+----------------------+
|      VHDL|        NA|             NA|             NA|             NA|             NA|             NA|             NA|                    NA|
|   Verilog|      Pass|           3519|           3519|           3519|             NA|             NA|             NA|                  3519|
+----------+----------+-----------------------------------------------+-----------------------------------------------+----------------------+

```

## TODO:

1. Use a fourth order RK
2. Currently works only for N=1024 steps, make it run for arbitary steps?!
3. Add assertions in testbench
4. Pass in the initial state and offset
