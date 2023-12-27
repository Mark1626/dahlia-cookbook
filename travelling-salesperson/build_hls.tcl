open_project -reset tsp_prj

set_top tsp

add_files tsp.hls.cpp
add_files tsp.hls.h
add_files -tb tsp_TB.cpp

open_solution "solution" -flow_target vivado

# set_part {xcvu37p-fsvh2892-2L-e}

set_part {xc7a35ticsg324-1L}

create_clock -period 10 -name default

# Simulation
csim_design

# Synth to Verilog/VHDL
csynth_design

# Cosim
# cosim_design -trace_level all -enable_dataflow_profiling

exit
