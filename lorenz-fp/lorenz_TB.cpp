#include <iostream>
#include <fstream>
#include <ap_int.h>
#include <ap_fixed.h>
#include <cassert>
#include <cstdint>
#include "lorenz.h"

int main() {
    int N = 16384;
    ap_fixed<32, 16> ys[N][3];
    ap_fixed<32, 16> dt = 0.03;
    ap_fixed<32, 16> init_state[3] = { 1.0, 1.0, 1.0 };

    std::ofstream out_dat("out.dat");

    assert(N <= LORENZ_MAX_STEPS);

    lorenz(init_state, ys, N, dt);

    for (int i = 0; i < N; i++) {
        out_dat << ys[i][0].to_int() << ", " << ys[i][1].to_int() << ", " << ys[i][2].to_int() << std::endl;
    }

    return 0;
}
