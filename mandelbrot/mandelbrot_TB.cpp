#include <iostream>
#include <fstream>
#include <ap_int.h>
#include <ap_fixed.h>
#include <cassert>
#include <cstdint>
#include "mandelbrot.h"

int main() {
    int N = 256;
    
    ap_fixed<32, 16> grid[N][N];

    std::ofstream out_dat("out.json");

    lorenz(init_state, ys, N, dt);

    out_dat << "{ grid_int: [ ";
    for (int i = 0; i < N; i++) {
        out_dat << "[";
        for (int j = 0; j < N; j++) {
            out_dat << grid[i][j] << (j != N-1 ? "," : " ");
            // out_dat << ys[i][0].to_int() << ", " << ys[i][1].to_int() << ", " << ys[i][2].to_int() << std::endl;
        }
        out_dat << "]" << (i != N-1 ? "," : " ");
    }
    out_dat << "] }"

    return 0;
}

