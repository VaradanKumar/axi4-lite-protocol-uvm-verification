# AXI4-Lite Protocol UVM Verification Environment

A complete SystemVerilog UVM (Universal Verification Methodology) testbench and verification environment for verifying an AXI4-Lite Slave memory/register module.

---

## 📌 Architecture Overview

```
                      +-------------------------------------------------+
                      |                    axi_top                      |
                      |  +------------------+     +------------------+  |
                      |  |   axi4_lite_if   | <-> | axi4_lite_slave  |  |
                      |  +------------------+     |     (DUT)        |  |
                      |           ^               +------------------+  |
                      +-----------|-------------------------------------+
                                  |
                                  v
+-----------------------------------------------------------------------+
|                                axi_env                                |
|  +-------------------------------------+     +---------------------+  |
|  |              axi_agent              |     |   axi_scoreboard    |  |
|  |  +---------------+  +------------+  |     |                     |  |
|  |  | axi_sequencer |  | axi_driver |  |     |  - Golden Mem Model |  |
|  |  +---------------+  +------------+  |     |  - Response Checker |  |
|  |         |                 |         |     |  - Pass/Fail Stats  |  |
|  |         v                 v         |     +---------------------+  |
|  |       [seq]            [vif.cb]     |                ^             |
|  |                                     |                |             |
|  |  +-------------------------------+  |                |             |
|  |  |          axi_monitor          |--|-(analysis_port)+             |
|  |  +-------------------------------+  |                              |
|  +-------------------------------------+                              |
+-----------------------------------------------------------------------+
```

---

## 📂 Directory Structure

```
axi_uvm/
├── agent/
│   ├── axi_transaction.sv   # Transaction item with constraints (addr, data, write/read dist)
│   ├── axi_driver.sv        # Active driver handling parallel AW/W & AR/R transfers
│   ├── axi_monitor.sv       # Non-intrusive bus monitor extracting transfers
│   ├── axi_sequencer.sv     # Sequencer typedef
│   ├── axi_agent.sv         # UVM Agent encapsulating driver, sequencer, monitor
│   └── axi_agent_pkg.sv     # Agent package
├── dut/
│   └── axi_slave.sv         # 32-bit 16-register AXI4-Lite Memory Slave design
├── env/
│   ├── axi_scoreboard.sv    # Scoreboard with reference memory and error/pass counters
│   ├── axi_env.sv           # Environment instantiating agent and scoreboard
│   └── axi_env_pkg.sv       # Environment package
├── test/
│   ├── axi_sequence.sv      # Constrained random sequence (write/read stimulus)
│   ├── axi_test.sv          # Base test raising/dropping objections
│   └── axi_test_pkg.sv      # Test package
├── top/
│   ├── axi_intf.sv          # AXI4-Lite interface with clocking blocks and modports
│   └── axi_top.sv           # Top module with clock/reset gen and config_db setup
└── filelist.f               # Simulator compilation filelist
```

---

## ⚙️ Features Verified

- **AXI4-Lite Handshake Mechanics**: Valid/Ready handshakes for all 5 channels (AW, W, B, AR, R).
- **Parallel Transfers**: Simultaneous address write (AW) and data write (W) phase execution.
- **Byte-Write Strobing**: 4-bit write strobes (`wstrb`) for selective byte lane updates.
- **Address Validation & Error Responses**:
  - `OKAY` (`2'b00`) on aligned access within the 16-register range.
  - `SLVERR` (`2'b10`) on misaligned access (`addr[1:0] != 0`) or out-of-bounds (`addr[31:6] != 0`).
- **Data Integrity**: Automated checking via scoreboard reference memory.

---

## 🚀 Running the Simulation

Using Synopsys VCS:
```bash
vcs -sverilog -ntb_opts uvm -f filelist.f -timescale=1ns/1ps -R
```
