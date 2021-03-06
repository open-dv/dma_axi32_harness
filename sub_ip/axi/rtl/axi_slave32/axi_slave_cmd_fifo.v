//------------------------------------------------------------------
//-- File generated by RobustVerilog parser
//-- RobustVerilog version 1.2 (limited free version)
//-- Invoked Sun May 05 12:20:58 2019
//-- Source file: axi_slave_cmd_fifo.v
//-- Parent file: axi_slave_ram.v
//-- Run directory: E:/vlsi/axi_slave/run/
//-- Target directory: out/
//-- Command flags: ../src/base/axi_slave.v -od out -I ../src/gen -list list.txt -listpath -header -gui 
//-- www.provartec.com/edatools ... info@provartec.com
//------------------------------------------------------------------





  
module axi_slave_cmd_fifo (clk,reset,AADDR,AID,ASIZE,ALEN,AVALID,AREADY,VALID,READY,LAST,cmd_addr,cmd_id,cmd_size,cmd_len,cmd_resp,cmd_timeout,cmd_ready,cmd_empty,cmd_full);

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
      
   input [32-1:0]      AADDR;
   input [4-1:0]           AID;
   input [2-1:0]      ASIZE;
   input [4-1:0]       ALEN;
   input               AVALID;
   input               AREADY;

   input               VALID;
   input               READY;
   input               LAST;

   output [32-1:0]     cmd_addr;
   output [4-1:0]       cmd_id;
   output [2-1:0]     cmd_size;
   output [4-1:0]      cmd_len;
   output [1:0]           cmd_resp;
   output               cmd_timeout;
   output               cmd_ready;
   output               cmd_empty;
   output               cmd_full;


   
   wire               push;
   wire               pop;
   wire                empty;
   wire                full;
   wire [DEPTH_BITS:0]        fullness;


   wire [1:0]               resp_in;
   wire               timeout_in;
   wire               timeout_out;
   reg [32-1:0]           SLVERR_addr = {32{1'b1}};
   reg [32-1:0]           DECERR_addr = {32{1'b1}};
   reg [32-1:0]           TIMEOUT_addr = {32{1'b1}};


   
   parameter               RESP_SLVERR = 2'b10;
   parameter                  RESP_DECERR = 2'b11;


   
   assign               resp_in = 
                  push & (SLVERR_addr == AADDR) ? RESP_SLVERR :
                  push & (DECERR_addr == AADDR) ? RESP_DECERR : 2'b00;

   assign               timeout_in  = push & (TIMEOUT_addr == AADDR);
   assign               cmd_timeout = timeout_out & (TIMEOUT_addr != 0);
   
   
   assign               cmd_full   = full | (DEPTH == fullness);
   assign               cmd_empty  = empty;
   assign               cmd_ready  = ~empty;
   
   assign               push = AVALID & AREADY;
   assign               pop  = VALID & READY & LAST;
   

   prgen_fifo_stub #(32+4+2+4+2+1, DEPTH) 
   cmd_fifo(
        .clk(clk),
        .reset(reset),
        .push(push),
        .pop(pop),
        .din({AADDR,
          AID,
          ASIZE,
          ALEN,
          resp_in,
          timeout_in
          }
         ),
        .dout({cmd_addr,
           cmd_id,
           cmd_size,
           cmd_len,
           cmd_resp,
           timeout_out
           }
          ),
        .fullness(fullness),
        .empty(empty),
        .full(full)
        );
   
   
   
   
endmodule




