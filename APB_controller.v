`timescale 1ns / 1ps

module APB_controller(
input Hclk, Hresetn, Hwritereg, Hwrite, valid,
input [31:0] Haddr, Hwdata, Hwdata1, Hwdata2, Haddr1, Haddr2, Prdata,
input [2:0] tempselx,
output reg Penable, Pwrite,
output reg Hready_out,
output reg [2:0] Psel,
output reg [31:0] Paddr, Pwdata
);

reg Penable_temp, Pwrite_temp, Hready_out_temp;
reg [2:0] Psel_temp;
reg [31:0] Paddr_temp, Pwdata_temp;
parameter ST_IDLE = 3'b000,
          ST_READ = 3'b001,
          ST_RENABLE = 3'b010,
          ST_WWAIT = 3'b011,
          ST_WRITE = 3'b100,
          ST_WENABLE = 3'b101,
          ST_WRITEP = 3'b110,
          ST_WENABLEP = 3'b111;

reg [2:0] present, next;

// present state logic
always @(posedge Hclk)
begin
  if (!Hresetn)
    present <= ST_IDLE;
  else
    present <= next;
end

// next state
always @(*)
begin
case (present)
ST_IDLE: begin
          if (valid == 1 && Hwrite == 1)
            next = ST_WWAIT;
          else if (valid == 1 && Hwrite == 0)
            next = ST_READ;
          else
            next = ST_IDLE;
          end
ST_WWAIT: begin
          if (valid == 1)
            next = ST_WRITEP;
          else
            next = ST_WRITE;
          end
ST_WRITE: begin
          if (valid == 1)
            next = ST_WENABLEP;
          else
            next = ST_WENABLE;
          end
ST_WRITEP: next = ST_WENABLEP;
ST_WENABLE: begin
            if (valid == 1 && Hwrite == 1)
              next = ST_WWAIT;
            else if (valid == 1 && Hwrite == 0)
              next = ST_READ;
            else if (valid == 0)
              next = ST_IDLE;
            end
ST_WENABLEP: begin
            if (valid == 1 && Hwritereg == 1)
              next = ST_WRITEP;
            else if (valid == 0 && Hwritereg == 1)
              next = ST_WRITE;
            else if (Hwritereg == 0)
              next = ST_READ;
            end
ST_READ: next = ST_RENABLE;
ST_RENABLE: begin
            if (valid == 1 && Hwrite == 1)
              next = ST_WWAIT;
            else if (valid == 1 && Hwrite == 0)
              next = ST_READ;
            else if (valid == 0)
              next = ST_IDLE;
            end
default: next = ST_IDLE;
endcase
end

// Temporary output logic
always @(*)
begin
case (present)
ST_IDLE:begin
        if (valid == 1 && Hwrite == 0)
          begin
          Paddr_temp = Haddr;
          Pwrite_temp = Hwrite;
          Psel_temp = tempselx;
          Penable_temp = 0;
          Hready_out_temp = 0;
          end
        else if (valid == 1 && Hwrite == 1)
          begin
          Psel_temp = 0;
          Penable_temp = 0;
          Hready_out_temp = 1;
          end
        else
          begin
          Psel_temp = 0;
          Penable_temp = 0;
          Hready_out_temp = 1;
          end
        end
ST_READ: begin
          Penable_temp = 1;
          Hready_out_temp = 1;
        end
ST_RENABLE: begin
            if (valid == 1 && Hwrite == 0)
              begin
              Paddr_temp = Haddr;
              Pwrite_temp = Hwrite;
              Psel_temp = tempselx;
              Penable_temp = 0;
              Hready_out_temp = 0;
              end
            else if (valid == 1 && Hwrite == 1)
              begin
              Psel_temp = 0;
              Penable_temp = 0;
              Hready_out_temp = 1;
              end
            else 
              begin
              Psel_temp = 0;
              Penable_temp = 0;
              Hready_out_temp = 1;
              end
            end
ST_WWAIT: begin
          Paddr_temp = Haddr1;
          Pwdata_temp = Hwdata;
          Pwrite_temp = Hwrite;
          Psel_temp = tempselx;
          Penable_temp = 0;
          Hready_out_temp = 0;
          end
ST_WRITE: begin
          Penable_temp = 1;
          Hready_out_temp = 1;
          end
ST_WENABLE:begin
          if (valid == 1 && Hwrite == 0)
            begin
            Psel_temp = 0;
            Penable_temp = 0;
            Hready_out_temp = 1;
            end
          else if (valid == 1 && Hwrite == 0) 
            begin
            Paddr_temp = Haddr1;
            Pwrite_temp = Hwritereg;
            Psel_temp = tempselx;
            Penable_temp = 0;
            Hready_out_temp = 0;
            end
          begin
            Hready_out_temp = 1;
            Psel_temp = 0;
            Penable_temp = 0;
            end
          end
ST_WRITEP: begin
            Penable_temp = 1;
            Hready_out_temp = 1;
          end
ST_WENABLEP: begin
              Paddr_temp = Haddr1;
              Pwdata_temp = Hwdata;
              Pwrite_temp = Hwrite;
              Psel_temp = tempselx;
              Penable_temp = 0;
              Hready_out_temp = 1;
              end
endcase
end

//output logic
always @(posedge Hclk)
begin
if (!Hresetn)
  begin
  Paddr <= 0;
  Pwdata <= 0;
  Pwrite <= 0;
  Psel <= 0;
  Penable <= 0;
  Hready_out <= 1;
  end
else 
  begin
  Paddr <= Paddr_temp;
  Pwdata <= Pwdata_temp;
  Pwrite <= Pwrite_temp;
  Psel <= Psel_temp;
  Penable <= Penable_temp;
  Hready_out <= Hready_out_temp;
  end
end
endmodule
