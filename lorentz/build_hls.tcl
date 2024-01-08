open_project -reset lorentz_prj

set_top lorentz

add_files lorentz.hls.cpp
add_files lorentz.h
add_files -tb lorentz_TB.cpp

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
