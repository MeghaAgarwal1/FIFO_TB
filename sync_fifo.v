`timescale 1ps/1ps

module sync_fifo
(
 reset,
 clk,
 wr_full,
 wr_data,
 wr_en,
 rd_empty,
 rd_data,
 rd_en
);
parameter ADDR_WIDTH = 3;
parameter DATA_WIDTH = 16;
  
input reset;
input clk;
  input [DATA_WIDTH-1:0] wr_data;
input wr_en;
input rd_en;
  
output wr_full;
output rd_empty;
output [DATA_WIDTH-1:0] rd_data;

wire [DATA_WIDTH-1:0] rd_data;
reg [ADDR_WIDTH:0] rd_ptr;
reg [ADDR_WIDTH:0] wr_ptr;

assign wr_full = ((wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]) && (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]));
assign rd_empty = wr_ptr == rd_ptr;

`ifdef VENDORRAM
v_rams_12 # (DATA_WIDTH,ADDR_WIDTH) fifomem (.clk1 (clk),
                                     	     .clk2 (clk),
                                     	     .we   (wr_en)
                                     	     .add1 (wr_ptr),
                                     	     .add2 (rd_ptr),
                                     	     .di   (wr_data),
                                     	     .do2  (rd_data)
                                    	    );
`else 
localparam DEPTH = 1<<ADDR_WIDTH;
reg [DATA_WIDTH-1:0] mem[0:DEPTH-1];
  assign rd_data = mem[rd_ptr];

always @ (posedge clk)
begin
     if (wr_en && !wr_full )
    begin
      mem[wr_ptr] <= wr_data;
    end
end

`endif


always @ (posedge clk or negedge reset)
begin
  if (!reset)
  begin
    wr_ptr <= {ADDR_WIDTH{1'b0}};
  end
  else
  begin
    if (wr_en && !wr_full )
    begin
      wr_ptr <= wr_ptr + 1'b1;
    end
  end
end


always @ (posedge clk or negedge reset)
begin
  if (!reset)
  begin
    rd_ptr <= {ADDR_WIDTH{1'b0}};
  end
  else
  begin
    if (rd_en && !rd_empty)
    begin
      rd_ptr <= rd_ptr + 1'b1;
    end
  end
end

endmodule

