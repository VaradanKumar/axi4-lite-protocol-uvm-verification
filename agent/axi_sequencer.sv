`ifndef _AXI_SEQUENCER_
`define _AXI_SEQUENCER_

class axi_sequencer extends uvm_sequencer #(axi_transaction);
   `uvm_component_utils(axi_sequencer);
      
    function new(string name = "axi_sequencer", uvm_component parent =null);
       super.new(name,parent);
       `uvm_info("SEQUENCER","Inside the constructor",UVM_NONE);
    endfunction : new
   
endclass : axi_sequencer

`endif
