`ifndef APB_TEST
`define AXI_TEST

   class axi_test extends uvm_test; 
      `uvm_component_utils(axi_test);
            
      axi_env env_h;
      

   function new(string name = "axi_test", uvm_component parent =null);
      super.new(name,parent);
      `uvm_info("TEST","Inside the constructor",UVM_NONE);
   endfunction : new


   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("TEST","inside build_phase",UVM_NONE)
      env_h = axi_env :: type_id :: create("env_h",this); 
         
   endfunction : build_phase 

   task run_phase(uvm_phase phase);
      axi_sequence seq_h;
       
      phase.raise_objection(this);
      seq_h = axi_sequence :: type_id :: create("seq_h",this); 
      `uvm_info("TEST","start the apb_base_seq",UVM_NONE)
       seq_h.start(env_h.agent_h.sequencer_h);
      phase.drop_objection(this);
   endtask : run_phase
endclass

`endif 
