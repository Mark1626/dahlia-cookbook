# Travelling Salesperson

The code is based on [this](https://github.com/Xilinx/Vitis-Tutorials/blob/2023.2/Hardware_Acceleration/Design_Tutorials/04-traveling-salesperson/code/tsp.cpp) in Vitis Tutorials

This has been run on Vitis HLS 2022.1

|                      |          Status         |
|----------------------|-------------------------|
| Implementation       | Done(needs improvement) |
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

## Performance

Target for synthesis is a Virtex Ultrascale+ VCU128 board. Clock period was set to 4.

### Vitis HLS Implementation

```
    * Version:        2022.1
    * Project:        tsp_gold_prj
    * Solution:       solution (Vivado IP Flow Target)
    * Product family: virtexuplus
    * Target device:  xcvu37p-fsvh2892-2L-e
    

+ Performance & Resource Estimates: 
    
    PS: '+' for module; 'o' for loop; '*' for dataflow
    +--------------------------------+------+------+---------+-----------+----------+---------+--------+----------+------+---------+------------+------------+-----+
    |             Modules            | Issue|      | Latency |  Latency  | Iteration|         |  Trip  |          |      |         |            |            |     |
    |             & Loops            | Type | Slack| (cycles)|    (ns)   |  Latency | Interval|  Count | Pipelined| BRAM |   DSP   |     FF     |     LUT    | URAM|
    +--------------------------------+------+------+---------+-----------+----------+---------+--------+----------+------+---------+------------+------------+-----+
    |+ tsp                           |     -|  0.00|   363063|  1.452e+06|         -|   363064|       -|        no|     -|  3 (~0%)|  4144 (~0%)|  4435 (~0%)|    -|
    | + tsp_Pipeline_loop_distances  |     -|  1.73|      102|    408.000|         -|      102|       -|        no|     -|        -|     9 (~0%)|    64 (~0%)|    -|
    |  o loop_distances              |     -|  2.92|      100|    400.000|         1|        1|     100|       yes|     -|        -|           -|           -|    -|
    | + tsp_Pipeline_loop_compute    |     -|  0.00|   362956|  1.452e+06|         -|   362956|       -|        no|     -|  3 (~0%)|  4111 (~0%)|  4183 (~0%)|    -|
    |  o loop_compute                |     -|  2.92|   362954|  1.452e+06|        76|        1|  362880|       yes|     -|        -|           -|           -|    -|
    +--------------------------------+------+------+---------+-----------+----------+---------+--------+----------+------+---------+------------+------------+-----+


```

### Dahlia Implementation

```
    * Version:        2022.1
    * Project:        tsp_prj
    * Solution:       solution (Vivado IP Flow Target)
    * Product family: virtexuplus
    * Target device:  xcvu37p-fsvh2892-2L-e
    

+ Performance & Resource Estimates: 
    
    PS: '+' for module; 'o' for loop; '*' for dataflow
    +----------------------------------+------+------+---------+-----------+----------+---------+--------+----------+---------+---------+------------+------------+-----+
    |              Modules             | Issue|      | Latency |  Latency  | Iteration|         |  Trip  |          |         |         |            |            |     |
    |              & Loops             | Type | Slack| (cycles)|    (ns)   |  Latency | Interval|  Count | Pipelined|  BRAM   |   DSP   |     FF     |     LUT    | URAM|
    +----------------------------------+------+------+---------+-----------+----------+---------+--------+----------+---------+---------+------------+------------+-----+
    |+ tsp                             |     -|  0.00|  3266228|  1.306e+07|         -|  3266229|       -|        no|  1 (~0%)|  3 (~0%)|  3846 (~0%)|  4964 (~0%)|    -|
    | + tsp_Pipeline_VITIS_LOOP_88_3   |     -|  0.05|  3265990|  1.306e+07|         -|  3265990|       -|        no|        -|  3 (~0%)|  2357 (~0%)|  2968 (~0%)|    -|
    |  o VITIS_LOOP_88_3               |    II|  2.92|  3265988|  1.306e+07|        78|        9|  362880|       yes|        -|        -|           -|           -|    -|
    | o VITIS_LOOP_75_1                |     -|  2.92|      230|    920.000|        23|        -|      10|        no|        -|        -|           -|           -|    -|
    |  + tsp_Pipeline_VITIS_LOOP_78_2  |     -|  0.00|       20|     80.000|         -|       20|       -|        no|        -|        -|   324 (~0%)|   391 (~0%)|    -|
    |   o VITIS_LOOP_78_2              |     -|  2.92|       18|     72.000|        10|        1|      10|       yes|        -|        -|           -|           -|    -|
    +----------------------------------+------+------+---------+-----------+----------+---------+--------+----------+---------+---------+------------+------------+-----+

```

**Note:** There is a pipelining issue caused because of the choice of memory. I'm trying to fix this in Dahlia itself. Manually changing the storage in the generated HLS to  `#pragma HLS BIND_STORAGE variable=distances type=ram_1wnr` yielded close to the original.

```
    * Version:        2022.1
    * Project:        tsp_prj
    * Solution:       solution (Vivado IP Flow Target)
    * Product family: virtexuplus
    * Target device:  xcvu37p-fsvh2892-2L-e

+ Performance & Resource Estimates: 
    
    PS: '+' for module; 'o' for loop; '*' for dataflow
    +----------------------------------+------+------+---------+-----------+----------+---------+--------+----------+------+---------+------------+------------+-----+
    |              Modules             | Issue|      | Latency |  Latency  | Iteration|         |  Trip  |          |      |         |            |            |     |
    |              & Loops             | Type | Slack| (cycles)|    (ns)   |  Latency | Interval|  Count | Pipelined| BRAM |   DSP   |     FF     |     LUT    | URAM|
    +----------------------------------+------+------+---------+-----------+----------+---------+--------+----------+------+---------+------------+------------+-----+
    |+ tsp                             |     -|  0.00|   363191|  1.453e+06|         -|   363192|       -|        no|     -|  3 (~0%)|  4871 (~0%)|  5369 (~0%)|    -|
    | + tsp_Pipeline_VITIS_LOOP_88_3   |     -|  0.04|   362953|  1.452e+06|         -|   362953|       -|        no|     -|  3 (~0%)|  3365 (~0%)|  3268 (~0%)|    -|
    |  o VITIS_LOOP_88_3               |     -|  2.92|   362951|  1.452e+06|        73|        1|  362880|       yes|     -|        -|           -|           -|    -|
    | o VITIS_LOOP_75_1                |     -|  2.92|      230|    920.000|        23|        -|      10|        no|     -|        -|           -|           -|    -|
    |  + tsp_Pipeline_VITIS_LOOP_78_2  |     -|  0.00|       20|     80.000|         -|       20|       -|        no|     -|        -|   325 (~0%)|   391 (~0%)|    -|
    |   o VITIS_LOOP_78_2              |     -|  2.92|       18|     72.000|        10|        1|      10|       yes|     -|        -|           -|           -|    -|
    +----------------------------------+------+------+---------+-----------+----------+---------+--------+----------+------+---------+------------+------------+-----+

```
