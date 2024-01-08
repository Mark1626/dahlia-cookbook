#ifndef lorenz_H
#define lorenz_H

#define LORENZ_MAX_STEPS 16384

extern "C" {
    void lorenz(ap_fixed<32, 16> init_int[3], ap_fixed<32, 16> ys_int[LORENZ_MAX_STEPS][3], ap_uint<32> N, ap_fixed<32, 16> dt);
}

#endif
