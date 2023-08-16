`timescale 1ns / 1ps

module APB_interface(input Pwrite,Penable,input[2:0]Pselx,input[31:0]Paddr,Pwdata,
output Pwrite_out,Penable_out,output[2:0]Psel_out,
output[31:0]Paddr_out,Pwdata_out,
output reg[31:0]Prdata);
  
assign Pwrite_out=Pwrite;
assign Paddr_out=Paddr;
assign Psel_out=Pselx;
assign Pwdata_out=Pwdata;
assign Penable_out=Penable;

  
always@(*)
begin
if(!Pwrite && Penable)
begin
Prdata=8'd25;
end
end
endmodule
