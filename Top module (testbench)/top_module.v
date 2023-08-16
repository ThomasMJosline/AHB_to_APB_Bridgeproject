`timescale 1ns / 1ps

module Top();
reg Hclk,Hresetn;
wire Pwrite,Penable;
wire[31:0]Haddr;
wire Hready_out;
wire[31:0]Hrdata;
wire[31:0]Hwdata,Prdata;
wire Hwrite,Hready_in;
wire [1:0]Htrans;
wire [1:0]Hresp;
wire [2:0]Pselx;
wire [31:0]Pwdata,Paddr;
wire [31:0]Paddr_out,Pwdata_out;
wire [2:0]Psel_out;
wire Pwrite_out,Penable_out;
  
AHB_master_interface ahb_master(Hclk,Hresetn,Hready_out,Hrdata,Haddr,Hwdata,Hwrite,Hready_in,Htrans,Hresp);
  
AHB_APB_bridge bridge(Hclk,Hresetn,Hwrite,Hready_in,Htrans,Haddr,Hwdata,Prdata,Pwrite,Penable,Hready _out,Pselx,Hresp,Pwdata,Paddr,Hrdata);
  
APB_interface apb_interface(Pwrite,Penable,Pselx,Paddr,Pwdata,Pwrite_out,Penable_out,Psel_out,Paddr_out,Pwdata_out,Prdata);
  
initial
begin
Hclk=1'b0;
forever#10 Hclk=~Hclk;
end
task reset;
begin
@(negedge Hclk);
Hresetn=1'b0;
@(negedge Hclk);
Hresetn=1'b1;
end
endtask
initial
begin
reset;
//ahb_master.single_write(); //for testing single write transaction
ahb_master.single_read(); //for testing single read transaction
end
endmodule

