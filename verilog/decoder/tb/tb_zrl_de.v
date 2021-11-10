`timescale 1ns/100ps

module TB_ZRL_DE;
	reg 		clk, rstn;
	reg 		valid_i, sop_i, eop_i, ready_i;
	reg [63:0] 	data_i;
	wire [63:0] 	data_o;
	wire 		ready_o, sop_o, eop_o;
	wire 		valid_o;
	
ZRLE_DECOMP m0(
	.clk(clk),
	.rst_n(rstn),
	.data_i(data_i),
	.sop_i(sop_i),
	.eop_i(eop_i),
	.valid_i(valid_i),
	.ready_i(ready_i),
	.ready_o(ready_o),
	.sop_o(sop_o),
	.eop_o(eop_o),
	.valid_o(valid_o),
	.data_o(data_o)
);

reg [63:0] input_data[0:17];

integer	i;

always 	#5 clk <= ~clk;

initial begin
	input_data[0]  = 64'h5bff_ffff_fcff_ffff;
        input_data[1]  = 64'hffdb_ffff_fffc_ffff;
        input_data[2]  = 64'hffff_dbff_ffff_fcff;
        input_data[3]  = 64'hffff_ffc0_01bf_ffff;
	input_data[4]  = 64'hffcf_ffff_fffd_bfff;
        input_data[5]  = 64'hffff_cfff_ffff_fdbf;
        input_data[6]  = 64'hffff_ffcf_ffff_fffc;
        input_data[7]  = 64'h0;

	input_data[8]  = 64'h40FFFFFFFFFFFFFF;
	input_data[9]  = 64'hFFC0FFFFFFFFFFFF;
	input_data[10] = 64'hFFFFC0FFFFFFFFFF;
	input_data[11] = 64'hFFFFFFC0FFFFFFFF;
	input_data[12] = 64'hFFFFFFFFC0000000;
	input_data[13] = 64'h0000000000000000;
	input_data[14] = 64'h0000000000000000;
	input_data[15] = 64'h0000000000000000;

	clk = 1'b1;	rstn = 1'b0;
	i = 0;
	#1 rstn = 1;
	valid_i = 1;sop_i = 1;eop_i = 0;data_i = input_data[i];
	ready_i = 1;
	#10;
	while (i < 16) begin
		if (ready_o) begin
			i = i + 1;
			data_i = input_data[i];
			valid_i = 1;
			if (i == 0 || i == 8) 	sop_i = 1;
			else			sop_i = 0;
			if (i == 7 || i == 15)	eop_i = 1;
			else			eop_i = 0;
		end
		#10;
	end
	valid_i = 0;
		
	#100 $finish;
end

always #10 if (valid_o) $display($time, "\tinput data = %h\tready = %d\tdata = %h\tvalid = %d\tsop_o = %d\teop_o = %d", data_i, ready_o, data_o, valid_o, sop_o, eop_o);


endmodule
