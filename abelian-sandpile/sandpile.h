#ifndef SANDPILE_H
#define SANDPILE_H

#include <ap_int.h>
#include <ap_fixed.h>

extern "C" {
    void sandpile(ap_uint<32> in_int[10][10], ap_uint<32> out_int[10][10]);
}

#endif
