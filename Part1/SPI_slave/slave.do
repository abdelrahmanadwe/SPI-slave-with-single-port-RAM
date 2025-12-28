# ==========================================================================
#                           CONFIGURATION
# ==========================================================================
# 1. File List containing all RTL & TB files (paths inside)
set FILE_LIST "src_files.list"

# 2. The Top Module Name (The one containing run_test())
set TOP_MODULE "top"

# 3. Default UVM Test Name (Used if no argument is passed)
set UVM_TEST_NAME "SPI_slave_test"

# ==========================================================================
#                              COMPILATION
# ==========================================================================
vlib work

# Compile using the file list (-f)
# +cover: Enable code coverage
# -covercells: Enable coverage for library cells (optional)
vlog -f $FILE_LIST +cover -covercells


# ==========================================================================
#                          ARGUMENT PARSING
# ==========================================================================
# Argument 1: UVM Test Name (Class Name)
if {$argc > 0} {
    set UVM_TEST_NAME $1
}

# Argument 2: Action (debug or report)

set action "debug"
if {$argc > 1} {
    set action $2
}

# ==========================================================================
#                           4. SIMULATION SETUP
# ==========================================================================
echo "-----------------------------------------------------------------"
echo "Starting Simulation for Test Case: $UVM_TEST_NAME"
echo "Mode: $action"
echo "-----------------------------------------------------------------"

# vsim Arguments Explanation:
# -onfinish stop    : Prevents $finish from quitting the GUI immediately.
# -voptargs=+acc    : Enables visibility for debugging.
# -classdebug       : Allows inspection of UVM classes/objects.
# -uvmcontrol=all   : Enables UVM transaction recording in Wave window.
# +UVM_TESTNAME     : Passes the test name to the UVM phasing mechanism.

vsim -onfinish stop -voptargs=+acc work.$TOP_MODULE \
     -classdebug -uvmcontrol=all -msgmode both -cover \
     +UVM_TESTNAME=$UVM_TEST_NAME \
     +UVM_VERBOSITY=UVM_LOW


# --- Waveform Setup (Debug Mode Only) ---
if {$action == "debug"} {
    # Clear previous waves
    delete wave *
    
    # Add your standard waves here 
    # You can also use 'do wave.do' if you have a saved wave file
    add wave /top/SPI_slaveif/* 
    
    # Example: Adding assertions
    
    add wave /top/DUT/inst/assert__valid_command_wr_addr /top/DUT/inst/assert__valid_command_wr_data \
    /top/DUT/inst/assert__valid_command_rd_addr /top/DUT/inst/assert__valid_command_rd_data
    add wave -position insertpoint \
    /top/DUT/cs 
    add wave -position insertpoint \
    /top/DUT/received_address 
}

# Run Simulation
run -all


# ==========================================================================
#                        REPORTING & EXIT
# ==========================================================================

# Save Coverage Database (Name it after the Test Case)
coverage exclude -src SPI_slave.sv -line 61 -code b
coverage exclude -src SPI_slave.sv -line 139 -code b
coverage exclude -src SPI_slave.sv -line 61 -code s
coverage exclude -src SPI_slave.sv -line 139 -code s

coverage save ${UVM_TEST_NAME}.ucdb 

# Handle Reporting and Exit
if {$action == "report"} {
    echo "Generating Coverage Report for $UVM_TEST_NAME..."
    
    vcover report ${UVM_TEST_NAME}.ucdb -details -annotate -all -output coverage_rpt.txt
    
    echo "Done. Exiting..."
    quit -sim
} else {
    echo "Simulation finished. You are in Debug Mode."
}