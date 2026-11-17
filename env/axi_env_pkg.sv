`ifndef AXI_ENV_PKG
`define AXI_ENV_PKG

   package axi_env_pkg;
      import uvm_pkg::*;
      `include "uvm_macros.svh"
   
      import axi_agent_pkg::*;
      
      
      `include "axi_scoreboard.sv"
      `include "axi_env.sv"
   
   endpackage : axi_env_pkg


`endif 
