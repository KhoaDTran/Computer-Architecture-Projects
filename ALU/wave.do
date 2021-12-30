onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alustim/delay
add wave -noupdate /alustim/ALU_PASS_B
add wave -noupdate /alustim/ALU_ADD
add wave -noupdate /alustim/ALU_SUBTRACT
add wave -noupdate /alustim/ALU_AND
add wave -noupdate /alustim/ALU_OR
add wave -noupdate /alustim/ALU_XOR
add wave -noupdate -radix decimal /alustim/A
add wave -noupdate -radix decimal /alustim/B
add wave -noupdate /alustim/cntrl
add wave -noupdate -radix decimal /alustim/result
add wave -noupdate /alustim/negative
add wave -noupdate /alustim/zero
add wave -noupdate /alustim/overflow
add wave -noupdate /alustim/carry_out
add wave -noupdate /alustim/i
add wave -noupdate /alustim/test_val
add wave -noupdate /alustim/dut/addy_64_01X/a
add wave -noupdate /alustim/dut/addy_64_01X/b
add wave -noupdate /alustim/dut/addy_64_01X/ci
add wave -noupdate /alustim/dut/addy_64_01X/result
add wave -noupdate /alustim/dut/addy_64_01X/co
add wave -noupdate /alustim/dut/addy_64_01X/overflow
add wave -noupdate /alustim/dut/addy_64_01X/carry_bits
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {636363636 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 419
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 50
configure wave -gridperiod 100
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {4156250 ns}
