# SPI Slave with Single Port RAM - UVM Verification Project

## 📌 Overview

This repository hosts a robust **SystemVerilog/UVM Verification Environment** for a digital system comprising an **SPI Slave** interface and a **Single Port RAM**. The project demonstrates a scalable verification architecture, moving from block-level verification to full system integration verification.

The verification process is divided into three strategic phases:

1.  **Phase 1: SPI Slave Verification** (Block Level)
2.  **Phase 2: Single Port RAM Verification** (Block Level)
3.  **Phase 3: SPI Wrapper Integration** (System Level)

---

## 📖 Table of Contents

- [Team Members](#-team-members)
- [Project Architecture](#%EF%B8%8F-project-architecture)
- [Detailed Component Analysis](#%EF%B8%8F-detailed-component-analysis)
    - [Part 1: SPI Slave](#part-1-spi-slave-components)
    - [Part 2: Single Port RAM](#part-2-ram-components)
    - [Part 3: Wrapper Integration](#part-3-wrapper-integration)
- [📊 Functional Coverage & Assertions](#-functional-coverage--assertions)
- [🧪 Sequences & Stimulus](#-sequences--stimulus-generation)
- [🔗 Integration Strategy](#-integration--reuse-strategy)
- [🚀 How to Run](#-how-to-run)

---

## 👥 Team Members

**Team Name:** Clean Code

| Name | Role |
| :--- | :--- |
| **Abdelrahman Adwe Ali** | Verification Engineer |
| **Youssef Mohamed Elsayed Taha** | Verification Engineer |
| **Mohamed Elsayed Ebrahim** | Verification Engineer |

---
## 🏗️ Project Architecture

The verification environment follows a **Flat Integration UVM Architecture** as shown in the diagram below. This structure maximizes reuse and decoupling between blocks.

[UVM Architecture](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Docs/UVM_Architecture.png)

### Architectural Description :

1. **Top-Level Hierarchy (`uvm_test`):** The `uvm_test` class acts as the central coordinator. Instead of nesting environments, it instantiates **three parallel environments**:
    
    - **`wrapper_env` (Active):** Contains an **Active Agent** (Sequencer & Driver) responsible for driving the system inputs (MOSI, SS_n, CLK).
        
    - **`slave_env` (Passive):** Contains a **Passive Agent** (Monitor only) to observe the internal SPI interface behavior without driving it.
        
    - **`ram_env` (Passive):** Contains a **Passive Agent** (Monitor only) to observe the RAM interface behavior and verify memory operations.
        
2. **Configuration Database (`uvm_config_db`):** As depicted by the red arrows, the `uvm_config_db` is the backbone for connectivity:
    
    - **Interfaces (Set/Get):** The `top module` sets the virtual interfaces (`WRAPPER_IF`, `SLAVE_IF`, `RAM_IF`). These are retrieved ("Get") by the monitors and drivers within the agents.
        
    - **Configurations (Set/Get):** The `uvm_test` configures the agents' modes. It sets `is_active = UVM_ACTIVE` for the Wrapper Agent and `UVM_PASSIVE` for the Slave and RAM Agents.
        
3. **Scoreboards & Coverage:** Each environment retains its own **Scoreboard** and **Coverage Collector**. This allows for precise error localization (knowing exactly which block failed) and ensures 100% coverage is maintained from block-level verification.
## 🏗️ Detailed Component Analysis

This section breaks down the project into its three constituent sub-projects.

### Part 1: SPI Slave Components

This part verifies the **SPI Slave Protocol**. It handles the Serial-to-Parallel conversion and FSM control.

* **📂 RTL Design**
    * [`SPI_slave.sv`](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part1/SPI_slave/SPI_slave.sv): Main DUT. Handles MOSI/MISO logic and FSM states (`IDLE`, `CHK_CMD`, `WRITE`, `READ`).

* **📂 UVM Agent (SPI_Slave_Agent)**
    * [`SPI_slave_driver.sv`](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part1/SPI_slave/SPI_slave_driver.sv): Drives `MOSI`, `SS_n`, and `clk`.
    * [`SPI_slave_monitor.sv`](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part1/SPI_slave/SPI_slave_monitor.sv): Monitors the interface and broadcasts transactions.
    * [`SPI_slave_config.sv`](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part1/SPI_slave/SPI_slave_config.sv): Configuration object (Active/Passive modes).

* **📂 Environment**
    * [`SPI_slave_scoreboard.sv`](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part1/SPI_slave/SPI_slave_scoreboard.sv): Compares DUT output vs. Golden Model.
    * [`SPI_slave_sva.sv`](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part1/SPI_slave/SPI_slave_sva.sv): SystemVerilog Assertions module.

### Part 2: RAM Components

This part verifies the **Single Port RAM** storage.

* **📂 RTL Design**
    * [`RAM.v`](./RAM/RTL/RAM.v): Memory module (Depth: 256, Width: 8-bit).

* **📂 UVM Agent (RAM_Agent)**
    * [`RAM_driver.sv`](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part2/RAM/RAM_driver.sv): Drives memory write/read signals (`din`, `rx_valid`).
    * [`RAM_monitor.sv`](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part2/RAM/RAM_monitor.sv): Monitors memory transactions.
    * [`RAM_coverage_collector.sv`](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part2/RAM/RAM_coverage_collector.sv): Functional coverage collector.

### Part 3: Wrapper Integration

System-level verification connecting SPI Slave to RAM.

* **📂 RTL Design**
    * [`WRAPPER.sv`](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part3/SPI_wrapper/WRAPPER.sv): Instantiates `SPI_slave` and `RAM` and wires them together.
    * [`WRAPPER_GM.v`](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part3/SPI_wrapper/WRAPPER_GM.v): Golden Model for the entire system.

* **📂 Environment**
    * [`SPI_wrapper_test.sv`](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part3/SPI_wrapper/SPI_wrapper_test.sv): **The Integration Hub**. Instantiates all three environments (`Wrapper`, `Slave`, `RAM`) to verify end-to-end logic while reusing block-level checkers.

---

## 📊 Functional Coverage & Assertions

We utilized **100% Code Coverage** and **100% Functional Coverage** criteria. [cite_start]Below is the detailed list of all assertions implemented in the SVA files[cite: 1, 6, 43, 61].

### 🔹 Part 1: SPI Slave Assertions [(`SPI_slave_sva.sv`)](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part1/SPI_slave/SPI_slave_sva.sv)

[cite_start]These assertions verify the protocol timing and FSM state transitions[cite: 6, 8].

| Assertion Name | Description |
| :--- | :--- |
| **`MISO_reset`** | Ensures `MISO` is 0 when `rst_n` is asserted. |
| **`rx_valid_reset`** | Ensures `rx_valid` is 0 when `rst_n` is asserted. |
| **`rx_data_reset`** | Ensures `rx_data` is 0 when `rst_n` is asserted. |
| **`valid_command_wr_addr`** | After a valid Write Address command (000), `rx_valid` must assert exactly 10 cycles later. |
| **`valid_command_wr_data`** | After a valid Write Data command (001), `rx_valid` must assert exactly 10 cycles later. |
| **`valid_command_rd_addr`** | After a valid Read Address command (110), `rx_valid` must assert exactly 10 cycles later. |
| **`valid_command_rd_data`** | After a valid Read Data command (111), `rx_valid` must assert exactly 10 cycles later. |
| **`IDLE_to_CHK_CMD`** | FSM Check: If `SS_n` falls while in `IDLE`, the next state must be `CHK_CMD`. |
| **`CHK_CMD_to_write`** | FSM Check: In `CHK_CMD`, if `MOSI` is 0 (Write), next state must be `WRITE`. |
| **`CHK_CMD_read_address`** | FSM Check: In `CHK_CMD`, if `MOSI` is 1 and address not received, next state is `READ_ADD`. |
| **`CHK_CMD_to_read_data`** | FSM Check: In `CHK_CMD`, if `MOSI` is 1 and address is received, next state is `READ_DATA`. |
| **`WRITE_to_IDLE`** | FSM Check: From `WRITE`, if `SS_n` rises, return to `IDLE`. |
| **`READ_ADD_to_IDLE`** | FSM Check: From `READ_ADD`, if `SS_n` rises, return to `IDLE`. |
| **`READ_DATA_to_IDLE`** | FSM Check: From `READ_DATA`, if `SS_n` rises, return to `IDLE`. |

### 🔹 Part 2: RAM Assertions [(`ram_sva.sv`)](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part3/SPI_wrapper/RAM_SVA.sv)

[cite_start]These assertions verify the memory interface handshaking[cite: 43].

| Assertion Name | Description |
| :--- | :--- |
| **`reset`** | Checks that `dout` and `tx_valid` are 0 when `rst_n` is active. |
| **`tx_deasserted`** | Ensures `tx_valid` remains 0 during Address or Write Data phases (when `din[9:8]` is NOT `11`). |
| **`tx_asserted`** | Checks that `tx_valid` asserts and then deasserts correctly after a Read Data command (`11`). |
| **`write_assert`** | Verifies ordering: A Write Address (`00`) must be followed by either Write Data (`01`) or another Write Address (`00`). |
| **`read_assert`** | Verifies ordering: A Read Address (`10`) must be followed by either Read Data (`11`) or another Read Address (`10`). |

### 🔹 Part 3: Wrapper Assertions [(`SPI_wrapper_sva.sv`)](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM/blob/main/Part3/SPI_wrapper/SPI_wrapper_sva.sv)

[cite_start]System-level assertions checking the integration points[cite: 61, 62].

| Assertion Name | Description |
| :--- | :--- |
| **`MISO_reset`** | Wrapper Level: `MISO` must be 0 upon reset. |
| **`rx_valid_reset`** | Wrapper Level: Internal `rx_valid` must be 0 upon reset. |
| **`rx_data_reset`** | Wrapper Level: Internal `rx_data` must be 0 upon reset. |
| **`MISO_stable`** | Ensures `MISO` remains stable (does not change) when the system is **not** in the `READ_DATA` state. |

---

## 🧪 Sequences & Stimulus Generation

### 1. SPI Slave Sequences
* **`SPI_slave_write_sequence`**: constrained `SS_n` duration (13 cycles).
* **`SPI_slave_read_sequence`**: constrained `SS_n` duration (23 cycles for Read Data).
* **`SPI_slave_read_write_sequence`**: Randomized mix of all operations.

### 2. RAM Sequences
* **`RAM_write_only_seq`**: Generates `00` (Addr) followed by `01` (Data).
* **`RAM_write_and_read_seq`**: Complex sequence mixing Read/Write with 60/40 distribution weights.

### 3. Wrapper Sequences
* **`SPI_wrapper_read_write_sequence`**: Full stress test driving the external SPI interface to verify internal memory operations.

---

## 🔗 Integration & Reuse Strategy

To maximize reuse and simplify debugging, we implemented a **Flat Integration Strategy** within the Test Layer rather than embedding environments.

### 1. Composition in Test Layer

Instead of nesting `Slave` and `RAM` environments inside the `Wrapper` environment, we instantiate **all three environments** directly inside the **`SPI_wrapper_test`**:

```
class SPI_wrapper_test extends uvm_test;
    SPI_wrapper_env   wrapper_env;  // Drives System Inputs (Active)
    SPI_slave_env     slave_env;    // Monitors Slave Internal Interfaces (Passive)
    RAM_environment   ram_env;      // Monitors RAM Internal Interfaces (Passive)
    ...
endclass
```

### 2. Why this architecture? (Debuggability)

This structure ensures that the **Block-Level Scoreboards** and **Coverage Collectors** remain active during system simulation.

- **Pinpointing Errors:** If the simulation fails, the error message will come from a specific scoreboard:
    
    - If `SPI_slave_scoreboard` reports an error -> The issue is in protocol decoding.
        
    - If `RAM_scoreboard` reports an error -> The issue is in memory storage/retrieval.
        
    - If `SPI_wrapper_scoreboard` reports an error -> The issue is in the wiring or end-to-end logic.
        
- **No Duplicate Code:** We do not need to rewrite assertions or coverage bins for the Wrapper; we simply reuse the existing ones.
    

### 3. Active vs. Passive Configuration

In `SPI_wrapper_test`, we configure the agents using `uvm_config_db`:

- **Wrapper Agent:** Set to `UVM_ACTIVE` to drive `MOSI`, `SS_n`, `clk`.
    
- **Slave & RAM Agents:** Set to `UVM_PASSIVE` to only monitor the internal signals without driving them.
## 🚀 How to Run

### 1. Clone the Repository

```
git clone [https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM.git](https://github.com/abdelrahmanadwe/SPI-slave-with-single-port-RAM.git)
cd SPI-slave-with-single-port-RAM
```

### 2. Run Simulation (TCL Commands)

#### ➤ SPI Slave Standalone

```
vlib work
vlog -f src_files_spi.list +cover -covercells +define+SIM
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover
add wave /top/SPI_slaveif/*
run -all
coverage save SPI_slave.ucdb -onexit
```

#### ➤ Single Port RAM Standalone

```
vlib work
vlog -cover bcesft +acc -f src_files_ram.list
vsim -coverage -voptargs=+acc work.top -classdebug -uvmcontrol=all
run -all
```

#### ➤ Run Wrapper (Full System)

Tcl

```
vlib work
# Compile with Cover flags and SIM macro for assertions
vlog -f src_files_wrapper.list +cover=bcesft +define+SIM

# Run Simulation with UVM control
vsim -voptargs=+acc work.SPI_wrapper_top -classdebug -uvmcontrol=all -cover

# Add Waves
add wave /SPI_wrapper_top/SPI_wrapperif/*

# Run
run -all

# Extract Coverage
coverage save SPI_wrapper.ucdb -onexit
vcover report SPI_wrapper.ucdb -details -annotate -all -output coverage_rpt.txt
```

---

**Designed & Verified by Clean Code Team © 2025**
