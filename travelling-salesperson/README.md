# Travelling Salesperson

The code is based on [this](https://github.com/Xilinx/Vitis-Tutorials/blob/2023.2/Hardware_Acceleration/Design_Tutorials/04-traveling-salesperson/code/tsp.cpp) in Vitis Tutorials

This has been run on Vitis HLS 2022.2

|------------------------------------------------|
|                      |          Status         |
|----------------------|-------------------------|
| Implementation       | Done(needs improvement) |
| CSim                 | Working                 |
| Synth                | Working                 |
| CoSim                | Working                 |
| Artix7               |                         |
| Ultrascale or AWS F1 |                         |
|------------------------------------------------|

## Building and testing

The build_hls.tcl script can create a HLS project and run csim, synthesis and cosim.

```
make synthesis
```

## Performance

### Vitis HLS Implementation

```
+ Performance & Resource Estimates: 
    
    PS: '+' for module; 'o' for loop; '*' for dataflow
    +--------------------------------+--------+-------+---------+-----------+----------+---------+--------+----------+--------+--------+------------+------------+-----+
    |             Modules            |  Issue |       | Latency |  Latency  | Iteration|         |  Trip  |          |        |        |            |            |     |
    |             & Loops            |  Type  | Slack | (cycles)|    (ns)   |  Latency | Interval|  Count | Pipelined|  BRAM  |   DSP  |     FF     |     LUT    | URAM|
    +--------------------------------+--------+-------+---------+-----------+----------+---------+--------+----------+--------+--------+------------+------------+-----+
    |+ tsp                           |  Timing|  -0.32|   363065|  3.631e+06|         -|   363066|       -|        no|  8 (8%)|  3 (3%)|  4356 (10%)|  4279 (20%)|    -|
    | + tsp_Pipeline_loop_distances  |       -|   2.58|      102|  1.020e+03|         -|      102|       -|        no|       -|       -|     9 (~0%)|    64 (~0%)|    -|
    |  o loop_distances              |       -|   7.30|      100|  1.000e+03|         1|        1|     100|       yes|       -|       -|           -|           -|    -|
    | + tsp_Pipeline_loop_compute    |  Timing|  -0.32|   362958|  3.630e+06|         -|   362958|       -|        no|       -|  3 (3%)|  4229 (10%)|  3946 (18%)|    -|
    |  o loop_compute                |       -|   7.30|   362956|  3.630e+06|        78|        1|  362880|       yes|       -|       -|           -|           -|    -|
    +--------------------------------+--------+-------+---------+-----------+----------+---------+--------+----------+--------+--------+------------+------------+-----+

```

### Dahlia Implementation

```
+ Performance & Resource Estimates: 
    
    PS: '+' for module; 'o' for loop; '*' for dataflow
    +----------------------------------+------+------+---------+-----------+----------+---------+--------+----------+--------+--------+-----------+------------+-----+
    |              Modules             | Issue|      | Latency |  Latency  | Iteration|         |  Trip  |          |        |        |           |            |     |
    |              & Loops             | Type | Slack| (cycles)|    (ns)   |  Latency | Interval|  Count | Pipelined|  BRAM  |   DSP  |     FF    |     LUT    | URAM|
    +----------------------------------+------+------+---------+-----------+----------+---------+--------+----------+--------+--------+-----------+------------+-----+
    |+ tsp                             |     -|  0.00|  3266239|  3.266e+07|         -|  3266240|       -|        no|  1 (1%)|  3 (3%)|  3984 (9%)|  5080 (24%)|    -|
    | + tsp_Pipeline_VITIS_LOOP_87_3   |     -|  0.22|  3265991|  3.266e+07|         -|  3265991|       -|        no|       -|  3 (3%)|  2517 (6%)|  2930 (14%)|    -|
    |  o VITIS_LOOP_87_3               |    II|  7.30|  3265989|  3.266e+07|        79|        9|  362880|       yes|       -|       -|          -|           -|    -|
    | o VITIS_LOOP_74_1                |     -|  7.30|      240|  2.400e+03|        24|        -|      10|        no|       -|       -|          -|           -|    -|
    |  + tsp_Pipeline_VITIS_LOOP_77_2  |     -|  0.00|       22|    220.000|         -|       22|       -|        no|       -|       -|  349 (~0%)|    402 (1%)|    -|
    |   o VITIS_LOOP_77_2              |     -|  7.30|       20|    200.000|        12|        1|      10|       yes|       -|       -|          -|           -|    -|
    +----------------------------------+------+------+---------+-----------+----------+---------+--------+----------+--------+--------+-----------+------------+-----+

```

## TODO

1. The 
