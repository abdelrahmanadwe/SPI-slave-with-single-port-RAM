vlib work
vmap work work
vlog -cover bcesft +acc -f src_files.list
vsim -coverage -voptargs=+acc work.top -classdebug -uvmcontrol=all
add wave /top/IF/*
coverage save RAM.ucdb -onexit
run -all
coverage exclude -src RAM.v -line 29 -code b
coverage exclude -src RAM.v -line 29 -code s
#quit -sim
#vcover report RAM.ucdb -details -code bcesft -output coverage_report.txt