interface axi4_lite_if(input logic aclk,
   input logic aresetn
);

logic [31:0] awaddr;
logic [2:0] awprot;
logic awvalid;
logic awready;

//Write Data channel
logic [31:0] wdata;
logic [3:0] wstrb;
logic wvalid;
logic wready;

//Write response channel

logic [1:0] bresp;
logic bvalid;
logic bready;

//READ address channel

logic [31:0] araddr;
logic [2:0] arprot;
logic arvalid;
logic arready;

//read data channel
//
logic  [31:0] rdata;
logic [1:0] rresp;
logic rvalid;
logic rready;

clocking driver_cb @(posedge aclk);
   default input #1step output #1step;

   input aresetn;

   //write address;
   output awaddr;
   output awprot;
   output awvalid;
   input awready;

   //write data
   //
   output wdata;
   output wstrb;
   output wvalid;
   input wready;

   //write response
   input bresp;
   input bvalid;
   output bready;

   //read address
   output araddr;
   output arprot;
   output arvalid;
   input arready;

   //read data
   input rdata;
   input rresp;
   input rvalid;
   output rready;
endclocking

clocking monitor_cb @(posedge aclk);
   default input #1step;

   input aresetn;

   //write address;
   input awaddr;
   input awprot;
   input awvalid;
   input awready;

   //write data
   input wdata;
   input wstrb;
   input wvalid;
   input wready;

   //write response
   input bresp;
   input bvalid;
   input bready;

   //read address
   input araddr;
   input arprot;
   input arvalid;
   input arready;

   //read data
   input rdata;
   input rresp;
   input rvalid;
   input rready;

endclocking


modport master(
   clocking driver_cb);

modport monitor(clocking monitor_cb);

modport slave(
   input aclk,
   input aresetn,

   //write address;
   input awaddr,
   input awprot,
   input awvalid,
   output awready,

   //write data
   input wdata,
   input wstrb,
   input wvalid,
   output wready,

   //write response
   output bresp,
   output bvalid,
   input bready,

   //read address
   input araddr,
   input arprot,
   input arvalid,
   output arready,

   //read data
   output rdata,
   output rresp,
   output rvalid,
   input rready
   );
endinterface

   
