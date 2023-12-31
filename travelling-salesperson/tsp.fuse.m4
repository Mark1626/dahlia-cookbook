define(`max_cities', 10)dnl
define(`max_cities_min_one', eval(max_cities-1))dnl
define(`mem_size', eval(max_cities*max_cities))dnl

def fact(n: ubit<32>): ubit<32> = {
    let ret: ubit<32> = 1;
    let i: ubit<32> = 2;
    while (i <= n) {
        ret := ret * i;
        i += 1;
    }
    return ret;
}

def min(a: ubit<32>, b: ubit<32>): ubit<32> = {
    if (a < b) {
        return a;
    } else {
        return b;
    }
}

def get_distance(perm: ubit<32>[max_cities], distance: ubit<16>[max_cities][max_cities]): ubit<32> = {
    let ret: ubit<32> = 0;
    for (let i=0..max_cities_min_one) {
        ret += (distance[perm[i]][perm[i+1]] as ubit<32>);
    }
    return ret;
}

def compute(idx: ubit<32>, distances: ubit<16>[max_cities][max_cities]): ubit<32> = {
    let perm: ubit<32>[max_cities];
    let i = idx;

    for (let k:ubit<4>=0..max_cities) {
        let n: ubit<4> = (max_cities-1-k as ubit<4>);
        let f: ubit<32> = fact(n);
        perm[k] := i / f;
        i := i % f;
    }

    ---

    let k: bit<5> = max_cities_min_one;
    while (k > 0) {
        let perm_k = perm[k];
        let j = k-1;
        ---
        while (j >= 0) {
            perm_k += ((perm[j] <= perm_k) as ubit<16>);
            j -= 1;
        }
        ---
        perm[k] := perm_k;
        k -= 1;
    }

    ---

    return get_distance(perm, distances);
}

decl dist_int: ubit<16>[mem_size];
decl shortest_dist_int: ubit<32>[1];

let distances: ubit<16>[max_cities][max_cities];


{
    for (let i=0..max_cities) {
        for (let j=0..max_cities) {
            distances[i][j] := dist_int[i*max_cities + j];
        }
    }
    ---
    let fact_n: ubit<32> = fact(max_cities_min_one);
    let candidate: ubit<32> = 0xfffffff;
    let i: ubit<32> = 0;

    while (i < fact_n) pipeline {
        candidate := min(candidate, compute(i, distances));
        i += 1;
    }
    ---
    shortest_dist_int[0] := candidate;
}
