vlib work
vlog -f src_files.list +cover -covercells
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave /top/SPI_slaveif/* 
add wave /top/DUT/inst/assert__valid_command_wr_addr /top/DUT/inst/assert__valid_command_wr_data \
/top/DUT/inst/assert__valid_command_rd_addr /top/DUT/inst/assert__valid_command_rd_data
add wave -position insertpoint \
/top/DUT/cs 
add wave -position insertpoint \
/top/DUT/received_address 
coverage save SPI_slave.ucdb -onexit
run -all
coverage exclude -src SPI_slave.sv -line 61 -code b
coverage exclude -src SPI_slave.sv -line 139 -code b
coverage exclude -src SPI_slave.sv -line 61 -code s
coverage exclude -src SPI_slave.sv -line 139 -code s
# vcover report SPI_slave.ucdb -details -annotate -all -output coverage_rpt.txt