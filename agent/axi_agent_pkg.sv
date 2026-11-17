`ifndef AXI_AGENT_PKG
`define AXI_AGENT_PKG

   package axi_agent_pkg;
      import uvm_pkg::*;
      `include "uvm_macros.svh"
    
      `include "axi_transaction.sv"
      `include "axi_driver.sv"
      `include "axi_monitor.sv"
      `include "axi_sequencer.sv"
      `include "axi_agent.sv"
  
   endpackage : axi_agent_pkg


`endif
