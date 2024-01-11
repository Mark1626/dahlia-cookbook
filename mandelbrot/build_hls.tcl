open_project -reset mandelbrot_prj

set_top mandelbrot

add_files mandelbrot.hls.cpp
add_files mandelbrot.h
add_files -tb mandelbrot_TB.cpp

open_solution "solution" -flow_target vivado

set_part {xcvu37p-fsvh2892-2L-e}

# set_part {xc7a35ticsg324-1L}

create_clock -period 10 -name default

# Simulation
csim_design

# Synth to Verilog/VHDL
csynth_design

# Cosim
cosim_design -trace_level all

exit
