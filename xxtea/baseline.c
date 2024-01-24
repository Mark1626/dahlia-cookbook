#include <stddef.h>
#include <stdio.h>
#include <stdint.h>
#include <time.h>

// https://github.com/xxtea/xxtea-c/blob/master/xxtea.c#L158

#define MX (((z >> 5) ^ (y << 2)) + ((y >> 3) ^ (z << 4))) ^ ((sum ^ y) + (key[(p & 3) ^ e] ^ z))
#define DELTA 0x9e3779b9

static uint32_t * xxtea_uint_encrypt(uint32_t * data, size_t len, uint32_t * key) {
    uint32_t n = (uint32_t)len - 1;
    uint32_t z = data[n], y, p, q = 6 + 52 / (n + 1), sum = 0, e;

    if (n < 1) return data;

    while (0 < q--) {
        sum += DELTA;
        e = sum >> 2 & 3;

        for (p = 0; p < n; p++) {
            y = data[p + 1];
            z = data[p] += MX;
        }

        y = data[0];
        z = data[n] += MX;
    }

    return data;
}

static uint32_t
hash32(uint32_t x)
{
    x ^= x >> 15; x *= 0xd168aaad;
    x ^= x >> 15; x *= 0xaf723597;
    x ^= x >> 15;
    return x;
}

void test_gen() {
    long long n = 1LL<<36;
    uint32_t seed = hash32(time(0));
    uint32_t k[4] = {
        hash32(seed ^ 1), hash32(seed ^ 2),
        hash32(seed ^ 3), hash32(seed ^ 4),
    };

    uint32_t i = 1024;
    uint32_t x = hash32(seed ^ (uint32_t)(i>>30));
    uint32_t b[4] = {
        x ^ hash32(i*4 + 0), x ^ hash32(i*4 + 1),
        x ^ hash32(i*4 + 2), x ^ hash32(i*4 + 3),
    };

    printf("seed  = %08lx\n", (long)seed);
    printf("key   = %08lx %08lx %08lx %08lx\n",
           (long)k[0], (long)k[1], (long)k[2], (long)k[3]);
    printf("key   = %08ld %08ld %08ld %08ld\n",
           (long)k[0], (long)k[1], (long)k[2], (long)k[3]);

    printf("val   = %08lx %08lx %08lx %08lx\n",
           (long)b[0], (long)b[1], (long)b[2], (long)b[3]);
    printf("val   = %08ld %08ld %08ld %08ld\n",
           (long)b[0], (long)b[1], (long)b[2], (long)b[3]);
}

int main() {
    uint32_t data[4] = {294226741, 1247298633, 1769166444, 1156150612};
    uint32_t len = 4;
    uint32_t key[4] = {3084500778, 2173392622, 3931938540, 2382584999};

    xxtea_uint_encrypt(data, len, key);

    printf("val   = %08ld %08ld %08ld %08ld\n",
           (long)data[0], (long)data[1], (long)data[2], (long)data[3]);
}
