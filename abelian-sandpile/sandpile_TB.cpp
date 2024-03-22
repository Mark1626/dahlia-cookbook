#include <iostream>
#include <fstream>
#include <ap_int.h>
#include <ap_fixed.h>
#include <cassert>
#include <cstdint>
#include "sandpile.h"

int main() {
    const int N = 10;
    
    ap_uint<32> out_int[N][N];

    ap_uint<32> in_int[N][N] = {{0, 0 ,0 ,0 ,0 ,0, 0, 0, 0, 0},
              {0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0},
              {0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0},
              {0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0},
              {0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0},
              {0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0},
              {0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0},
              {0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0},
              {0, 6 ,6 ,6 ,6 ,6, 6, 6, 6, 0},
              {0, 0 ,0 ,0 ,0 ,0, 0, 0, 0, 0}};

    std::ofstream out_dat("out.json");

    sandpile(in_int, out_int);

    out_dat << "{ grid_int: [ ";
    for (int i = 0; i < N; i++) {
        out_dat << "[";
        for (int j = 0; j < N; j++) {
            out_dat << out_int[i][j] << (j != N-1 ? "," : " ");
            // out_dat << ys[i][0].to_int() << ", " << ys[i][1].to_int() << ", " << ys[i][2].to_int() << std::endl;
        }
        out_dat << "]" << (i != N-1 ? "," : " ");
    }
    out_dat << "] }";

    return 0;
}

