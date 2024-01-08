#ifndef lorenz_H
#define lorenz_H

#define LORENZ_MAX_STEPS 16384

extern "C" {
    void lorenz(float init_int[3], float ys_int[LORENZ_MAX_STEPS][3], ap_uint<32> N, float dt);
}

#endif
