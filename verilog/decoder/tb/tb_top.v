module TB_TOP;
	reg rst_n;
	reg clk;
	reg valid_i, sop_i, eop_i, ready_i;
	reg [63:0] data_i;
	wire valid_o, sop_o, eop_o, ready_o;
	wire [63:0] data_o;

	DECOMP_TOP TOP(
		.rst_n(rst_n),
		.clk(clk),

		.data_i(data_i),
		.valid_i(valid_i),
		.sop_i(sop_i),
		.eop_i(eop_i),
		.ready_i(ready_i),

		.data_o(data_o),
		.valid_o(valid_o),
		.sop_o(sop_o),
		.eop_o(eop_o),
		.ready_o(ready_o)
	);

	reg [63:0] data [0:31];

	integer i;

	always #5 clk <= ~clk;

	initial begin
		data[0] = 64'h01001b0000000000;
		data[1] = 64'h0;
		data[2] = 64'h0;
		data[3] = 64'h0;
		data[4] = 64'h0;
		data[5] = 64'h0;
		data[6] = 64'h0;
		data[7] = 64'h0;

		data[8] = 64'h8000000001010101;
		data[9] = 64'h0202020203030303;
		data[10] = 64'h0404040405050505;
		data[11] = 64'h0606060607070707;
		data[12] = 64'h0808080809090909;
		data[13] = 64'h0a0a0a0a0b0b0b0b;
		data[14] = 64'h0c0c0c0c0d0d0d0d;
		data[15] = 64'h0e0e0e0e0f0f0f0f;

		data[16] = 64'h5bff_ffff_fcff_ffff;
		data[17] = 64'hffdb_ffff_fffc_ffff;
		data[18] = 64'hffff_dbff_ffff_fcff;
		data[19] = 64'hffff_ffc0_01bf_ffff;
		data[20] = 64'hffcf_ffff_fffd_bfff;
		data[21] = 64'hffff_cfff_ffff_fdbf;
		data[22] = 64'hffff_ffcf_ffff_fffc;
		data[23] = 64'h0;

		data[24] = 64'h048d0f5ad6b5ad6b;
		data[25] = 64'h5ad6b694a5294a52;
		data[26] = 64'h94a52cc6318c6318;
		data[27] = 64'hc63189ca5294a529;
		data[28] = 64'h4a5294f39ce739ce;
		data[29] = 64'h739ce7b9ce739ce7;
		data[30] = 64'h39ce73394a5294a5;
		data[31] = 64'h294a529f7bdef7bd;

		clk = 1; rst_n = 0;
		i = 0;
		#1 rst_n = 1;
		valid_i = 1;sop_i = 1;eop_i = 0;data_i = data[i];ready_i = 1;
		#10;
		while (i < 32) begin
			if (ready_o) begin
				i = i + 1;
				data_i = data[i];
				valid_i = (i < 32);
				if (i == 0 || i == 8 || i == 16 || i == 24) 	sop_i = 1;
				else						sop_i = 0;
				if (i == 7 || i == 15 || i == 23 || i == 31) 	eop_i = 1;
				else						eop_i = 0;
			end
			#10;
		end
		valid_i = 0;

		#300 $finish;
	end

	always #10 if (valid_o) $display($time, "\tdata_i = %h\tready_o = %d\tdata_o = %h\tvalid_o = %d\tsop_o = %d\teop_o= %d", 
				data_i, ready_o, data_o, valid_o, sop_o, eop_o);


endmodule
	
