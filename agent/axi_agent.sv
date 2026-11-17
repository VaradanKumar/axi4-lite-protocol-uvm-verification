`ifndef _APB_AGENT_
`define _APB_AGENT_

class axi_agent extends uvm_agent;
   `uvm_component_utils(axi_agent);
   axi_monitor monitor_h;
   axi_driver driver_h;
   axi_sequencer sequencer_h;

   function new(string name = "axi_agent", uvm_component parent =null);
      super.new(name,parent);
      `uvm_info("AGENT","Inside the constructor",UVM_NONE);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("AGENT","inside build_phase",UVM_NONE)
      sequencer_h = axi_sequencer :: type_id :: create("sequencer_h",this); 
      driver_h = axi_driver :: type_id :: create("driver_h",this); 
      monitor_h = axi_monitor :: type_id :: create("monitor_h",this);
      `uvm_info("AGENT","Sequence driver and monitor are created",UVM_NONE)

   endfunction : build_phase

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info("AGENT","inside connect_phase",UVM_NONE)

      driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
   endfunction : connect_phase
endclass
`endif
