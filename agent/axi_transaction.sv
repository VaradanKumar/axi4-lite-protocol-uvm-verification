`ifndef AXI_TRANSACTION_SV
`define AXI_TRANSACTION_SV

class axi_transaction extends uvm_sequence_item;

   rand bit is_write;
   rand bit[31:0] addr;
   rand bit [31:0] data;
   
   //read fields
   bit [31:0] rdata;
   bit [1:0] resp;

   `uvm_object_utils_begin(axi_transaction)
   `uvm_field_int(is_write,UVM_ALL_ON)
   `uvm_field_int(addr,UVM_ALL_ON)
   `uvm_field_int(data,UVM_ALL_ON)
   `uvm_field_int(rdata,UVM_ALL_ON)
   `uvm_field_int(resp,UVM_ALL_ON)

   `uvm_object_utils_end

   function new(string name="axi_transaction");
      super.new(name);
   endfunction

   constraint addr_c{addr inside{[32'h00000000 : 32'h0000003C]};
   addr[1:0]==2'b00;}
   constraint write_read_c{is_write dist {1'b1:=70,1'b0:=30};}
endclass
`endif





