#include <iostream>
#include <fstream>
#include <ap_int.h>
#include <ap_fixed.h>
#include <cassert>
#include <cstdint>
#include "mandelbrot.h"

int main() {
    const int N = 256;
    
    ap_uint<8> grid[N][N];
    ap_fixed<32,16> xst_int = -2.5;
    ap_fixed<32,16> yst_int = -1.5;
    ap_fixed<32,16> stepx_int = 0.015;
    ap_fixed<32,16> stepy_int = 0.01;

    // float xst_int = -2.5;
    // float yst_int = -1.5;
    // float stepx_int = 0.015;
    // float stepy_int = 0.01;

    std::ofstream out_dat("out.json");

    mandelbrot(grid, xst_int, yst_int, stepx_int, stepy_int);

    out_dat << "{ \"grid_int\": [ ";
    for (int i = 0; i < N; i++) {
        out_dat << "[";
        for (int j = 0; j < N; j++) {
            out_dat << grid[i][j] << (j != N-1 ? "," : " ");
            // out_dat << ys[i][0].to_int() << ", " << ys[i][1].to_int() << ", " << ys[i][2].to_int() << std::endl;
        }
        out_dat << "]" << (i != N-1 ? "," : " ");
    }
    out_dat << "] }";

    return 0;
}

