`ifndef AXI_SEQUENCE
`define AXI_SEQUENCE
class axi_sequence extends uvm_sequence #(axi_transaction);
   `uvm_object_utils(axi_sequence)
   int num_transaction=10;
   function new(string name = "axi_sequencer");
         super.new(name);
         `uvm_info("SEQUENCE","Inside the constructor",UVM_NONE)
   endfunction : new


   task body();
      axi_transaction req;
      int count=0;
      `uvm_info("SEQUNCE","Inside body",UVM_NONE)
      repeat(num_transaction) begin
         req=axi_transaction::type_id::create($sformatf("req_%0d",count));
         start_item(req);

         if(!req.randomize()) begin
            `uvm_fatal("SEQUNENCE","Transction randmization failed")
         end

         `uvm_info("SEQUNCE",$sformatf("Transaction %0d:%s,addr=%0d,data=%0d",count,req.is_write? "WRITE" : "READ",req.addr,req.data),UVM_MEDIUM)
         finish_item(req);
         count++;
      end
      `uvm_info("SEQUENCE","All transaction completed",UVM_LOW)
   endtask
endclass
`endif         




