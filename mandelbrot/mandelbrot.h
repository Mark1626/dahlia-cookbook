#ifndef MANDELBROT_H
#define MANDELBROT_H

#include <ap_int.h>
#include <ap_fixed.h>

extern "C" {
    void mandelbrot(ap_uint<8> grid_int[256][256], ap_fixed<32,16> xst_int, ap_fixed<32,16> yst_int, ap_fixed<32,16> stepx_int, ap_fixed<32,16> stepy_int);
    // void mandelbrot(ap_uint<8> grid_int[256][256], float xst_int, float yst_int, float stepx_int, float stepy_int);
}

#endif
