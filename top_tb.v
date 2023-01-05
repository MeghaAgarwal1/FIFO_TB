
`timescale 1ps/1ps

module top_tb ();

parameter ADDR_WIDTH = 2;
parameter DATA_WIDTH = 16;
parameter CLK_PERIOD = 10;

  
reg reset;
reg clk;
reg [DATA_WIDTH-1:0] wr_data;
reg wr_en;
reg rd_en;
  
wire wr_full;
wire rd_empty;
wire [DATA_WIDTH-1:0] rd_data;

`include "test1.v"

//always #(CLK_PERIOD/2) clk = ~clk;
initial begin
  clk = 0;
  forever begin
    #5 clk = ~clk;
  end
end

sync_fifo # (ADDR_WIDTH,DATA_WIDTH) dut     (.reset    (reset),
                                     	     .clk      (clk),
                                             .wr_full  (wr_full),
                                     	     .wr_en    (wr_en),
                                     	     .rd_en    (rd_en),
                                     	     .wr_data   (wr_data),
                                     	     .rd_data  (rd_data),
                                             .rd_empty (rd_empty)

                                    	    );


task reset_all;
begin
  reset <= #1 1'b0;
  wr_en    <= #1 1'b0;
  rd_en  <= #1 1'b0;
  wr_data <= #1 0;
# 20;
  reset <= #1 1'b1;
end
endtask

task write;
input [DATA_WIDTH-1:0] data;
begin
  @(posedge clk);
  wr_en <= #1 1'b1;
  wr_data<= #1 data;
end
endtask

task read;
begin 
@ (posedge clk);
  rd_en <= #1 1'b1;
end
endtask
  
task display;
begin
  #1 $display("Fifo Empty :%d, Fifo Full :%d, Read_Data : %d",rd_empty,wr_full,rd_data);
end
endtask

endmodule






