`ifndef AXI_TEST_PKG
`define AXI_TEST_PKG
   package axi_test_pkg;
      import uvm_pkg::*;
      `include "uvm_macros.svh"
   
       import axi_agent_pkg::*;
       import axi_env_pkg::*;

   
      `include "axi_sequence.sv"
      `include "axi_test.sv"
   
   endpackage : axi_test_pkg 

`endif 
