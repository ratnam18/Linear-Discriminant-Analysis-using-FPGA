`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:12:10 11/14/2018 
// Design Name: 
// Module Name:    inverse1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module inverse1(clk,a1,a2,a3,a4,b1,b2,b3,b4);

//inverse takes 40 clock cycles, will  take 50 clocks

input clk;
input [31:0] a1,a2,a3,a4;
output [31:0] b1,b2,b3,b4;

wire [31:0] y1,y2;
wire [31:0] x1,x2,x3,x4,da;

fpu f1(clk,a1,a4,2'b11,y1);
fpu f2(clk,a3,a2,2'b11,y2);
fpu f3(clk,y1,y2,2'b01,da);

assign x1[31:0] = a4[31:0];
assign x4[31:0] = a1[31:0];
assign x2[31] = !a2[31];
assign x2[30:0] = a2[30:0];
assign x3[31] = !a3[31];
assign x3[30:0] = a3[30:0];

fdiv e1 (
  .a(x1), // input [31 : 0] a
  .b(da), // input [31 : 0] b
  .clk(clk), // input clk
  .result(b1) // output [31 : 0] result
);

fdiv e2 (
  .a(x2), // input [31 : 0] a
  .b(da), // input [31 : 0] b
  .clk(clk), // input clk
  .result(b2) // output [31 : 0] result
);

fdiv e3 (
  .a(x3), // input [31 : 0] a
  .b(da), // input [31 : 0] b
  .clk(clk), // input clk
  .result(b3) // output [31 : 0] result
);

fdiv e4 (
  .a(x4), // input [31 : 0] a
  .b(da), // input [31 : 0] b
  .clk(clk), // input clk
  .result(b4) // output [31 : 0] result
);


endmodule
