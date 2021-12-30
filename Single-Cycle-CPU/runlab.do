# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./mux2_1.sv"
vlog "./mux2_64.sv"
vlog "./mux4_1.sv"
vlog "./mux8_1.sv"
vlog "./mux8_64.sv"
vlog "./a_and_b.sv"
vlog "./a_xor_b.sv"
vlog "./fulladder.sv"
vlog "./adder_64.sv"
vlog "./PCadder.sv"
vlog "./a_or_b.sv"
vlog "./check_zero.sv"
vlog "./alu.sv"

vlog "./controlLogic.sv"
vlog "./CPU_ARM64bit.sv"
vlog "./d_ff.sv"
vlog "./d_ff_enable.sv"
vlog "./datamem.sv"
vlog "./datapath.sv"
vlog "./dec2x4.sv"
vlog "./dec3x8.sv"
vlog "./dec5x32.sv"
vlog "./flagRegs.sv"
vlog "./instruction.sv"
vlog "./instructmem.sv"
vlog "./math.sv"
vlog "./mux10_5.sv"
vlog "./mux32_1.sv"
vlog "./mux32_64.sv"
vlog "./mux128_64.sv"
vlog "./mux256_64.sv"
vlog "./pc.sv"
vlog "./regFile.sv"
#vlog "./signExtend.sv"
#vlog "./zeroExtend.sv"


# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work CPU_ARM64bit_testbench

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
