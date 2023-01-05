initial
begin
  $display (" Reset");
  reset_all ;
  display;
//  #120
  $display ("Write FIFO");
  write (10);
  display;
  write (20);
  write (30);
  write(40);
  write(50);
  display;
  @(posedge clk);
  wr_en <= #1 1'b0;
  # 20
  read;
  display;
  read;
  display;
  read;
  display;
  read;
  display;
  read;
  display;
  @ (posedge clk);
  rd_en <= #1 1'b0;
 
  repeat (20) @ (posedge clk);
 // #1000;
  $finish(0);
  
end

