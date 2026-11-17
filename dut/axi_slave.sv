
module axi4_lite_slave(axi4_lite_if.slave axi);

logic [31:0] regfile [0:15];
logic [31:0] awaddr_buf;
logic [31:0] wdata_buf;
logic [3:0] wstrb_buf;

logic aw_pending;
logic w_pending;
integer i;

assign axi.awready=axi.aresetn && !aw_pending && !axi.bvalid;
assign axi.wready=axi.aresetn && !w_pending && !axi.bvalid;

assign axi.arready=!axi.rvalid;

always @(posedge axi.aclk) begin
   if (!axi.aresetn) begin
      awaddr_buf<='0;
      wdata_buf<='0;
      wstrb_buf<='0;

      aw_pending<=1'b0;
      w_pending<=1'b0;

      axi.bresp<=2'b00;
      axi.bvalid<=1'b0;

      axi.rdata<='0;
      axi.rresp<=2'b00;
      axi.rvalid<=1'b0;

      for(i=0;i<16;i++)
         regfile[i]<='0;

   end 
   else begin

      if(axi.awvalid && axi.awready) begin
         awaddr_buf<=axi.awaddr;
         aw_pending<=1'b1;
      end

      if(axi.wvalid && axi.wready) begin
         wdata_buf<=axi.wdata;
         wstrb_buf<=axi.wstrb;
         w_pending<=1'b1;
      end

      if(aw_pending && w_pending && !axi.bvalid) begin
         if((awaddr_buf[31:6]==0) && (awaddr_buf[1:0]==2'b00)) begin
            if(wstrb_buf[0])
               regfile[awaddr_buf[5:2]][7:0]<=wdata_buf[7:0];

            if(wstrb_buf[1])
               regfile[awaddr_buf[5:2]][15:8]<=wdata_buf[15:8];

            if(wstrb_buf[2])
               regfile[awaddr_buf[5:2]][23:16]<=wdata_buf[23:16];

            if(wstrb_buf[3])
               regfile[awaddr_buf[5:2]][31:24]<=wdata_buf[31:24];

            axi.bresp<=2'b00;
         end
         else begin
            axi.bresp<=2'b10;
         end
         axi.bvalid<=1'b1;
         aw_pending<=1'b0;
         w_pending<=1'b0;
      end
      else if(axi.bvalid && axi.bready) begin
         axi.bvalid<=1'b0;
      end

      if(axi.arvalid && axi.arready) begin
         if((axi.araddr[31:6]==0) && (axi.araddr[1:0]==2'b00)) begin
            axi.rdata<=regfile[axi.araddr[5:2]];
            axi.rresp<=2'b00;
         end
         else begin
            axi.rdata<=32'b0;
            axi.rresp<=2'b10;
         end
         axi.rvalid<=1'b1;
      end
      else if(axi.rvalid && axi.rready) begin
         axi.rvalid<=1'b0;
      end
   end
end
endmodule






