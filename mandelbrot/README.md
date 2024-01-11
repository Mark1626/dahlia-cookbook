# Mandelbrot set computed from hardware

![Mandelbrot](./mandel.png)

|                      |          Status         |
|----------------------|-------------------------|
| Implementation       | Done                    |
| Simulation           | Done                    |
| CSim                 |                         |
| Synth                |                         |
| CoSim                |                         |
| Artix7               |                         |
| Ultrascale or AWS F1 |                         |

## Building and testing

To run the cpp functional simulation

```
make mandelbrot.test.cpp
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


## Report
