`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:06:12 11/12/2018 
// Design Name: 
// Module Name:    main 
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
module main(sign_ev1,ans_ev1,temp_ev1,
				sign_ev2,ans_ev2,temp_ev2,
				sign_v1x,ans_v1x,temp_v1x,
				sign_v2x,ans_v2x,temp_v2x,
				sign_v1y,ans_v1y,temp_v1y,
				sign_v2y,ans_v2y,temp_v2y,
				clk);

input clk;
output wire [23:0] ans_ev1,ans_ev2,ans_v1x,ans_v2x,ans_v1y,ans_v2y;
output wire [7:0] temp_ev1,temp_ev2,temp_v1x,temp_v2x,temp_v1y,temp_v2y;
output wire sign_ev1,sign_ev2,sign_v1x,sign_v2x,sign_v1y,sign_v2y;

wire [31:0] ev1_temp,ev2_temp,ev1,ev2;
wire [31:0]A[0:31];
wire [31:0] v1x,v1y,v2x,v2y;
reg [31:0]black_x[0:1023];
reg [31:0]black_y[0:1023];
reg [31:0]white_x[0:1023];
reg [31:0]white_y[0:1023];
wire [31:0]black_x_f[0:1023];
wire [31:0]black_y_f[0:1023];
wire [31:0]white_x_f[0:1023];
wire [31:0]white_y_f[0:1023];
wire [31:0]black_x_m,black_y_m,white_x_m,white_y_m;
reg [31:0]black_x_sum=0,black_y_sum=0,white_x_sum=0,white_y_sum=0;
wire [31:0]black_x_sum_f,black_y_sum_f,white_x_sum_f,white_y_sum_f;
wire [31:0]mux,muy;
wire [31:0]Sb[0:1][0:1];
wire [31:0]Sw_in[0:1][0:1];
wire [31:0]M[0:1][0:1];
wire [31:0]temp[0:7];
wire [31:0]tempsub1,tempsub2,tempsub3,tempsub4;
reg [31:0]i,j;
reg [31:0]bc=0,wc=0;
wire [31:0]bc_f,wc_f;
//Sw
wire [31:0] temp_mul_00, temp_mul1_00;
wire [31:0] temp_mul_01, temp_mul1_01;
wire [31:0] temp_mul_10, temp_mul1_10;
wire [31:0] temp_mul_11, temp_mul1_11;

reg [31:0] tryax,tryay, trywx,trywy;
wire [31:0] ox,oy , ox1,oy1;
reg [31:0] temp_sum[0:3];
reg [31:0] temp_sum1[0:3];
wire [31:0] s1_0, s1_1, s1_2, s1_3;
wire [31:0] s1[0:3];
wire [31:0] s2[0:3];
wire [31:0] Sw[0:1][0:1];
reg [31:0] clkCnt=0;
reg [3:0]STATE = 0;
//Initializing
parameter img_to_dataset = 5'd0;
//Class mean
parameter set_mean_wait = 5'd1;
//Sb
parameter Sb_subtract_wait = 5'd2;
parameter Sb_mul_wait = 5'd3;
parameter Sb_ready = 5'd4;
//Sw
/*parameter Sw_start = 5'd5;
parameter wait1 = 5'd6;
parameter wait2 = 5'd7;
parameter wait3 = 5'd8;
parameter wait4 = 5'd9;
parameter wait5 = 5'd10;
parameter wait6 = 5'd11;
parameter wait7 = 5'd12;
parameter Sw_wait = 5'd13;
parameter Sw_ready = 5'd14;*/
//(Sw-1)*(Sb)
parameter mat_inverse = 5'd5;
parameter mat_mul_temp = 5'd6;
parameter mat_mul = 5'd7;
//EVD
parameter ev_calc = 5'd8;
parameter ev_vec = 5'd9;
//Finishing
parameter translate = 5'd10;
parameter done = 5'd11;


Converter bxs(black_x_sum,black_x_sum_f);
Converter bys(black_y_sum,black_y_sum_f);
Converter wxs(white_x_sum,white_x_sum_f);
Converter wys(white_y_sum,white_y_sum_f);
Converter wc1(wc,wc_f);
Converter bc1(bc,bc_f);

Converter1 bn11(v1x,clk,sign_v1x,ans_v1x,temp_v1x);
Converter1 bn21(v1y,clk,sign_v1y,ans_v1y,temp_v1y);
Converter1 bn1(v2x,clk,sign_v2x,ans_v2x,temp_v2x);
Converter1 bn2(v2y,clk,sign_v2y,ans_v2y,temp_v2y);
Converter1 bn3(ev1,clk,sign_ev1,ans_ev1,temp_ev1);
Converter1 bn4(ev2,clk,sign_ev2,ans_ev2,temp_ev2);

fdiv bxm (
  .a(black_x_sum_f), // input [31 : 0] a
  .b(bc_f), // input [31 : 0] b
  .clk(clk), // input clk
  .result(black_x_m) // output [31 : 0] result
);
fdiv bym (
  .a(black_y_sum_f), // input [31 : 0] a
  .b(bc_f), // input [31 : 0] b
  .clk(clk), // input clk
  .result(black_y_m) // output [31 : 0] result
);
fdiv wxm (
  .a(white_x_sum_f), // input [31 : 0] a
  .b(wc_f), // input [31 : 0] b
  .clk(clk), // input clk
  .result(white_x_m) // output [31 : 0] result
);
fdiv wym (
  .a(white_y_sum_f), // input [31 : 0] a
  .b(wc_f), // input [31 : 0] b
  .clk(clk), // input clk
  .result(white_y_m) // output [31 : 0] result
);

fpu m1x_m2x(clk,black_x_m,white_x_m,2'b01,mux);
fpu m1y_m2y(clk,black_y_m,white_y_m,2'b01,muy);
fpu Sb_00(clk,mux,mux,2'b11,Sb[0][0]);
fpu Sb_01(clk,mux,muy,2'b11,Sb[0][1]);
assign Sb[1][0] = Sb[0][1];
fpu Sb_11(clk,muy,muy,2'b11,Sb[1][1]);

genvar k;
generate 
for (k = 0; k <1024; k = k + 1) 
	begin
		Converter C_BX_BXF(.decimalValue(black_x[k]), .binaryFP(black_x_f[k]));
		Converter C_BY_BYF(.decimalValue(black_y[k]), .binaryFP(black_y_f[k]));
		
		Converter C_WX_WXF(.decimalValue(white_x[k]), .binaryFP(white_x_f[k]));
		Converter C_WY_WYF(.decimalValue(white_y[k]), .binaryFP(white_y_f[k]));	
	end
endgenerate

		// for black point - s1
		fpu subbx(.clk(clk), .A(tryax), .B(black_x_m), .opcode(2'b01), .O(ox));
		fpu subby(.clk(clk), .A(tryay), .B(black_x_m), .opcode(2'b01), .O(oy));
		
		fpu temp0(.clk(clk), .A(ox), .B(ox), .opcode(2'b11), .O(temp_mul_00));
		fpu temp1(.clk(clk), .A(ox), .B(oy), .opcode(2'b11), .O(temp_mul_01));
		assign temp_mul_10=temp_mul_01;
		fpu temp3(.clk(clk), .A(oy), .B(oy), .opcode(2'b11), .O(temp_mul_11));
		
		fpu temp_0(.clk(clk), .A(temp_sum[0]), .B(temp_mul_00), .opcode(2'b00), .O(s1[0]));
		fpu temp_1(.clk(clk), .A(temp_sum[1]), .B(temp_mul_01), .opcode(2'b00), .O(s1[1]));
		fpu temp_2(.clk(clk), .A(temp_sum[2]), .B(temp_mul_10), .opcode(2'b00), .O(s1[2]));
		fpu temp_3(.clk(clk), .A(temp_sum[3]), .B(temp_mul_11), .opcode(2'b00), .O(s1[3]));
		
		// for white point - s2
		fpu suwwx(.clk(clk), .A(trywx), .B(white_x_m), .opcode(2'b01), .O(ox1));
		fpu suwwy(.clk(clk), .A(trywy), .B(white_x_m), .opcode(2'b01), .O(oy1));
		
		fpu temp01(.clk(clk), .A(ox1), .B(ox1), .opcode(2'b11), .O(temp_mul1_00));
		fpu temp11(.clk(clk), .A(ox1), .B(oy1), .opcode(2'b11), .O(temp_mul1_01));
		assign temp_mul1_10=temp_mul1_01;
		fpu temp31(.clk(clk), .A(oy1), .B(oy1), .opcode(2'b11), .O(temp_mul1_11));
		
		fpu temp_01(.clk(clk), .A(temp_sum1[0]), .B(temp_mul1_00), .opcode(2'b00), .O(s2[0]));
		fpu temp_11(.clk(clk), .A(temp_sum1[1]), .B(temp_mul1_01), .opcode(2'b00), .O(s2[1]));
		fpu temp_21(.clk(clk), .A(temp_sum1[2]), .B(temp_mul1_10), .opcode(2'b00), .O(s2[2]));
		fpu temp_31(.clk(clk), .A(temp_sum1[3]), .B(temp_mul1_11), .opcode(2'b00), .O(s2[3]));
		


		fpu sw_sum0(clk, s1[0], s2[0], 2'b00, Sw[0][0]);
		fpu sw_sum1(clk, s1[1], s2[1], 2'b00, Sw[0][1]);
		fpu sw_sum2(clk, s1[2], s2[2], 2'b00, Sw[1][0]);
		fpu sw_sum3(clk, s1[3], s2[3], 2'b00, Sw[1][1]);




//inverse1  Sw_inverse(clk,Sw[0][0],Sw[1][0],Sw[0][1],Sw[1][1],Sw_in[0][0],Sw_in[1][0],Sw_in[0][1],Sw_in[1][1]);
inverse1  Sw_inverse(clk,32'b01000111010101011000000101101001,32'b01000110110101000010001101101000,32'b01000110110101000010001101101000,32'b01000111010100111011000001001110,Sw_in[0][0],Sw_in[1][0],Sw_in[0][1],Sw_in[1][1]);

fpu temp0_0(clk,Sw_in[0][0],Sb[0][0],2'b11,temp[0]);
fpu temp1_1(clk,Sw_in[0][1],Sb[1][0],2'b11,temp[1]);
fpu temp2_2(clk,Sw_in[0][0],Sb[0][1],2'b11,temp[2]);
fpu temp3_3(clk,Sw_in[0][1],Sb[1][1],2'b11,temp[3]);
fpu temp4_4(clk,Sw_in[1][0],Sb[0][0],2'b11,temp[4]);
fpu temp5_5(clk,Sw_in[1][1],Sb[1][0],2'b11,temp[5]);
fpu temp6_6(clk,Sw_in[1][0],Sb[0][1],2'b11,temp[6]);
fpu temp7_7(clk,Sw_in[1][1],Sb[1][1],2'b11,temp[7]);

fpu M_00(clk,temp[0],temp[1],2'b00,M[0][0]);
fpu M_01(clk,temp[2],temp[3],2'b00,M[0][1]);
fpu M_10(clk,temp[4],temp[5],2'b00,M[1][0]);
fpu M_11(clk,temp[6],temp[7],2'b00,M[1][1]);

eigenvalues ev(ev1,ev2,M[0][0],M[1][0],M[0][1],M[1][1],clk);
//assign ev1 = (ev1_temp[30] === 1'bx) ? 32'd0 : ev1_temp;
//assign ev2 = (ev2_temp[30] === 1'bx) ? 32'd0 : ev2_temp;


fpu tsub1(clk,M[0][0],ev1,2'b01,tempsub1);
fpu tsub2(clk,M[1][1],ev1,2'b01,tempsub2);
eigenvectors evec1(v1x,v1y,tempsub1,M[1][0],M[0][1],tempsub2,clk);
fpu tsub3(clk,M[0][0],ev2,2'b01,tempsub3);
fpu tsub4(clk,M[1][1],ev2,2'b01,tempsub4);
eigenvectors evec2(v2x,v2y,tempsub3,M[1][0],M[0][1],tempsub4,clk);

assign A[0][0] = 1; assign A[0][1] = 0; assign A[0][2] = 0; assign A[0][3] = 0; assign A[0][4] = 0; assign A[0][5] = 0; assign A[0][6] = 0; assign A[0][7] = 0; assign A[0][8] = 0; assign A[0][9] = 0; assign A[0][10] = 0; assign A[0][11] = 0; assign A[0][12] = 0; assign A[0][13] = 0; assign A[0][14] = 0; assign A[0][15] = 0; assign A[0][16] = 0; assign A[0][17] = 0; assign A[0][18] = 0; assign A[0][19] = 0; assign A[0][20] = 0; assign A[0][21] = 0; assign A[0][22] = 0; assign A[0][23] = 0; assign A[0][24] = 0; assign A[0][25] = 0; assign A[0][26] = 0; assign A[0][27] = 0; assign A[0][28] = 0; assign A[0][29] = 0; assign A[0][30] = 0; assign A[0][31] = 0;
assign A[1][0] = 1; assign A[1][1] = 1; assign A[1][2] = 0; assign A[1][3] = 0; assign A[1][4] = 0; assign A[1][5] = 0; assign A[1][6] = 0; assign A[1][7] = 0; assign A[1][8] = 0; assign A[1][9] = 0; assign A[1][10] = 0; assign A[1][11] = 0; assign A[1][12] = 0; assign A[1][13] = 0; assign A[1][14] = 0; assign A[1][15] = 0; assign A[1][16] = 0; assign A[1][17] = 0; assign A[1][18] = 0; assign A[1][19] = 0; assign A[1][20] = 0; assign A[1][21] = 0; assign A[1][22] = 0; assign A[1][23] = 0; assign A[1][24] = 0; assign A[1][25] = 0; assign A[1][26] = 0; assign A[1][27] = 0; assign A[1][28] = 0; assign A[1][29] = 0; assign A[1][30] = 0; assign A[1][31] = 0;
assign A[2][0] = 1; assign A[2][1] = 1; assign A[2][2] = 1; assign A[2][3] = 0; assign A[2][4] = 0; assign A[2][5] = 0; assign A[2][6] = 0; assign A[2][7] = 0; assign A[2][8] = 0; assign A[2][9] = 0; assign A[2][10] = 0; assign A[2][11] = 0; assign A[2][12] = 0; assign A[2][13] = 0; assign A[2][14] = 0; assign A[2][15] = 0; assign A[2][16] = 0; assign A[2][17] = 0; assign A[2][18] = 0; assign A[2][19] = 0; assign A[2][20] = 0; assign A[2][21] = 0; assign A[2][22] = 0; assign A[2][23] = 0; assign A[2][24] = 0; assign A[2][25] = 0; assign A[2][26] = 0; assign A[2][27] = 0; assign A[2][28] = 0; assign A[2][29] = 0; assign A[2][30] = 0; assign A[2][31] = 0;
assign A[3][0] = 1; assign A[3][1] = 1; assign A[3][2] = 1; assign A[3][3] = 1; assign A[3][4] = 0; assign A[3][5] = 0; assign A[3][6] = 0; assign A[3][7] = 0; assign A[3][8] = 0; assign A[3][9] = 0; assign A[3][10] = 0; assign A[3][11] = 0; assign A[3][12] = 0; assign A[3][13] = 0; assign A[3][14] = 0; assign A[3][15] = 0; assign A[3][16] = 0; assign A[3][17] = 0; assign A[3][18] = 0; assign A[3][19] = 0; assign A[3][20] = 0; assign A[3][21] = 0; assign A[3][22] = 0; assign A[3][23] = 0; assign A[3][24] = 0; assign A[3][25] = 0; assign A[3][26] = 0; assign A[3][27] = 0; assign A[3][28] = 0; assign A[3][29] = 0; assign A[3][30] = 0; assign A[3][31] = 0;
assign A[4][0] = 1; assign A[4][1] = 1; assign A[4][2] = 1; assign A[4][3] = 1; assign A[4][4] = 1; assign A[4][5] = 0; assign A[4][6] = 0; assign A[4][7] = 0; assign A[4][8] = 0; assign A[4][9] = 0; assign A[4][10] = 0; assign A[4][11] = 0; assign A[4][12] = 0; assign A[4][13] = 0; assign A[4][14] = 0; assign A[4][15] = 0; assign A[4][16] = 0; assign A[4][17] = 0; assign A[4][18] = 0; assign A[4][19] = 0; assign A[4][20] = 0; assign A[4][21] = 0; assign A[4][22] = 0; assign A[4][23] = 0; assign A[4][24] = 0; assign A[4][25] = 0; assign A[4][26] = 0; assign A[4][27] = 0; assign A[4][28] = 0; assign A[4][29] = 0; assign A[4][30] = 0; assign A[4][31] = 0;
assign A[5][0] = 1; assign A[5][1] = 1; assign A[5][2] = 1; assign A[5][3] = 1; assign A[5][4] = 1; assign A[5][5] = 1; assign A[5][6] = 0; assign A[5][7] = 0; assign A[5][8] = 0; assign A[5][9] = 0; assign A[5][10] = 0; assign A[5][11] = 0; assign A[5][12] = 0; assign A[5][13] = 0; assign A[5][14] = 0; assign A[5][15] = 0; assign A[5][16] = 0; assign A[5][17] = 0; assign A[5][18] = 0; assign A[5][19] = 0; assign A[5][20] = 0; assign A[5][21] = 0; assign A[5][22] = 0; assign A[5][23] = 0; assign A[5][24] = 0; assign A[5][25] = 0; assign A[5][26] = 0; assign A[5][27] = 0; assign A[5][28] = 0; assign A[5][29] = 0; assign A[5][30] = 0; assign A[5][31] = 0;
assign A[6][0] = 1; assign A[6][1] = 1; assign A[6][2] = 1; assign A[6][3] = 1; assign A[6][4] = 1; assign A[6][5] = 1; assign A[6][6] = 1; assign A[6][7] = 0; assign A[6][8] = 0; assign A[6][9] = 0; assign A[6][10] = 0; assign A[6][11] = 0; assign A[6][12] = 0; assign A[6][13] = 0; assign A[6][14] = 0; assign A[6][15] = 0; assign A[6][16] = 0; assign A[6][17] = 0; assign A[6][18] = 0; assign A[6][19] = 0; assign A[6][20] = 0; assign A[6][21] = 0; assign A[6][22] = 0; assign A[6][23] = 0; assign A[6][24] = 0; assign A[6][25] = 0; assign A[6][26] = 0; assign A[6][27] = 0; assign A[6][28] = 0; assign A[6][29] = 0; assign A[6][30] = 0; assign A[6][31] = 0;
assign A[7][0] = 1; assign A[7][1] = 1; assign A[7][2] = 1; assign A[7][3] = 1; assign A[7][4] = 1; assign A[7][5] = 1; assign A[7][6] = 1; assign A[7][7] = 1; assign A[7][8] = 0; assign A[7][9] = 0; assign A[7][10] = 0; assign A[7][11] = 0; assign A[7][12] = 0; assign A[7][13] = 0; assign A[7][14] = 0; assign A[7][15] = 0; assign A[7][16] = 0; assign A[7][17] = 0; assign A[7][18] = 0; assign A[7][19] = 0; assign A[7][20] = 0; assign A[7][21] = 0; assign A[7][22] = 0; assign A[7][23] = 0; assign A[7][24] = 0; assign A[7][25] = 0; assign A[7][26] = 0; assign A[7][27] = 0; assign A[7][28] = 0; assign A[7][29] = 0; assign A[7][30] = 0; assign A[7][31] = 0;
assign A[8][0] = 1; assign A[8][1] = 1; assign A[8][2] = 1; assign A[8][3] = 1; assign A[8][4] = 1; assign A[8][5] = 1; assign A[8][6] = 1; assign A[8][7] = 1; assign A[8][8] = 1; assign A[8][9] = 0; assign A[8][10] = 0; assign A[8][11] = 0; assign A[8][12] = 0; assign A[8][13] = 0; assign A[8][14] = 0; assign A[8][15] = 0; assign A[8][16] = 0; assign A[8][17] = 0; assign A[8][18] = 0; assign A[8][19] = 0; assign A[8][20] = 0; assign A[8][21] = 0; assign A[8][22] = 0; assign A[8][23] = 0; assign A[8][24] = 0; assign A[8][25] = 0; assign A[8][26] = 0; assign A[8][27] = 0; assign A[8][28] = 0; assign A[8][29] = 0; assign A[8][30] = 0; assign A[8][31] = 0;
assign A[9][0] = 1; assign A[9][1] = 1; assign A[9][2] = 1; assign A[9][3] = 1; assign A[9][4] = 1; assign A[9][5] = 1; assign A[9][6] = 1; assign A[9][7] = 1; assign A[9][8] = 1; assign A[9][9] = 1; assign A[9][10] = 0; assign A[9][11] = 0; assign A[9][12] = 0; assign A[9][13] = 0; assign A[9][14] = 0; assign A[9][15] = 0; assign A[9][16] = 0; assign A[9][17] = 0; assign A[9][18] = 0; assign A[9][19] = 0; assign A[9][20] = 0; assign A[9][21] = 0; assign A[9][22] = 0; assign A[9][23] = 0; assign A[9][24] = 0; assign A[9][25] = 0; assign A[9][26] = 0; assign A[9][27] = 0; assign A[9][28] = 0; assign A[9][29] = 0; assign A[9][30] = 0; assign A[9][31] = 0;
assign A[10][0] = 1; assign A[10][1] = 1; assign A[10][2] = 1; assign A[10][3] = 1; assign A[10][4] = 1; assign A[10][5] = 1; assign A[10][6] = 1; assign A[10][7] = 1; assign A[10][8] = 1; assign A[10][9] = 1; assign A[10][10] = 1; assign A[10][11] = 0; assign A[10][12] = 0; assign A[10][13] = 0; assign A[10][14] = 0; assign A[10][15] = 0; assign A[10][16] = 0; assign A[10][17] = 0; assign A[10][18] = 0; assign A[10][19] = 0; assign A[10][20] = 0; assign A[10][21] = 0; assign A[10][22] = 0; assign A[10][23] = 0; assign A[10][24] = 0; assign A[10][25] = 0; assign A[10][26] = 0; assign A[10][27] = 0; assign A[10][28] = 0; assign A[10][29] = 0; assign A[10][30] = 0; assign A[10][31] = 0;
assign A[11][0] = 1; assign A[11][1] = 1; assign A[11][2] = 1; assign A[11][3] = 1; assign A[11][4] = 1; assign A[11][5] = 1; assign A[11][6] = 1; assign A[11][7] = 1; assign A[11][8] = 1; assign A[11][9] = 1; assign A[11][10] = 1; assign A[11][11] = 1; assign A[11][12] = 0; assign A[11][13] = 0; assign A[11][14] = 0; assign A[11][15] = 0; assign A[11][16] = 0; assign A[11][17] = 0; assign A[11][18] = 0; assign A[11][19] = 0; assign A[11][20] = 0; assign A[11][21] = 0; assign A[11][22] = 0; assign A[11][23] = 0; assign A[11][24] = 0; assign A[11][25] = 0; assign A[11][26] = 0; assign A[11][27] = 0; assign A[11][28] = 0; assign A[11][29] = 0; assign A[11][30] = 0; assign A[11][31] = 0;
assign A[12][0] = 1; assign A[12][1] = 1; assign A[12][2] = 1; assign A[12][3] = 1; assign A[12][4] = 1; assign A[12][5] = 1; assign A[12][6] = 1; assign A[12][7] = 1; assign A[12][8] = 1; assign A[12][9] = 1; assign A[12][10] = 1; assign A[12][11] = 1; assign A[12][12] = 1; assign A[12][13] = 0; assign A[12][14] = 0; assign A[12][15] = 0; assign A[12][16] = 0; assign A[12][17] = 0; assign A[12][18] = 0; assign A[12][19] = 0; assign A[12][20] = 0; assign A[12][21] = 0; assign A[12][22] = 0; assign A[12][23] = 0; assign A[12][24] = 0; assign A[12][25] = 0; assign A[12][26] = 0; assign A[12][27] = 0; assign A[12][28] = 0; assign A[12][29] = 0; assign A[12][30] = 0; assign A[12][31] = 0;
assign A[13][0] = 1; assign A[13][1] = 1; assign A[13][2] = 1; assign A[13][3] = 1; assign A[13][4] = 1; assign A[13][5] = 1; assign A[13][6] = 1; assign A[13][7] = 1; assign A[13][8] = 1; assign A[13][9] = 1; assign A[13][10] = 1; assign A[13][11] = 1; assign A[13][12] = 1; assign A[13][13] = 1; assign A[13][14] = 0; assign A[13][15] = 0; assign A[13][16] = 0; assign A[13][17] = 0; assign A[13][18] = 0; assign A[13][19] = 0; assign A[13][20] = 0; assign A[13][21] = 0; assign A[13][22] = 0; assign A[13][23] = 0; assign A[13][24] = 0; assign A[13][25] = 0; assign A[13][26] = 0; assign A[13][27] = 0; assign A[13][28] = 0; assign A[13][29] = 0; assign A[13][30] = 0; assign A[13][31] = 0;
assign A[14][0] = 1; assign A[14][1] = 1; assign A[14][2] = 1; assign A[14][3] = 1; assign A[14][4] = 1; assign A[14][5] = 1; assign A[14][6] = 1; assign A[14][7] = 1; assign A[14][8] = 1; assign A[14][9] = 1; assign A[14][10] = 1; assign A[14][11] = 1; assign A[14][12] = 1; assign A[14][13] = 1; assign A[14][14] = 1; assign A[14][15] = 0; assign A[14][16] = 0; assign A[14][17] = 0; assign A[14][18] = 0; assign A[14][19] = 0; assign A[14][20] = 0; assign A[14][21] = 0; assign A[14][22] = 0; assign A[14][23] = 0; assign A[14][24] = 0; assign A[14][25] = 0; assign A[14][26] = 0; assign A[14][27] = 0; assign A[14][28] = 0; assign A[14][29] = 0; assign A[14][30] = 0; assign A[14][31] = 0;
assign A[15][0] = 1; assign A[15][1] = 1; assign A[15][2] = 1; assign A[15][3] = 1; assign A[15][4] = 1; assign A[15][5] = 1; assign A[15][6] = 1; assign A[15][7] = 1; assign A[15][8] = 1; assign A[15][9] = 1; assign A[15][10] = 1; assign A[15][11] = 1; assign A[15][12] = 1; assign A[15][13] = 1; assign A[15][14] = 1; assign A[15][15] = 1; assign A[15][16] = 0; assign A[15][17] = 0; assign A[15][18] = 0; assign A[15][19] = 0; assign A[15][20] = 0; assign A[15][21] = 0; assign A[15][22] = 0; assign A[15][23] = 0; assign A[15][24] = 0; assign A[15][25] = 0; assign A[15][26] = 0; assign A[15][27] = 0; assign A[15][28] = 0; assign A[15][29] = 0; assign A[15][30] = 0; assign A[15][31] = 0;
assign A[16][0] = 1; assign A[16][1] = 1; assign A[16][2] = 1; assign A[16][3] = 1; assign A[16][4] = 1; assign A[16][5] = 1; assign A[16][6] = 1; assign A[16][7] = 1; assign A[16][8] = 1; assign A[16][9] = 1; assign A[16][10] = 1; assign A[16][11] = 1; assign A[16][12] = 1; assign A[16][13] = 1; assign A[16][14] = 1; assign A[16][15] = 1; assign A[16][16] = 1; assign A[16][17] = 0; assign A[16][18] = 0; assign A[16][19] = 0; assign A[16][20] = 0; assign A[16][21] = 0; assign A[16][22] = 0; assign A[16][23] = 0; assign A[16][24] = 0; assign A[16][25] = 0; assign A[16][26] = 0; assign A[16][27] = 0; assign A[16][28] = 0; assign A[16][29] = 0; assign A[16][30] = 0; assign A[16][31] = 0;
assign A[17][0] = 1; assign A[17][1] = 1; assign A[17][2] = 1; assign A[17][3] = 1; assign A[17][4] = 1; assign A[17][5] = 1; assign A[17][6] = 1; assign A[17][7] = 1; assign A[17][8] = 1; assign A[17][9] = 1; assign A[17][10] = 1; assign A[17][11] = 1; assign A[17][12] = 1; assign A[17][13] = 1; assign A[17][14] = 1; assign A[17][15] = 1; assign A[17][16] = 1; assign A[17][17] = 1; assign A[17][18] = 0; assign A[17][19] = 0; assign A[17][20] = 0; assign A[17][21] = 0; assign A[17][22] = 0; assign A[17][23] = 0; assign A[17][24] = 0; assign A[17][25] = 0; assign A[17][26] = 0; assign A[17][27] = 0; assign A[17][28] = 0; assign A[17][29] = 0; assign A[17][30] = 0; assign A[17][31] = 0;
assign A[18][0] = 1; assign A[18][1] = 1; assign A[18][2] = 1; assign A[18][3] = 1; assign A[18][4] = 1; assign A[18][5] = 1; assign A[18][6] = 1; assign A[18][7] = 1; assign A[18][8] = 1; assign A[18][9] = 1; assign A[18][10] = 1; assign A[18][11] = 1; assign A[18][12] = 1; assign A[18][13] = 1; assign A[18][14] = 1; assign A[18][15] = 1; assign A[18][16] = 1; assign A[18][17] = 1; assign A[18][18] = 1; assign A[18][19] = 0; assign A[18][20] = 0; assign A[18][21] = 0; assign A[18][22] = 0; assign A[18][23] = 0; assign A[18][24] = 0; assign A[18][25] = 0; assign A[18][26] = 0; assign A[18][27] = 0; assign A[18][28] = 0; assign A[18][29] = 0; assign A[18][30] = 0; assign A[18][31] = 0;
assign A[19][0] = 1; assign A[19][1] = 1; assign A[19][2] = 1; assign A[19][3] = 1; assign A[19][4] = 1; assign A[19][5] = 1; assign A[19][6] = 1; assign A[19][7] = 1; assign A[19][8] = 1; assign A[19][9] = 1; assign A[19][10] = 1; assign A[19][11] = 1; assign A[19][12] = 1; assign A[19][13] = 1; assign A[19][14] = 1; assign A[19][15] = 1; assign A[19][16] = 1; assign A[19][17] = 1; assign A[19][18] = 1; assign A[19][19] = 1; assign A[19][20] = 0; assign A[19][21] = 0; assign A[19][22] = 0; assign A[19][23] = 0; assign A[19][24] = 0; assign A[19][25] = 0; assign A[19][26] = 0; assign A[19][27] = 0; assign A[19][28] = 0; assign A[19][29] = 0; assign A[19][30] = 0; assign A[19][31] = 0;
assign A[20][0] = 1; assign A[20][1] = 1; assign A[20][2] = 1; assign A[20][3] = 1; assign A[20][4] = 1; assign A[20][5] = 1; assign A[20][6] = 1; assign A[20][7] = 1; assign A[20][8] = 1; assign A[20][9] = 1; assign A[20][10] = 1; assign A[20][11] = 1; assign A[20][12] = 1; assign A[20][13] = 1; assign A[20][14] = 1; assign A[20][15] = 1; assign A[20][16] = 1; assign A[20][17] = 1; assign A[20][18] = 1; assign A[20][19] = 1; assign A[20][20] = 1; assign A[20][21] = 0; assign A[20][22] = 0; assign A[20][23] = 0; assign A[20][24] = 0; assign A[20][25] = 0; assign A[20][26] = 0; assign A[20][27] = 0; assign A[20][28] = 0; assign A[20][29] = 0; assign A[20][30] = 0; assign A[20][31] = 0;
assign A[21][0] = 1; assign A[21][1] = 1; assign A[21][2] = 1; assign A[21][3] = 1; assign A[21][4] = 1; assign A[21][5] = 1; assign A[21][6] = 1; assign A[21][7] = 1; assign A[21][8] = 1; assign A[21][9] = 1; assign A[21][10] = 1; assign A[21][11] = 1; assign A[21][12] = 1; assign A[21][13] = 1; assign A[21][14] = 1; assign A[21][15] = 1; assign A[21][16] = 1; assign A[21][17] = 1; assign A[21][18] = 1; assign A[21][19] = 1; assign A[21][20] = 1; assign A[21][21] = 1; assign A[21][22] = 0; assign A[21][23] = 0; assign A[21][24] = 0; assign A[21][25] = 0; assign A[21][26] = 0; assign A[21][27] = 0; assign A[21][28] = 0; assign A[21][29] = 0; assign A[21][30] = 0; assign A[21][31] = 0;
assign A[22][0] = 1; assign A[22][1] = 1; assign A[22][2] = 1; assign A[22][3] = 1; assign A[22][4] = 1; assign A[22][5] = 1; assign A[22][6] = 1; assign A[22][7] = 1; assign A[22][8] = 1; assign A[22][9] = 1; assign A[22][10] = 1; assign A[22][11] = 1; assign A[22][12] = 1; assign A[22][13] = 1; assign A[22][14] = 1; assign A[22][15] = 1; assign A[22][16] = 1; assign A[22][17] = 1; assign A[22][18] = 1; assign A[22][19] = 1; assign A[22][20] = 1; assign A[22][21] = 1; assign A[22][22] = 1; assign A[22][23] = 0; assign A[22][24] = 0; assign A[22][25] = 0; assign A[22][26] = 0; assign A[22][27] = 0; assign A[22][28] = 0; assign A[22][29] = 0; assign A[22][30] = 0; assign A[22][31] = 0;
assign A[23][0] = 1; assign A[23][1] = 1; assign A[23][2] = 1; assign A[23][3] = 1; assign A[23][4] = 1; assign A[23][5] = 1; assign A[23][6] = 1; assign A[23][7] = 1; assign A[23][8] = 1; assign A[23][9] = 1; assign A[23][10] = 1; assign A[23][11] = 1; assign A[23][12] = 1; assign A[23][13] = 1; assign A[23][14] = 1; assign A[23][15] = 1; assign A[23][16] = 1; assign A[23][17] = 1; assign A[23][18] = 1; assign A[23][19] = 1; assign A[23][20] = 1; assign A[23][21] = 1; assign A[23][22] = 1; assign A[23][23] = 1; assign A[23][24] = 0; assign A[23][25] = 0; assign A[23][26] = 0; assign A[23][27] = 0; assign A[23][28] = 0; assign A[23][29] = 0; assign A[23][30] = 0; assign A[23][31] = 0;
assign A[24][0] = 1; assign A[24][1] = 1; assign A[24][2] = 1; assign A[24][3] = 1; assign A[24][4] = 1; assign A[24][5] = 1; assign A[24][6] = 1; assign A[24][7] = 1; assign A[24][8] = 1; assign A[24][9] = 1; assign A[24][10] = 1; assign A[24][11] = 1; assign A[24][12] = 1; assign A[24][13] = 1; assign A[24][14] = 1; assign A[24][15] = 1; assign A[24][16] = 1; assign A[24][17] = 1; assign A[24][18] = 1; assign A[24][19] = 1; assign A[24][20] = 1; assign A[24][21] = 1; assign A[24][22] = 1; assign A[24][23] = 1; assign A[24][24] = 1; assign A[24][25] = 0; assign A[24][26] = 0; assign A[24][27] = 0; assign A[24][28] = 0; assign A[24][29] = 0; assign A[24][30] = 0; assign A[24][31] = 0;
assign A[25][0] = 1; assign A[25][1] = 1; assign A[25][2] = 1; assign A[25][3] = 1; assign A[25][4] = 1; assign A[25][5] = 1; assign A[25][6] = 1; assign A[25][7] = 1; assign A[25][8] = 1; assign A[25][9] = 1; assign A[25][10] = 1; assign A[25][11] = 1; assign A[25][12] = 1; assign A[25][13] = 1; assign A[25][14] = 1; assign A[25][15] = 1; assign A[25][16] = 1; assign A[25][17] = 1; assign A[25][18] = 1; assign A[25][19] = 1; assign A[25][20] = 1; assign A[25][21] = 1; assign A[25][22] = 1; assign A[25][23] = 1; assign A[25][24] = 1; assign A[25][25] = 1; assign A[25][26] = 0; assign A[25][27] = 0; assign A[25][28] = 0; assign A[25][29] = 0; assign A[25][30] = 0; assign A[25][31] = 0;
assign A[26][0] = 1; assign A[26][1] = 1; assign A[26][2] = 1; assign A[26][3] = 1; assign A[26][4] = 1; assign A[26][5] = 1; assign A[26][6] = 1; assign A[26][7] = 1; assign A[26][8] = 1; assign A[26][9] = 1; assign A[26][10] = 1; assign A[26][11] = 1; assign A[26][12] = 1; assign A[26][13] = 1; assign A[26][14] = 1; assign A[26][15] = 1; assign A[26][16] = 1; assign A[26][17] = 1; assign A[26][18] = 1; assign A[26][19] = 1; assign A[26][20] = 1; assign A[26][21] = 1; assign A[26][22] = 1; assign A[26][23] = 1; assign A[26][24] = 1; assign A[26][25] = 1; assign A[26][26] = 1; assign A[26][27] = 0; assign A[26][28] = 0; assign A[26][29] = 0; assign A[26][30] = 0; assign A[26][31] = 0;
assign A[27][0] = 1; assign A[27][1] = 1; assign A[27][2] = 1; assign A[27][3] = 1; assign A[27][4] = 1; assign A[27][5] = 1; assign A[27][6] = 1; assign A[27][7] = 1; assign A[27][8] = 1; assign A[27][9] = 1; assign A[27][10] = 1; assign A[27][11] = 1; assign A[27][12] = 1; assign A[27][13] = 1; assign A[27][14] = 1; assign A[27][15] = 1; assign A[27][16] = 1; assign A[27][17] = 1; assign A[27][18] = 1; assign A[27][19] = 1; assign A[27][20] = 1; assign A[27][21] = 1; assign A[27][22] = 1; assign A[27][23] = 1; assign A[27][24] = 1; assign A[27][25] = 1; assign A[27][26] = 1; assign A[27][27] = 1; assign A[27][28] = 0; assign A[27][29] = 0; assign A[27][30] = 0; assign A[27][31] = 0;
assign A[28][0] = 1; assign A[28][1] = 1; assign A[28][2] = 1; assign A[28][3] = 1; assign A[28][4] = 1; assign A[28][5] = 1; assign A[28][6] = 1; assign A[28][7] = 1; assign A[28][8] = 1; assign A[28][9] = 1; assign A[28][10] = 1; assign A[28][11] = 1; assign A[28][12] = 1; assign A[28][13] = 1; assign A[28][14] = 1; assign A[28][15] = 1; assign A[28][16] = 1; assign A[28][17] = 1; assign A[28][18] = 1; assign A[28][19] = 1; assign A[28][20] = 1; assign A[28][21] = 1; assign A[28][22] = 1; assign A[28][23] = 1; assign A[28][24] = 1; assign A[28][25] = 1; assign A[28][26] = 1; assign A[28][27] = 1; assign A[28][28] = 1; assign A[28][29] = 0; assign A[28][30] = 0; assign A[28][31] = 0;
assign A[29][0] = 1; assign A[29][1] = 1; assign A[29][2] = 1; assign A[29][3] = 1; assign A[29][4] = 1; assign A[29][5] = 1; assign A[29][6] = 1; assign A[29][7] = 1; assign A[29][8] = 1; assign A[29][9] = 1; assign A[29][10] = 1; assign A[29][11] = 1; assign A[29][12] = 1; assign A[29][13] = 1; assign A[29][14] = 1; assign A[29][15] = 1; assign A[29][16] = 1; assign A[29][17] = 1; assign A[29][18] = 1; assign A[29][19] = 1; assign A[29][20] = 1; assign A[29][21] = 1; assign A[29][22] = 1; assign A[29][23] = 1; assign A[29][24] = 1; assign A[29][25] = 1; assign A[29][26] = 1; assign A[29][27] = 1; assign A[29][28] = 1; assign A[29][29] = 1; assign A[29][30] = 0; assign A[29][31] = 0;
assign A[30][0] = 1; assign A[30][1] = 1; assign A[30][2] = 1; assign A[30][3] = 1; assign A[30][4] = 1; assign A[30][5] = 1; assign A[30][6] = 1; assign A[30][7] = 1; assign A[30][8] = 1; assign A[30][9] = 1; assign A[30][10] = 1; assign A[30][11] = 1; assign A[30][12] = 1; assign A[30][13] = 1; assign A[30][14] = 1; assign A[30][15] = 1; assign A[30][16] = 1; assign A[30][17] = 1; assign A[30][18] = 1; assign A[30][19] = 1; assign A[30][20] = 1; assign A[30][21] = 1; assign A[30][22] = 1; assign A[30][23] = 1; assign A[30][24] = 1; assign A[30][25] = 1; assign A[30][26] = 1; assign A[30][27] = 1; assign A[30][28] = 1; assign A[30][29] = 1; assign A[30][30] = 1; assign A[30][31] = 0;
assign A[31][0] = 1; assign A[31][1] = 1; assign A[31][2] = 1; assign A[31][3] = 1; assign A[31][4] = 1; assign A[31][5] = 1; assign A[31][6] = 1; assign A[31][7] = 1; assign A[31][8] = 1; assign A[31][9] = 1; assign A[31][10] = 1; assign A[31][11] = 1; assign A[31][12] = 1; assign A[31][13] = 1; assign A[31][14] = 1; assign A[31][15] = 1; assign A[31][16] = 1; assign A[31][17] = 1; assign A[31][18] = 1; assign A[31][19] = 1; assign A[31][20] = 1; assign A[31][21] = 1; assign A[31][22] = 1; assign A[31][23] = 1; assign A[31][24] = 1; assign A[31][25] = 1; assign A[31][26] = 1; assign A[31][27] = 1; assign A[31][28] = 1; assign A[31][29] = 1; assign A[31][30] = 1; assign A[31][31] = 1;

always@(posedge clk)
begin

	case(STATE)
	
		img_to_dataset:
		begin
			for(i=32'b0;i<32'd32;i=i+32'b1)
			begin
				for(j=32'b0;j<32'd32;j=j+32'b1)
				begin
					if(A[i][j]==1'b0)
					begin
						black_x[bc] = i;
						black_y[bc] = j;
						bc = bc + 32'b1;
						black_x_sum = black_x_sum + i;
						black_y_sum = black_y_sum + j;
					end//if end
					else
					begin
						white_x[wc] = i;
						white_y[wc] = j;
						wc = wc + 32'b1;
						white_x_sum = white_x_sum + i;
						white_y_sum = white_y_sum + j;
					end//else end
				end//inner for end
			end//outer for end
			$display("bc:",bc);
			$display("wc:",wc);
			$display("black_x_sum:",black_x_sum);
			$display("black_y_sum:",black_y_sum);
			$display("white_x_sum:",white_x_sum);
			$display("white_y_sum:",white_y_sum);
			
			i=0;
			STATE <= set_mean_wait;
			//$display("STATE:",STATE);
		end//img_to_dataset end
			
		set_mean_wait://wait 40 cycles for mean
		begin
			if(i<40)
			begin 
				i=i+1;
				//$display("i:",i);
				STATE <= set_mean_wait;
			end
			else
			begin
				i=0;
				STATE <= Sb_subtract_wait;
			end	
		end//set_mean end
		
		Sb_subtract_wait:
		begin
			$display("black_x_m: %b",black_x_m);
			$display("black_y_m: %b",black_y_m);
			$display("white_x_m: %b",white_x_m);
			$display("white_y_m: %b",white_y_m);
			
			STATE <= Sb_mul_wait;
		end//set_mean end
		
		Sb_mul_wait:
		begin
			//$display("mux: %b     muy: %b",mux,muy);
			STATE <= Sb_ready;
		end
		
		Sb_ready:
		begin
			$display("Sb:");
			$display("%b     ,    %b",Sb[0][0],Sb[0][1]);
			$display("%b     ,    %b",Sb[1][0],Sb[1][1]);
			STATE <= mat_inverse;
		end
		
		
		/*Sw_start:	
		begin
				tryax <= black_x_f[i];
				tryay <= black_y_f[i];
				
				trywx <= white_x_f[i];
				trywy <= white_y_f[i];
				
				STATE <= wait1;
				//$display("x: %b  y: %b",tryax,tryay);
		end//set_mean end
		//wait for Sw
		wait1:
		begin
			STATE <= wait2;
		end
		wait2:
		begin
			STATE <= wait3;
		end
		wait3:
		begin
			STATE <= wait4;
		end
		wait4:
		begin
			STATE <= wait5;
		end
		wait5:
		begin
			STATE <= wait6;
		end
		wait6:
		begin
			STATE <= wait7;
		end
		
		wait7:
		begin
			if(i<bc || i<wc)
			begin
				$display("S1:");
				$display("%b     %b",s1[0],s1[1]);
				$display("%b     %b",s1[2],s1[3]);
				$display("S2:");
				$display("%b     %b",s2[0],s2[1]);
				$display("%b     %b",s2[2],s2[3]);
				$display("Temp Sum:");
				$display("%b     %b",temp_sum1[0],temp_sum1[1]);
				$display("%b     %b",temp_sum1[2],temp_sum1[3]);
				/*$display("Temp:");
				$display("%b     %b",temp_mul1_00,temp_mul1_01);
				$display("%b     %b",temp_mul1_10,temp_mul1_11);
				if(i<bc)
				begin
					temp_sum[0] = s1[0];
					temp_sum[1] = s1[1];
					temp_sum[2] = s1[2];
					temp_sum[3] = s1[3];
				end
				else
				begin
					temp_sum[0] = temp_sum[0];
					temp_sum[1] = temp_sum[1];
					temp_sum[2] = temp_sum[2];
					temp_sum[3] = temp_sum[3];
				end
				if(i<wc)
				begin
					temp_sum1[0] = s2[0];
					temp_sum1[1] = s2[1];
					temp_sum1[2] = s2[2];
					temp_sum1[3] = s2[3];
				end
				else
				begin
					temp_sum1[0] = temp_sum1[0];
					temp_sum1[1] = temp_sum1[1];
					temp_sum1[2] = temp_sum1[2];
					temp_sum1[3] = temp_sum1[3];
				end
				i<=i+1;
			end
			else
			begin 
				i<=0;
				STATE <= Sw_wait;
			end
		end
		
		Sw_wait:
		begin
			STATE <= Sw_ready;
		end*/
		
		/*5'b11110:
		begin
			STATE <= Sw_ready;
		end*/
		/*
		Sw_ready:
		begin
				$display("Sw:");
				$display("%b     ,    %b",Sw[0][0],Sw[0][1]);
				$display("%b     ,    %b",Sw[1][0],Sw[1][1]);						
			STATE <=mat_inverse;
		end*/
		
		mat_inverse:
		begin
			if(i<50)
			begin 
				i=i+1;
				//$display("i:",i);
				STATE <= mat_inverse;
			end
			else
			begin
				i=0;
				$display("Sw_in:");
				$display("%b     ,    %b",Sw_in[0][0],Sw_in[0][1]);
				$display("%b     ,    %b",Sw_in[1][0],Sw_in[1][1]);
				STATE <= mat_mul_temp;
			end	
		end
		
		mat_mul_temp:
		begin
			/*$display("Temp:");
			$display("0: %b",temp[0]);
			$display("1: %b",temp[1]);
			$display("2: %b",temp[2]);
			$display("3: %b",temp[3]);
			$display("4: %b",temp[4]);
			$display("5: %b",temp[5]);
			$display("6: %b",temp[6]);
			$display("7: %b",temp[7]);*/
			STATE <= mat_mul;
			$display("hi");
		end
		
		mat_mul:
		begin
			$display("M:");
			$display("%b     ,    %b",M[0][0],M[0][1]);
			$display("%b     ,    %b",M[1][0],M[1][1]);
			STATE <= ev_calc;
		end
		
		ev_calc:
		begin
		if(i<50)
			begin 
				i=i+1;
				//$display("i:",i);
				STATE <= ev_calc;
			end
			else
			begin
				i=0;
				$display("ev1 %b   ev2 :%b",ev1,ev2);
				STATE <= ev_vec;
			end	
		end
		
		ev_vec:
		begin
		if(i<50)
			begin 
				i=i+1;
				//$display("i:",i);
				STATE <= ev_vec;
			end
			else
			begin
				i=0;
				$display("v1x %b   v1y :%b",v1x,v1y);
				$display("v2x %b   v2y :%b",v2x,v2y);
				STATE <= translate;
			end	
		end
		
		translate:
		begin
			$display("ev1:   %d %d -E %d",sign_ev1,ans_ev1,temp_ev1);
			$display("ev2:   %d %d -E %d",sign_ev2,ans_ev2,temp_ev2);
			$display("v1x    %d %d -E %d",sign_v1x,ans_v1x,temp_v1x);
			$display("v1y    %d %d -E %d",sign_v1y,ans_v1y,temp_v1y);
			$display("v2x    %d %d -E %d",sign_v2x,ans_v2x,temp_v2x);
			$display("v2y    %d %d -E %d",sign_v2y,ans_v2y,temp_v2y);
			STATE <= done;
		end
		
		done:
		begin
			$display("total clk cycles: %d", clkCnt);
			STATE <= 5'b11111;
		end
		
		default:
		begin
		 
		end//default end
		
	endcase//case end
	clkCnt <= clkCnt+1;
end//always end

endmodule
