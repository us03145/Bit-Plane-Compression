module BPC_DECOMP 
(	input 	wire			rst_n,
	input 	wire			clk,
	
	input 	wire			valid_i,
	input 	wire 	[63: 0]		data_i,
	input 	wire			sop_i,
	input 	wire			eop_i,
	
	input 	wire 			ready_i,

	output 	wire			ready_o,
	output 	wire			sop_o,
	output 	wire			eop_o,
	
	output wire			valid_o,
	output wire 	[63: 0]		data_o
);
	//stage 1 var
	reg 		[127:0] 	code_buf, code_buf_i, code_buf_n;
	reg 		[6:0] 		buf_size, buf_size_i, buf_size_n;
	reg 		[3:0] 		zrl_cnt,  zrl_cnt_i,  zrl_cnt_n;
	reg 		[3:0] 		bp_cnt,   bp_cnt_n;
	reg 		[4:0]		in_cnt, in_cnt_n;

	wire 		[127:0]		code_buf_o;
	wire 		[6:0]		buf_size_o;
	wire 		[3:0]		zrl_cnt_o;

	reg 		[15:0]		base_word, base_word_n;
	reg 		[62:0]		bit_plane	[0:15];
	reg		[62:0]		bit_plane_n	[0:15];
	reg 				valid_bp, valid_bp_n;

	wire 				valid_d		[0:3];
	wire 		[62:0]		dbx		[0:3];
	wire				do_xor		[0:3];
	// stage 1 var 
	
	// ouptut var
	integer 			i;
	reg				ready;
	reg 				sop;
	reg				eop;
	// output var
	
	// stage 2 var
	reg				valid, valid_n;
	reg 		[63:0]		data_out;

	reg 		[15:0] 		origin		[0:3];
	reg 		[3:0]		bu_cnt,   bu_cnt_n;
	
	wire 		[15:0] 		delta		[0:62];
	// stage 2 var
	
	always @(*) begin
		base_word_n = base_word;
		code_buf_i = code_buf;
		buf_size_i = buf_size;
		zrl_cnt_i = zrl_cnt;
		in_cnt_n = in_cnt;

		if (in_cnt <= 7) begin
			if (buf_size <= 64) begin
				ready = 1;
			end
		end
		else begin
			if (valid) begin
				ready = 0;
			end
			else begin
				ready = 1;
			end
		end

		if (valid_i & ready) begin
			if (!valid_bp) begin
				if (sop_i) begin
					base_word_n = data_i[61:46];
					code_buf_i = code_buf | (data_i[45:0] << (82 - buf_size));
					buf_size_i = buf_size + 46;
					zrl_cnt_i = 0;
				end else begin
					code_buf_i = code_buf | (data_i << (64 - buf_size));
					buf_size_i = buf_size + 64;
				end
			end
			in_cnt_n = in_cnt + 1;
		end

		////////////////////////////////////////////////////////////////////////////////////////////
		code_buf_n = code_buf_o;
		buf_size_n = buf_size_o;
		zrl_cnt_n = zrl_cnt_o;
		for (i=0; i<16; i=i+1) 
			bit_plane_n[i] = bit_plane[i];
		bp_cnt_n = bp_cnt;
		valid_bp_n = valid_bp;

		if (!valid_bp & valid_d[0]) begin
			if (bp_cnt == 0)
				bit_plane_n[bp_cnt] = dbx[0];
			else		
				bit_plane_n[bp_cnt] = do_xor[0] ? dbx[0] ^ bit_plane[bp_cnt-1] : dbx[0];
			if (bp_cnt <= 14)
				bp_cnt_n = bp_cnt + 1;
			else
				valid_bp_n = 1;

			if (valid_d[1]) begin
				bit_plane_n[bp_cnt+1] = do_xor[1] ? dbx[1] ^ bit_plane_n[bp_cnt] : dbx[1];
				if (bp_cnt <= 13)
					bp_cnt_n = bp_cnt + 2;
				else
					valid_bp_n = 1;

				if (valid_d[2]) begin
					bit_plane_n[bp_cnt+2] = do_xor[2] ? dbx[2] ^ bit_plane_n[bp_cnt+1] : dbx[2];
					if (bp_cnt <= 12)
						bp_cnt_n = bp_cnt + 3;
					else
						valid_bp_n = 1;

					if (valid_d[3]) begin
						bit_plane_n[bp_cnt+3] = do_xor[3] ? dbx[3] ^ bit_plane_n[bp_cnt+2] : dbx[3];
						if (bp_cnt <= 11)
							bp_cnt_n = bp_cnt + 4;
						else
							valid_bp_n = 1;
					end
				end
			end
		end

		if (valid_d[0] &eop_i & bp_cnt <= 15) 	valid_bp_n = 1;	

		///////////////////////////////////////////////////////////////////////////////////////////
		bu_cnt_n = bu_cnt;
	
		data_out = 0;

		sop = (bu_cnt == 0 & valid);
		eop = (bu_cnt == 15 & valid);

		valid = (valid_bp == 1);
		//if (valid_bp) begin
		//	valid = 1;
		//end

		if (valid & ready_i) begin
			if (bu_cnt == 'd0) begin
				origin[0] = base_word;
				origin[1] = base_word + delta[0];
				origin[2] = base_word + delta[1];
				origin[3] = base_word + delta[2];
			end
			else begin
				origin[0] = base_word + delta[bu_cnt*4 - 1];
				origin[1] = base_word + delta[bu_cnt*4];
				origin[2] = base_word + delta[bu_cnt*4 + 1];
				origin[3] = base_word + delta[bu_cnt*4 + 2];
			end
			
			data_out = {origin[0], origin[1], origin[2], origin[3]};

			if (bu_cnt <= 14) begin
				bu_cnt_n = bu_cnt + 1;
			end

			if (bu_cnt == 15) begin
				in_cnt_n = 0;
				valid_n = 0;
				code_buf_n = 0;
				buf_size_n = 0;
				zrl_cnt_n = 0;
				bp_cnt_n = 0;
				valid_bp_n = 0;
				bu_cnt_n = 0;
				for (i=0; i<16; i=i+1) begin
					bit_plane_n[i] = 0;
				end
			end
		end
		
	end

	DECODER_GROUP DEC_GRP(
		.code_buf_i		(code_buf_i),
		.buf_size_i		(buf_size_i),
		.zrl_cnt_i		(zrl_cnt_i),
	
		.code_buf_o		(code_buf_o),
		.buf_size_o		(buf_size_o),
		.zrl_cnt_o		(zrl_cnt_o),

		.valid_o		({valid_d[0], valid_d[1], valid_d[2], valid_d[3]}),
		.data_o			({dbx[0], dbx[1], dbx[2], dbx[3]}),
		.do_xor_o		({do_xor[0], do_xor[1], do_xor[2], do_xor[3]})
	);
	

	
	genvar idx, jdx;
	generate
		for (idx=0; idx<63; idx=idx+1) begin : bp_x_axis
			for (jdx=0; jdx<16; jdx=jdx+1) begin : bp_y_axis
				assign delta[idx][15-jdx] = bit_plane[jdx][62-idx];
			end
		end
	endgenerate
	


	// FF
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			code_buf 		<= 'd0;
			buf_size 		<= 'd0;
			zrl_cnt 		<= 'd0;
			bp_cnt 			<= 'd0;
			in_cnt 			<= 'd0;
			base_word 		<= 'd0;
			valid_bp 		<= 'd0;
			for (i=0; i<16; i=i+1) begin
				bit_plane[i] 	<= 'd0;
			end
			valid			<= 'd0;
			bu_cnt			<= 'd0;
		end
		else begin
			code_buf 		<= code_buf_n;
			buf_size 		<= buf_size_n;
			zrl_cnt 		<= zrl_cnt_n;
			bp_cnt 			<= bp_cnt_n;
			in_cnt			<= in_cnt_n;
			base_word		<= base_word_n;
			valid_bp		<= valid_bp_n;
			for (i=0; i<16; i=i+1) begin
				bit_plane[i] 	<= bit_plane_n[i];
			end
			valid			<= valid_n;
			bu_cnt			<= bu_cnt_n;
		end
	end
	
	assign 	ready_o = ready;
	assign 	sop_o = sop;
	assign 	eop_o = eop;
	assign	valid_o = valid;
	assign 	data_o = data_out;

	
endmodule
