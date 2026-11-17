`ifndef AXI_MONITOR
`define AXI_MONITOR

class axi_monitor extends uvm_monitor;
   `uvm_component_utils(axi_monitor);
      
   virtual axi4_lite_if.monitor vif;
      
      
   uvm_analysis_port#(axi_transaction) ap;

      
   

   function new(string name = "axi_monitor", uvm_component parent =null);
      super.new(name,parent);
       ap=new("ap",this);
      `uvm_info("MONITOR","Inside the constructor",UVM_NONE);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("MONITOR","inside build_phase",UVM_NONE)
      if(uvm_config_db#(virtual axi4_lite_if.monitor)::get(this,"","vif",vif)) begin
         `uvm_info("MONITOR","got apb_vintf successfully",UVM_NONE)
      end
      else begin
         `uvm_fatal("MONITOR","Please see the apb_tb_top for set part")
      end
      
   endfunction : build_phase 

   task run_phase(uvm_phase phase); 
      axi_transaction write_tr;
      axi_transaction read_tr;
      `uvm_info("MONITOR","inside run_phase",UVM_NONE)
      write_tr=axi_transaction::type_id::create("write_tr");
      read_tr=axi_transaction::type_id::create("read_tr");
      forever begin
         @(vif.monitor_cb);
         if(vif.monitor_cb.aresetn!==1'b1) begin
            write_tr=axi_transaction::type_id::create("write_tr");
            read_tr=axi_transaction::type_id::create("read_tr");
         end
         else begin
            if((vif.monitor_cb.awvalid==1'b1) && (vif.monitor_cb.awready==1'b1)) begin
               write_tr.addr=vif.monitor_cb.awaddr;
               `uvm_info("MONITOR",$sformatf("AWARR=%0d",write_tr.addr),UVM_MEDIUM)
            end
            if((vif.monitor_cb.wvalid==1'b1) && (vif.monitor_cb.wready==1'b1)) begin
               write_tr.data=vif.monitor_cb.wdata;
               `uvm_info("MONITOR",$sformatf("WDATA=%0d",write_tr.data),UVM_MEDIUM)
            end
            if((vif.monitor_cb.bvalid==1'b1) && (vif.monitor_cb.bready==1'b1)) begin
               write_tr.is_write=1'b1;
               write_tr.rdata='0;
               write_tr.resp=vif.monitor_cb.bresp;
               ap.write(write_tr);

               write_tr=axi_transaction::type_id::create("write_tr");
            end
            
            if((vif.monitor_cb.arvalid==1'b1) && (vif.monitor_cb.arready==1'b1)) begin
               read_tr.addr=vif.monitor_cb.araddr;

               `uvm_info("MONITOR",$sformatf("ARADDR=%0d",read_tr.addr),UVM_MEDIUM)
            end

            if((vif.monitor_cb.rvalid==1'b1) && (vif.monitor_cb.rready==1'b1)) begin
               read_tr.is_write=1'b0;
               read_tr.rdata=vif.monitor_cb.rdata;
               read_tr.resp=vif.monitor_cb.rresp;
               ap.write(read_tr);
               `uvm_info("MONITOR",$sformatf("ADDR=%0d RDATA=%0d RRESP=%0b",read_tr.addr,read_tr.rdata,read_tr.resp),UVM_MEDIUM)
               read_tr=axi_transaction::type_id::create("read_tr");
            end
         end
      end
   endtask : run_phase
endclass
`endif 
