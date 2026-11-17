
module axi_top;
   import uvm_pkg::*;
   import axi_test_pkg::*;
   logic aclk=1'b0;
   logic aresetn=1'b0;
   always #5 aclk=~aclk;

   initial begin
      aresetn=1'b0;

      repeat(4)
         @(posedge aclk);

      @(negedge aclk)
         aresetn=1'b1;
    end

    axi4_lite_if axi_if(.aclk(aclk),.aresetn(aresetn));
    axi4_lite_slave dut(.axi(axi_if));

    initial begin
      uvm_config_db#(virtual axi4_lite_if.master)::set(null,"uvm_test_top.env_h.agent_h.driver_h","vif",axi_if);
      uvm_config_db#(virtual axi4_lite_if.monitor)::set(null,"uvm_test_top.env_h.agent_h.monitor_h","vif",axi_if);
      run_test("axi_test");
   end
endmodule


