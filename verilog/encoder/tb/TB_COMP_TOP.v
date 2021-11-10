//-------------------------------------
// Design Name  : TB_SR
// File Name    : TB_SR.v
// Function     : Testbench
//                  
// Coder        : Urim Hwang
//-------------------------------------

`timescale 1ns/100ps
module TB_COMP_TOP;
	reg t_clk, t_rstn;
	reg t_valid_i, t_ready_i;
	reg [63:0] t_data_i;
	reg t_sop_i, t_eop_i;
	wire [63:0] t_data_o;
	wire        t_valid_o, t_ready_o;
	wire        t_sop_o, t_eop_o;
	
COMP_TOP tb(.clk(t_clk),
	     .rst_n(t_rstn),
	     .data_i(t_data_i),
	     .valid_i(t_valid_i),
	     .ready_i(t_ready_i),
	     .sop_i(t_sop_i),
	     .eop_i(t_eop_i),
	     .data_o(t_data_o),
	     .valid_o(t_valid_o),
	     .ready_o(t_ready_o),
	     .sop_o(t_sop_o),
	     .eop_o(t_eop_o));
			

initial begin
	#0 t_rstn = 1;
	#5 t_rstn = 0;
	#5 t_rstn = 1;
	#5 t_clk = 0; t_valid_i = 1; t_ready_i = 1; t_data_i = 64'h1234567890123456; t_sop_i = 1;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_sop_i = 0; t_data_i = 64'h7890123456789012;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h3456789012345678;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h9012345678901234; 
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h5678901234567890;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h1234567890123456;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h7890123456789012;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h3456789012345678;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h9012345678901234;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h5678901234567890;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h1234567890123456;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h7890123456789012;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h3456789012345678;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h9012345678901234;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h5678901234567890;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_eop_i = 1; t_data_i = 64'h1234567890123456;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_sop_i = 1; t_eop_i = 0; t_data_i = 64'h0400040504050405;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_sop_i = 0; t_data_i = 64'h0405040504050405;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h0005000500050005;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h003c00410046004b; 
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00500055005a005f;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00640069006e0073;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h0078007d00820087;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h008c00910096009b;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00a000a500aa00af;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00b400b900be00c3;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00c800cd00d200d7;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00dc00e100e600eb;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00f000f500fa00ff;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h01040109010e0113;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h0118011d01220127;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_eop_i = 1; //t_data_i = 64'h012c01310136013b;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_sop_i = 1; t_eop_i = 0; t_data_i = 64'h0000000500050005;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_sop_i = 0; t_data_i = 64'h0075000500750075;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h0005000500050005;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h003c00410046004b; 
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00500055005a005f;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00640069006e0073;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h0078007d00820087;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h008c00910096009b;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00a000a500aa00af;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00b400b900be00c3;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00c800cd00d200d7;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00dc00e100e600eb;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h00f000f500fa00ff;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h01040109010e0113;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  //t_data_i = 64'h0118011d01220127;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_eop_i = 1; //t_data_i = 64'h012c01310136013b;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_sop_i = 1; t_eop_i = 0; t_data_i = 64'h1234567890123456;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_sop_i = 0; t_data_i = 64'h7890123456789012;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h3456789012345678;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h9012345678901234; 
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h5678901234567890;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h1234567890123456;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h7890123456789012;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h3456789012345678;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h9012345678901234;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h5678901234567890;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h1234567890123456;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h7890123456789012;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h3456789012345678;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h9012345678901234;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h5678901234567890;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_eop_i = 1; t_data_i = 64'h1234567890123456;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_sop_i = 1; t_eop_i = 0; t_data_i = 64'h8001000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_sop_i = 0; t_data_i = 64'hffff000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h0002000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'hffff000000000000; 
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h0003000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'hffff000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h0004000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'hffff000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h0005000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'hffff000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h0006000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'hffff000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h0007000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'hffff000000000000;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_data_i = 64'h5678901234567890;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_eop_i = 1; t_data_i = 64'h1234567890123456;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;  t_valid_i = 0; t_eop_i = 0;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	#5 t_clk <= ~t_clk;
	$finish;
end

initial $monitor($time, "\tdata_i = %h\tvalid_i = %d\tready_o = %d\tdata_o = %h\tvalid_o = %d\tsop_o = %d\teop_o = %d", t_data_i, t_valid_i, t_ready_o, t_data_o, t_valid_o, t_sop_o, t_eop_o);

endmodule
