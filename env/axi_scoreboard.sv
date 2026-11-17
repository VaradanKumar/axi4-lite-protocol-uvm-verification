
`ifndef AXI_SCOREBOARD
`define AXI_SCOREBOARD

   class axi_scoreboard extends uvm_scoreboard;
      `uvm_component_utils(axi_scoreboard);

      uvm_tlm_analysis_fifo#(axi_transaction) ana_fifo;
      uvm_tlm_fifo #(axi_transaction) cmp_fifo;

      logic [31:0] mem [0:15];
      int write_count,read_count,pass_count,error_count;
           
   function new(string name = "axi_scoreboard", uvm_component parent =null);
      super.new(name,parent);
      `uvm_info("SCOREBOARD","Inside the constructor",UVM_NONE);
   endfunction : new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("SCOREBOARD","inside build_phase",UVM_NONE)
      ana_fifo = new("ana_fifo",this);
      cmp_fifo=new("cmp_fifo",this);
      foreach(mem[i])
         mem[i]='0;
      write_count=0;
      read_count=0;
      pass_count=0;
      error_count=0;
   endfunction : build_phase 

   task run_phase(uvm_phase phase);
      `uvm_info("SCOREBOARD","inside run_phase",UVM_NONE)
      fork
         capture_data(); 
         compare_data();
      join
   endtask : run_phase

   task capture_data();
      axi_transaction tr;
      forever begin
         ana_fifo.get(tr);
         cmp_fifo.put(tr);
      end
   endtask : capture_data

   task compare_data();
      axi_transaction tr;
      bit valid_addr;
      int idx;
      forever begin
         cmp_fifo.get(tr);

         valid_addr=(tr.addr[31:6]==26'b00) && (tr.addr[1:0]==2'b00);
         idx=tr.addr[5:2];
         if(tr.is_write) begin
            write_count++;
            if(valid_addr && (tr.resp==2'b00)) begin
               mem[idx]=tr.data;
               pass_count++;
               `uvm_info("SCOREBOARD","Write pass",UVM_MEDIUM)
            end
            else if(!valid_addr &&(tr.resp==2'b10)) begin
               pass_count++;
            end
            else begin
               error_count++;
               `uvm_error("SCOREBOARD","Write failed");
            end
         end
         else begin read_count++;

         if(valid_addr && (tr.resp==2'b00) &&(tr.rdata==mem[idx])) begin
            pass_count++;
            `uvm_info("SCOREBOARD","Read data Match",UVM_MEDIUM)
         end
         else if(!valid_addr &&(tr.resp==2'b10) && (tr.rdata==32'b0)) begin
            pass_count++;
         end
         else begin
            error_count++;
            `uvm_error("SCOREBOARD",$sformatf("READ failed:ADD=%0d EXPPECTED =%0d ACTUAL =%0d RESP =%0b",tr.addr,valid_addr ? mem[idx]:32'b0,tr.rdata,tr.resp))
         end
      end
   end
endtask : compare_data

   function void report_phase(uvm_phase phase);
      `uvm_info("SCOREBOARD",$sformatf("WRITES=%0d,READS=%0d PASSES=%0d ERRORS=%0d",write_count,read_count,pass_count,error_count),UVM_NONE)
   endfunction : report_phase 
endclass

`endif 
