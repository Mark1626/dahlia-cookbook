define(`GRID_SIZE_X', 256)dnl
define(`GRID_SIZE_Y', 256)dnl
define(`MAX_ITER', 32)dnl
define(`dtype', `fix<32,16>')dnl
define(`GRID_BANKS', `8')dnl

record complex {
    real: dtype;
    imag: dtype
}

def complex_fma(a: complex, b: complex, c: complex): complex = {
    let cr: dtype = c.real + (a.real * b.real) - (a.imag * b.imag);
    let ci: dtype = c.imag + (a.real * b.imag) + (a.imag * b.real);
    let res: complex = { real=cr; imag=ci };
    return res;
}

def complex_mul(a: complex, b: complex): complex = {
    let cr: dtype = (a.real * b.real) - (a.imag * b.imag);
    let ci: dtype = (a.real * b.imag) + (a.imag * b.real);
    let c: complex = { real=cr; imag=ci };
    return c;
}

def complex_add(a: complex, b: complex): complex = {
    let cr: dtype = a.real + b.real;
    let ci: dtype = a.imag + b.imag;
    let c: complex = { real=cr; imag=ci };
    return c;
}

decl grid_int: ubit<8>[GRID_SIZE_X][GRID_SIZE_Y];
decl xst_int: dtype;
decl yst_int: dtype;
decl stepx_int: dtype;
decl stepy_int: dtype;

{
    let grid: ubit<8>[GRID_SIZE_X][GRID_SIZE_Y];
    let xst: dtype = xst_int;
    let yst: dtype = yst_int;

    let stepx: dtype = stepx_int;
    let stepy: dtype = stepy_int;

    for (let y=0..GRID_SIZE_Y) {
        for (let x=0..GRID_SIZE_X) {
            let cx: dtype = ((x - 1) as dtype)*stepx + xst;
            let cy: dtype = ((y - 1) as dtype)*stepy + yst;
            let c: complex = { real=cx; imag=cy };

            let z: complex = { real=0.0; imag=0.0 };
            let count: ubit<8> = 0;
            while ((count < MAX_ITER) && ((z.real * z.real + z.imag * z.imag) < (4 as dtype))) {
                decor "#pragma HLS loop tripcount max=MAX_ITER min=1"
                let z1 = complex_fma(z, z, c);
                count += 1;
                ---
                z := z1;
            }
            grid[y][x] := count;
        }
    }

    ---

    for (let y=0..GRID_SIZE_Y) {
        for (let x=0..GRID_SIZE_X) {
            grid_int[y][x] := grid[y][x];
        }
    }
}
