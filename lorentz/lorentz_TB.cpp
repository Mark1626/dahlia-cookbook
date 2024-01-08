#include <iostream>
#include <ap_int.h>
#include "lorentz.h"

int main() {
    int N = 1024;
    float ys[N][3];

    lorentz(ys, N);
}
