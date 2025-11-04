vlib work
vlog -f src_files.list +cover -covercells +define+SIM
vsim -voptargs=+acc work.SPI_wrapper_top -classdebug -uvmcontrol=all -cover
add wave /SPI_wrapper_top/SPI_wrapperif/* 
add wave -position insertpoint \
/SPI_wrapper_top/SPI_wrapper_instance/SLAVE_instance/received_address \
/SPI_wrapper_top/SPI_wrapper_instance/SLAVE_instance/cs 

coverage save SPI_wrapper.ucdb -onexit
run -all
coverage exclude -src RAM.v -line 29 -code s
coverage exclude -src RAM.v -line 29 -code b
coverage exclude -src SPI_slave.sv -line 60 -code b
coverage exclude -src SPI_slave.sv -line 136 -code b
coverage exclude -src SPI_slave.sv -line 136 -code s
coverage exclude -src SPI_slave.sv -line 60 -code s
# vcover report SPI_wrapper.ucdb -details -annotate -all -output coverage_rpt.txt
