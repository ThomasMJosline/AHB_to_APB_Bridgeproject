`timescale 1ns / 1ps
module AHB_master_interface(
input Hclk,Hresetn,Hready_out,
input[31:0]Hrdata,
output reg[31:0]Haddr,Hwdata,
output reg Hwrite,Hready_in,
output reg [1:0]Htrans,
output [1:0]Hresp);
reg[2:0]Hburst;
reg[2:0]Hsize;
task single_write();
begin
@(posedge Hclk);
#1;
begin
Hwrite=1;;
Htrans=2'd2;
Hsize=0;
Hburst=0;
Hready_in=1;
Haddr=32'h8000_0001;
end
@(posedge Hclk);
#1;
begin
Htrans=2'd0;
Hwdata=8'h80;
end
end
endtask
task single_read();
begin
@(posedge Hclk);
#1;
begin
Hwrite=0; //for read transaction hwrite =0;
Htrans=2'd2;
Hsize=0;
Hburst=0;
Hready_in=1;
Haddr=32'h8000_0001;
end
@(posedge Hclk);
#1;
begin
Htrans=2'd0;//end of single transfer
end
end
endtask
endmodule
