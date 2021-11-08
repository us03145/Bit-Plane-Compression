module DECODER_GROUP(
	input wire [127:0]		code_buf_i,
	input wire [6:0] 		buf_size_i,
	input wire [3:0] 		zrl_cnt_i,

	output wire [127:0] 		code_buf_o,
	output wire [6:0] 		buf_size_o,
	output wire [3:0] 		zrl_cnt_o,

	output wire [251:0]		data_o,
	output wire [3:0]		valid_o,
	output wire [3:0]		do_xor_o
);

	wire 	[127:0] 		code_buf	[0:4];
	wire 	[6:0]			buf_size	[0:4];
	wire 	[3:0]			zrl_cnt		[0:4];

	wire 	[6:0]			shift_cnt	[0:3];

	wire 	[62:0]			data_out	[0:3];
	wire 				valid		[0:3];
	wire 				do_xor		[0:3];

	assign code_buf[0] = code_buf_i;
	assign buf_size[0] = buf_size_i;
	assign zrl_cnt[0] = zrl_cnt_i;

	genvar i;
	generate
		for (i=0; i<4; i=i+1) begin : decoders
			DECODER dec(
				.code_buf_i(code_buf[i]),
				.buf_size_i(buf_size[i]),
				.zrl_cnt_i(zrl_cnt[i]),
				
				.valid_o(valid[i]),
				.shift_cnt_o(shift_cnt[i]),
				.zrl_cnt_o(zrl_cnt[i+1]),
	
				.do_xor_o(do_xor[i]),
				.data_o(data_out[i])
			);
			assign code_buf[i+1] = code_buf[i] << shift_cnt[i];
			assign buf_size[i+1] = buf_size[i] - shift_cnt[i];
		end
	endgenerate

	assign data_o = {data_out[0], data_out[1], data_out[2], data_out[3]};
	assign valid_o = {valid[0], valid[1], valid[2], valid[3]};
	assign do_xor_o = {do_xor[0], do_xor[1], do_xor[2], do_xor[3]};

	assign code_buf_o = code_buf[4];
	assign buf_size_o = buf_size[4];
	assign zrl_cnt_o = zrl_cnt[4];
endmodule

/* 
bpc encoding	dbx's original size = 63 bit
symbol			len			encoding_symbol
_______________________________________________________________
run_len(2~16) 0		 6 bit			01_(run_len-2)[3:0]
0			 3 bit			001
all 1			 5 bit			00000
dbx!=0 & dbp=0		 5 bit			00001
consec two 1's		11 bit			00010_(StartingOnePos)[5:0]
single 1		11 bit			00011_(OnePos)[5:0]
uncompressed		64 bit			1_(uncompressedData)[62:0]
*/
module DECODER(
	input wire [127:0] 	code_buf_i,
	input wire [6:0]	buf_size_i,
	input wire [3:0]	zrl_cnt_i,
	
	output reg 		valid_o,	
	output reg [6:0]	shift_cnt_o,
	output reg [3:0] 	zrl_cnt_o,
	
	output reg		do_xor_o,
	output reg [62:0]	data_o
);

	always @(*) begin
		valid_o = 0;
		shift_cnt_o = 0;
		zrl_cnt_o = zrl_cnt_i;
		do_xor_o = 0;
		data_o = 0;
		if (zrl_cnt_i != 0) begin
			data_o = 64'b0;
			valid_o = 1;
			zrl_cnt_o = zrl_cnt_i - 'd1;
			shift_cnt_o = 'd0;
			do_xor_o = 'b1;
		end
		else begin
			casez (code_buf_i[127:123])
				5'b00000 : begin // all 1
					if (buf_size_i > 'd5) begin
						data_o = 63'h7fff_ffff_ffff_ffff;
						valid_o = 1;
						zrl_cnt_o = 'd0;
						shift_cnt_o = 'd5;
						do_xor_o = 'b1;
					end
				end
				5'b00001 : begin // dbx!=0 & dbp=0
					if (buf_size_i > 'd5) begin
						data_o = 63'h0000_0000_0000_0000;
						valid_o = 1;
						zrl_cnt_o = 'd0;
						shift_cnt_o = 'd5;
						do_xor_o = 'b0;
					end
				end
				5'b00010 : begin // consec two 1's
					if (buf_size_i > 'd11) begin
						data_o = 63'h0000_0000_0000_0000;
						valid_o = 1;
						data_o[code_buf_i[122:117]] = 1'b1;
						data_o[code_buf_i[122:117] + 1] = 1'b1;
						zrl_cnt_o = 'd0;
						shift_cnt_o = 'd11;
						do_xor_o = 'b1;
					end
				end
				5'b00011 : begin // single 1
					if (buf_size_i > 'd11) begin
						data_o = 63'h0000_0000_0000_0000;
						valid_o = 1;
						data_o[code_buf_i[122:117]] = 1'b1;
						zrl_cnt_o = 'd0;
						shift_cnt_o = 'd11;
						do_xor_o = 'b1;
					end
				end
				5'b001?? : begin // 0
					if (buf_size_i > 'd3) begin
						data_o = 63'h0000_0000_0000_0000;
						valid_o = 1;
						zrl_cnt_o = 'd0;
						shift_cnt_o = 'd3;
						do_xor_o = 'b1;
					end
				end
				5'b01??? : begin // run_len(2~16) 0
					if (buf_size_i > 'd6) begin
						data_o = 63'h0000_0000_0000_0000;
						valid_o = 1;
						zrl_cnt_o = code_buf_i[125:122] + 1;
						shift_cnt_o = 'd6;
						do_xor_o = 'b1;
					end
				end
				5'b1???? : begin // uncompressed
					if (buf_size_i > 'd64) begin
						data_o = code_buf_i[126:64];
						valid_o = 1;
						zrl_cnt_o = 'd0;
						shift_cnt_o = 'd64;
						do_xor_o = 'b1;
					end
				end
			endcase
		end
	end
endmodule


