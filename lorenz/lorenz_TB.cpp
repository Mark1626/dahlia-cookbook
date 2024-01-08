#include <iostream>
#include <fstream>
#include <ap_int.h>
#include <cassert>
#include "lorenz.h"

int main() {
    int N = 16384;
    float ys[N][3];
    float dt = 0.03;
    float init_state[3] = { 1.0, 1.0, 1.0 };

    std::ofstream out_dat("out.dat", std::ios::binary);

    assert(N <= LORENZ_MAX_STEPS);

    lorenz(init_state, ys, N, dt);

    for (int i = 0; i < N; i++) {
        out_dat << ys[i][0] << ", " << ys[i][1] << ", " << ys[i][2] << std::endl;
    }

    return 0;
}
