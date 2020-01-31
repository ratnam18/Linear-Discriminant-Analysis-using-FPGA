`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:13:45 11/13/2018 
// Design Name: 
// Module Name:    Converter 
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
module Converter(decimalValue, binaryFP);
input [31:0]decimalValue;
output wire[31:0]binaryFP;

//reg [31:0]decimal ;
wire [22:0]Mantissa;


//reg [31:0]check;
wire [7:0]exp;

wire [31:0]i;

assign i=   (decimalValue[31]) ? 31 :
				(decimalValue[30]) ? 30 :
				(decimalValue[29]) ? 29 :
				(decimalValue[28]) ? 28 :
				(decimalValue[26]) ? 26 :
				(decimalValue[25]) ? 25 :
				(decimalValue[24]) ? 24 :
				(decimalValue[23]) ? 23 :
				(decimalValue[22]) ? 22 :
				(decimalValue[21]) ? 21 :
				(decimalValue[20]) ? 20 :
				(decimalValue[19]) ? 19 :
				(decimalValue[18]) ? 18 :
				(decimalValue[17]) ? 17 :
				(decimalValue[16]) ? 16 :
				(decimalValue[15]) ? 15 :
				(decimalValue[14]) ? 14 :
				(decimalValue[13]) ? 13 :
				(decimalValue[12]) ? 12 :
				(decimalValue[11]) ? 11 :
				(decimalValue[10]) ? 10 :
				(decimalValue[9]) ? 9 :
				(decimalValue[8]) ? 8 :
				(decimalValue[7]) ? 7 :
				(decimalValue[6]) ? 6 :
				(decimalValue[5]) ? 5 :
				(decimalValue[4]) ? 4 :
				(decimalValue[3]) ? 3 :
				(decimalValue[2]) ? 2 :
				(decimalValue[1]) ? 1 :
				0;
				
				
assign Mantissa = (i == 1) ? {decimalValue[0]  ,22'b0} :
					   (i == 2) ? {decimalValue[1:0],21'b0} : 
						(i == 3) ? {decimalValue[2:0],20'b0} : 
						(i == 4) ? {decimalValue[3:0],19'b0} : 
						(i == 5) ? {decimalValue[4:0],18'b0} : 
						(i == 6) ? {decimalValue[5:0],17'b0} : 
						(i == 7) ? {decimalValue[6:0],16'b0} : 
						(i == 8) ? {decimalValue[7:0],15'b0} : 
						(i == 9) ? {decimalValue[8:0],14'b0} : 
						(i == 10) ? {decimalValue[9:0],13'b0} : 
						(i == 11) ? {decimalValue[10:0],12'b0} : 
						(i == 12) ? {decimalValue[11:0],11'b0} : 
						(i == 13) ? {decimalValue[12:0],10'b0} : 
						(i == 14) ? {decimalValue[13:0],9'b0} : 
						(i == 15) ? {decimalValue[14:0],8'b0} : 
						(i == 16) ? {decimalValue[15:0],7'b0} : 
						(i == 17) ? {decimalValue[16:0],6'b0} : 
						(i == 18) ? {decimalValue[17:0],5'b0} : 
						(i == 19) ? {decimalValue[18:0],4'b0} : 
						(i == 20) ? {decimalValue[19:0],3'b0} : 
						(i == 21) ? {decimalValue[20:0],2'b0} : 
						(i == 22) ? {decimalValue[21:0],1'b0} : 
						(i == 23) ? {decimalValue[22:0]} : 
						(i == 24) ? {decimalValue[23:1]} : 
						(i == 25) ? {decimalValue[24:2]} : 
						(i == 26) ? {decimalValue[25:3]} : 
						(i == 27) ? {decimalValue[26:4]} : 
						(i == 28) ? {decimalValue[27:5]} : 
						(i == 29) ? {decimalValue[28:6]} : 
						(i == 30) ? {decimalValue[29:7]} : 
						(i == 31) ? {decimalValue[30:8]} : 
						 23'b0;
						
assign exp = 8'b01111111 + i[7:0];	// Add into bias	127				

assign binaryFP = {1'b0, exp, Mantissa}; // 1 bit sign - 8 bit exponent - 23 bit mantissa
endmodule
