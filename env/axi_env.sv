`ifndef _APB_ENV_
`define _APB_ENV_

class axi_env extends uvm_env;
   `uvm_component_utils(axi_env);
      
   axi_agent agent_h;
   axi_scoreboard scoreboard_h;
  
      

   function new(string name = "axi_env", uvm_component parent =null);
      super.new(name,parent);
      `uvm_info("ENV","Inside the constructor",UVM_NONE);
   endfunction : new
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("ENV","inside build_phase",UVM_NONE)
      agent_h = axi_agent :: type_id :: create("agent_h",this);
      scoreboard_h = axi_scoreboard :: type_id :: create("scoreboard_h",this);
      
      
   endfunction : build_phase 

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info("ENV","inside connect_phase",UVM_NONE)
      agent_h.monitor_h.ap.connect(scoreboard_h.ana_fifo.analysis_export);

   endfunction : connect_phase 

endclass
`endif
