# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./mux2_1.sv"
vlog "./d_ff.sv"
vlog "./d_ff_enable.sv"
vlog "./dec2x4.sv"
vlog "./dec3x8.sv"
vlog "./mux4_1.sv"
vlog "./mux32_1.sv"
vlog "./mux32_64.sv"
vlog "./regFile.sv"
vlog "./regstim.sv"
vlog "./dec5x32.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work regstim

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
