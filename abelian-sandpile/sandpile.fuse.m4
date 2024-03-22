define(`GRID_SIZE_X', 8)dnl
define(`GRID_SIZE_Y', 8)dnl
define(`X', eval(GRID_SIZE_X+2))dnl
define(`Y', eval(GRID_SIZE_Y+2))dnl
define(`ROW', eval(X-1))dnl
define(`COL', eval(Y-1))dnl

decl in_int: ubit<32>[X][Y];
decl out_int: ubit<32>[X][Y];

let state: ubit<32>[2][X][Y];
let temp: ubit<32>[X][Y];

let spills: ubit<32> = 1;
let iterations = 0;
let current: ubit<4> = 0;
let next: ubit<4> = 1;

{
    for(let i = 0..X) {
        for(let j = 0..Y) {
            temp[i][j] := in_int[i][j];
        }
    }
    ---
    for(let i = 0..X) {
        for(let j = 0..Y) {
            state[0][i][j] := temp[i][j];
        }
    }
    ---
    for(let i = 0..X) {
        for(let j = 0..Y) {
            state[1][i][j] := temp[i][j];
        }
    }
    ---
    while(spills != 0) {
        spills := 0;
        for(let y = 1..ROW) {
            for(let x = 1..COL) {
                let currSand : ubit<32> = state[current][y][x];
                let newSand : ubit<32>;
                if (currSand >= 4) {
                    newSand := currSand - 4;
                } else
                {
                    newSand := currSand;
                }
                if(currSand >= 4) {
                    spills += 1;
                }
                ---
                if(state[current][y - 1][x] >= 4) {
                    newSand += 1;
                }
                ---
                if(state[current][y + 1][x] >= 4) {
                    newSand += 1;
                }
                ---
                if(state[current][y][x + 1] >= 4) {
                    newSand += 1;
                }
                ---
                if(state[current][y][x - 1] >= 4) {
                    newSand += 1;
                }
                ---
                state[next][y][x] := newSand;
                ---
            }
        }
                iterations += 1;
                current := (current + 1) & 1;
                next := (next + 1) & 1;
    }
    ---
    for(let i = 0..X) {
        for(let j = 0..Y) {
            out_int[i][j] := state[current][i][j];
        }
    }
}
