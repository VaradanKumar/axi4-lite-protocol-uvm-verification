`ifndef AXI_DRIVER
`define AXI_DRIVER

      class axi_driver extends uvm_driver#(axi_transaction);
      `uvm_component_utils(axi_driver);

      axi_transaction req_h;
     

      
      virtual axi4_lite_if.master vif;
      
      
      function new(string name = "axi_driver", uvm_component parent =null);
      super.new(name,parent);
      `uvm_info("DRIVER","Inside the constructor",UVM_NONE);
   endfunction : new

     
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("DRIVER","inside build_phase",UVM_NONE)
      if(uvm_config_db#(virtual axi4_lite_if.master)::get(this,"","vif",vif)) begin
         `uvm_info("DRIVER","got axi_vintf successfully",UVM_NONE)
      end
      else begin
         `uvm_fatal("DRIVER","Please see the axi_tb_top for set part")
      end
   endfunction : build_phase 

   task run_phase(uvm_phase phase);
      `uvm_info("DRIVER","Inside run phase",UVM_NONE)
      vif.driver_cb.awaddr<='0;
      vif.driver_cb.awprot<='0;
      vif.driver_cb.awvalid<=1'b0;

      vif.driver_cb.wdata<='0;
      vif.driver_cb.wstrb<=4'b1111;


      vif.driver_cb.bready<=1'b0;

      vif.driver_cb.araddr<='0;
      vif.driver_cb.arprot<='0;
      vif.driver_cb.arvalid<=1'b0;

      vif.driver_cb.rready<=1'b0;

      do begin
         @(vif.driver_cb);
      end
      while (vif.driver_cb.aresetn!=1'b1);
      `uvm_info("DRIVER","Reset deasseted",UVM_LOW)
      forever begin
         seq_item_port.get_next_item(req_h);

         if(req_h.is_write) begin
            `uvm_info("DRIVER","Starting write transaction",UVM_MEDIUM)
            write_transfer(req_h);
         end
         else begin
            `uvm_info("DRIVER","Starting read transaction",UVM_MEDIUM)
            read_transfer(req_h);
         end
         seq_item_port.item_done();

      end

   endtask : run_phase

   task write_transfer(axi_transaction tr);
      vif.driver_cb.awaddr<=tr.addr;
      vif.driver_cb.awprot<=3'b000;
      vif.driver_cb.awvalid<=1'b1;
      vif.driver_cb.wdata<=tr.data;
      vif.driver_cb.wstrb<=4'b1111;
      vif.driver_cb.wvalid<=1'b1;
      
      fork 
         begin
            do begin
               @(vif.driver_cb);
            end while(vif.driver_cb.awready!=1'b1);

            vif.driver_cb.awvalid<=1'b0;

            `uvm_info("DRIVER","AW handashake completed",UVM_MEDIUM)
         end


         begin
            do begin
               @(vif.driver_cb);
            end while(vif.driver_cb.wready!=1'b1);

            vif.driver_cb.wvalid<=1'b0;

            `uvm_info("DRIVER","W handshake completed",UVM_MEDIUM)
         end
      join


      vif.driver_cb.bready<=1'b1;

      do begin
         @(vif.driver_cb);
      end while (vif.driver_cb.bvalid!=1'b1);

      tr.resp=vif.driver_cb.bresp;
      vif.driver_cb.bready<=1'b0;
      `uvm_info("DRIVER",$sformatf("Write completed:Addr=%0d data=%0d bresp =%0b",tr.addr,tr.data,tr.resp),UVM_MEDIUM)
   endtask

   task read_transfer(axi_transaction tr);
      vif.driver_cb.araddr<=tr.addr;
      vif.driver_cb.arprot<=3'b000;
      vif.driver_cb.arvalid<=1'b1;
      do begin
         @(vif.driver_cb);
      end while(vif.driver_cb.arready!=1'b1);

      vif.driver_cb.arvalid<=1'b0;
      `uvm_info("DRIVER","AR handshake completed",UVM_MEDIUM)
      vif.driver_cb.rready<=1'b1;
      do begin
         @(vif.driver_cb);
      end while(vif.driver_cb.rvalid!=1'b1);

      tr.rdata=vif.driver_cb.rdata;
      tr.resp=vif.driver_cb.rresp;
         
      vif.driver_cb.rready<=1'b0;
      `uvm_info("DRIVER",$sformatf("Read transaction completed :Addr:%0d rdata=%0d rresp=%0b",tr.addr,tr.rdata,tr.resp),UVM_MEDIUM)


   endtask
endclass
`endif
