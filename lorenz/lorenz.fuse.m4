define(`MAX_STEPS', 16384)dnl

record state {
    x: float;
    y: float;
    z: float
}

def st_scale(h: float, s: state): state = {
    let ns: state = { x=h*s.x; y=h*s.y; z=h*s.z };
    return ns;
}

def st_add(a: state, b: state): state = {
    let c: state = { x=a.x+b.x; y=a.y+b.y; z=a.z+b.z };
    return c;
}

def f(s: state, t: float): state = {
    let sigma: float = 10.0;
    let beta: float = 8.0 / 3.0;
    let rho: float = 28.0;

    let nx = sigma * (s.y - s.x);
    let ny = s.x * (rho - s.z);
    let nz = s.x * s.y - beta * s.z;
    let next_state: state = { x=nx; y=ny; z=nz };

    return next_state;
}

def rk2(ys: state[MAX_STEPS], dt: float, N: ubit<32>) = {
    let h = dt;
    let h_2 = dt * 0.5;
    let offset: ubit<32> = 1;
    let current_y = ys[0];

    ---

    decor "rk_loop:"
    for (let i=1..MAX_STEPS) {
        if (i < N) {
            let idx = i + offset;
            let t = dt * (idx as float);

            let k1: state = st_scale(h, f(current_y, t));

            let k2_y: state = st_add(current_y, st_scale(0.5, k1));
            let k2: state = st_scale(h, f(k2_y, t + h_2));

            let next_y = st_add(current_y, st_scale(1.0/6.0, st_add(k1, k2)));

            current_y := next_y;
            ys[i] := next_y;
        }
    }
}

decl init_int: float[3];
decl ys_int: float[MAX_STEPS][3];
decl N: ubit<32>;
decl dt: float;

let empty: state = { x=0.0; y=0.0; z=0.0 };

{
    let ys: state[MAX_STEPS];

    let init_x: float = init_int[0];
    ---
    let init_y: float = init_int[1];
    ---
    let init_z: float = init_int[2];
    let initial_st: state = { x=init_x; y=init_y; z=init_z };

    ---

    ys[0] := initial_st;
    ---

    rk2(ys, dt, N);

    decor "out_loop:"
    for (let i=0..MAX_STEPS) {
        if (i < N) {
            ys_int[i][0] := ys[i].x;
            ---
            ys_int[i][1] := ys[i].y;
            ---
            ys_int[i][2] := ys[i].z;
        }
    }
}
