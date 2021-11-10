//-------------------------------------
// Design Name  : TB_ZRL
// File Name    : TB_ZRL.v
// Function     : Testbench
//                  
// Coder        : Urim Hwang
//-------------------------------------

`timescale 1ns/100ps
module TB_ZRL;
	reg t_clk, t_rstn;
	reg t_valid, t_eop;
	reg [63:0] t_data_i;
	wire [65:0] t_data_o;
	wire [6:0]  t_size_o;
	wire [63:0] t_data_oo;
	wire [63:0]  t_size_oo;
	
ZRL_ENGINE tb1(.data_i(t_data_i),
              .valid(t_valid),
	      .rst_n(t_rstn),
	      .clk(t_clk),
	      .data_o(t_data_o),
	      .size_o(t_size_o));

CODEWORD_BUF tb2(.clk(t_clk),
		.rst_n(t_rstn),
		.eop(t_eop),
		.data_i(t_data_o),
		.size_i(t_size_o),
		.data_o(t_data_oo),
		.size_o(t_size_oo));
			

initial begin
	#0 t_clk = 0; t_rstn = 1; t_valid = 1; t_data_i = 64'hFFFF0000FFFF0000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i <= ~t_data_i; t_eop = 1; $display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	#5 t_clk <= ~t_clk;
	$display("%h\t%d\t%h\t%d", t_data_o, t_size_o, t_data_oo, t_size_oo);
	$finish;
end

endmodule
