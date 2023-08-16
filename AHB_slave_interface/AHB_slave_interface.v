`timescale 1ns / 1ps

module AHB_slave (
input Hclk, Hwrite, Hready_in, Hresetn,
input [1:0] Htrans,
input [31:0] Haddr, Hwdata, Prdata,
output [31:0] Hrdata,
output reg [31:0] Haddr1, Haddr2, Hwdata1, Hwdata2,
output reg valid,
output reg Hwrite_reg, Hwritereg_1,
output reg [2:0] tempselx,
output [1:0] Hresp
);
  
// Pipeline logic for Haddr,Hwrite,Hwdata
always @(posedge Hclk)
begin
if (!Hresetn)
  begin
  Haddr1 <= 0;
  Haddr2 <= 0;
  end
else
  begin
  Haddr1 <= Haddr;
  Haddr2 <= Haddr1;
  end
end
  
always @(posedge Hclk)
begin
if (!Hresetn)
  begin
  Hwdata1 <= 0;
  Hwdata2 <= 0;
  end
else
  begin
  Hwdata1 <= Hwdata;
  Hwdata2 <= Hwdata1;
  end
end
always @(posedge Hclk)
begin
if (!Hresetn)
  begin
  Hwrite_reg <= 0;
  Hwritereg_1 <= 0;
  end
else
  begin
  Hwrite_reg <= Hwrite;
  Hwritereg_1 <= Hwrite_reg;
  end
end
  
// Generating valid logic
always @(*)
begin
valid = 1'b0;
if (Hready_in == 1 && Haddr >= 32'h8000_0000 && Haddr < 32'h8c00_0000 && (Htrans == 2'b10 || Htrans == 2'b11))
  valid = 1;
else
  valid = 0;
end
  
// tempselx logic
always @(*)
begin
tempselx = 3'b000;
if (Haddr >= 32'h8000_0000 && Haddr < 32'h8400_0000)
  tempselx = 3'b001;
else if (Haddr >= 32'h8400_0000 && Haddr < 32'h8800_0000)
  tempselx = 3'b010;
else if (Haddr >= 32'h8800_0000 && Haddr < 32'h8c00_0000)
  tempselx = 3'b100;
end
  
assign Hrdata = Prdata;
  
endmodule
