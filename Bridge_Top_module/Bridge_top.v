`timescale 1ns / 1ps

module AHB_APB_bridge(
input Hclk,Hresetn,Hwrite,Hready_in,
input[1:0]Htrans,
input[31:0]Haddr,Hwdata,Prdata,
output Pwrite,Penable,Hready_out,
output[2:0]Pselx,
output [1:0]Hresp,
output[31:0]Pwdata,Paddr,Hrdata);
wire [31:0]Haddr1,Haddr2,Hwdata1,Hwdata2;
wire [2:0]tempselx;
wire valid,Hwritereg;
  
//Instantiating modules
AHB_slave ahb_slave(Hclk,Hwrite,Hready_in,Hresetn,Htrans,Haddr,Hwdata,Prdata,Hrdata,Haddr1,Haddr2,Hwdata1,Hwdata2,valid,Hwritereg,tempselx,Hresp);
  
APB_controller apb_controller(Hclk,Hresetn,Hwritereg,Hwrite,valid,Haddr,Hwdata,Hwdata1,Hwdata2,Haddr1,Haddr2,Prdata,tempselx,Penable,Pwrite,Hready_out,Pselx,Paddr,Pwdata);
  
endmodule
