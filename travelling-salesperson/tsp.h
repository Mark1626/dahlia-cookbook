#ifndef TSP_H
#define TSP_H

#define N 10

extern "C" {

void tsp(ap_uint<16> dist_int[N*N], ap_uint<32> shortest_dist_int[1]);

}

#endif
