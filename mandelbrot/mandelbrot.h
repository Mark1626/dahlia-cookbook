#ifndef MANDELBROT_H
#define MANDELBROT_H

#include <ap_int.h>
#include <ap_fixed.h>

extern "C" {
    void mandelbrot(ap_uint<8> grid_int[256][256], ap_fixed<16,8> xst_int, ap_fixed<16,8> xen_int, ap_fixed<16,8> yst_int, ap_fixed<16,8> yen_int);
}

#endif
