//------------------------------------------------------------------
//-- File generated by RobustVerilog parser
//-- RobustVerilog version 1.2 (limited free version)
//-- Invoked Sun May 05 12:20:58 2019
//-- Source file: axi_slave_wresp_fifo.v
//-- Parent file: axi_slave_ram.v
//-- Run directory: E:/vlsi/axi_slave/run/
//-- Target directory: out/
//-- Command flags: ../src/base/axi_slave.v -od out -I ../src/gen -list list.txt -listpath -header -gui 
//-- www.provartec.com/edatools ... info@provartec.com
//------------------------------------------------------------------





  
module axi_slave_wresp_fifo (clk,reset,AWVALID,AWREADY,AWADDR,WVALID,WREADY,WID,WLAST,BID,BRESP,BVALID,BREADY,empty,pending,timeout);
   
   parameter                  DEPTH = 8;
      
   parameter               DEPTH_BITS = 
                  (DEPTH <= 2)   ? 1 :
                  (DEPTH <= 4)   ? 2 :
                  (DEPTH <= 8)   ? 3 :
                  (DEPTH <= 16)  ? 4 :
                  (DEPTH <= 32)  ? 5 :
                  (DEPTH <= 64)  ? 6 :
                  (DEPTH <= 128) ? 7 : 
                  (DEPTH <= 256) ? 8 :
                  (DEPTH <= 512) ? 9 : 0; //0 is ilegal
   
   input               clk;
   input               reset;

   input               AWVALID;
   input               AWREADY;    
   input [32-1:0]      AWADDR;              
   input               WVALID;
   input               WREADY;
   input [4-1:0]           WID;
   input               WLAST;

   output [4-1:0]       BID;
   output [1:0]           BRESP;
   input               BVALID;
   input               BREADY;
   
   output               empty;
   output               pending;
   output               timeout;

   
   wire               timeout_in;
   wire               timeout_out;
   wire [1:0]               resp_in;
   reg [32-1:0]           SLVERR_addr  = {32{1'b1}};
   reg [32-1:0]           DECERR_addr  = {32{1'b1}};
   reg [32-1:0]           TIMEOUT_addr = {32{1'b1}};

   
   wire               push;
   wire               push1;
   wire               pop;
   wire               empty;
   wire               full;
   wire [DEPTH_BITS:0]        fullness;

   
   reg                   pending;

   parameter               RESP_SLVERR = 2'b10;
   parameter                  RESP_DECERR = 2'b11;
   
   
   assign               resp_in = 
                  push1 & (SLVERR_addr == AWADDR) ? RESP_SLVERR :
                  push1 & (DECERR_addr == AWADDR) ? RESP_DECERR : 2'b00;

   assign               timeout_in = push1 & (TIMEOUT_addr == AWADDR);
   assign               timeout    = timeout_out & (TIMEOUT_addr != 0);
   
   
   always @(posedge clk or posedge reset)
     if (reset)
       pending <= #1 1'b0;
     else if (BVALID & BREADY)
       pending <= #1 1'b0;
     else if (BVALID & (~BREADY))
       pending <= #1 1'b1;

          
   
   assign               push1 = AWVALID & AWREADY;
   assign               push  = WVALID & WREADY & WLAST;
   assign               pop   = BVALID & BREADY;
   
   
   prgen_fifo_stub #(4, DEPTH) 
   wresp_fifo(
          .clk(clk),
          .reset(reset),
          .push(push),
          .pop(pop),
          .din({WID
            }
           ),
          .dout({BID
             }
            ),
          .fullness(fullness),
          .empty(empty),
          .full(full)
          );
   
   prgen_fifo_stub #(2+1, DEPTH*2) 
   wresp_fifo1(
          .clk(clk),
          .reset(reset),
          .push(push1),
          .pop(pop),
          .din({resp_in,
            timeout_in
            }
           ),
          .dout({BRESP,
             timeout_out
             }
            ),
          .fullness(),
          .empty(),
          .full()
          );
   
   
   
   
endmodule



