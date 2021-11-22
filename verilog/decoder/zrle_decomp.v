
module ZRLE_DECOMP (
	input wire				rst_n,
	input wire				clk,
	
	input wire 				valid_i,
	input wire [63:0]			data_i,
	input wire				sop_i,
	input wire				eop_i,
	
	input wire				ready_i,

	output wire				ready_o,
	output wire				sop_o,
	output wire 				eop_o,
	
	output wire				valid_o,
	output wire [63:0]			data_o
);


	reg [7:0]				size, size_n, size_nn;
	reg [127:0]				code_buf, code_buf_n, code_buf_nn;
	
	reg 					ready;
	reg [63:0] 				data_out;
	reg 					sop;
	reg 					eop;	
	reg 					valid_out;

	reg 					out_over, out_over_n;

	reg [3:0]				in_bcnt, in_bcnt_n;		// input burst count
	reg [3:0] 				out_bcnt, out_bcnt_n;	// output burst count
	// Seqen //////////////////////////////////////////////
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			size 		<= 'b0;
			code_buf 	<= 'b0;

			out_over	<= 'b0;
			in_bcnt		<= 'b0;
			out_bcnt 	<= 'b0;
		end 
		else begin
			size 		<= size_nn;
			code_buf 	<= code_buf_nn;
		
			out_over	<= out_over_n;
			in_bcnt 	<= in_bcnt_n;
			out_bcnt	<= out_bcnt_n;
		end
	end
	
	///////////////////////////////////////////////////////
	// rstn 	____----------------------------------------
	// clk		____----____----____----____----____----____
	// data_i	____x=======x=======x===============x=======
	// valid_i	____----------------------------------------
	// ready	____----------------________----------------
	// 
	// data_o	____________x=======x=======x=======x=======
	// valid_o	____________--------------------------------
	// Comb ///////////////////////////////////////////////
	
	always @(*) begin
		data_out 	= 0;
		valid_out	= 0;
		in_bcnt_n	= in_bcnt;
		out_bcnt_n 	= out_bcnt;
		size_nn 	= size_n;
		size_n		= size;
		code_buf_nn	= code_buf_n;
		code_buf_n	= code_buf;
		out_over_n 	= out_over;

		if (!valid_out | (valid_out & ready_i)) begin
			if (!out_over) begin
			casez (code_buf[127:122])
				6'b000000: begin
					if (size >= 'd6) begin
						data_out = 64'b0;
						valid_out = 1'b1;
						size_n = size - 6;
						code_buf_n = code_buf << 6;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b000001: begin
					if (size >= 'd22) begin
						data_out = {16'b0, 16'b0, 16'b0, code_buf[121:106]};
						valid_out = 1'b1;
						size_n = size - 22;
						code_buf_n = code_buf << 22;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b00001?: begin
					if (size >= 'd21) begin
						data_out = {16'b0, 16'b0, code_buf[122:107], 16'b0};
						valid_out = 1'b1;
						size_n = size - 21;
						code_buf_n = code_buf << 21;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b00010?: begin
					if (size >= 'd21) begin
						data_out = {16'b0, code_buf[122:107], 16'b0, 16'b0};
						valid_out = 1'b1;
						size_n = size - 21;
						code_buf_n = code_buf << 21;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b00011?: begin
					if (size >= 'd21) begin
						data_out = {code_buf[122:107], 16'b0, 16'b0, 16'b0};
						valid_out = 1'b1;
						size_n = size - 21;
						code_buf_n = code_buf << 21;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b0010??: begin
					if (size >= 'd36) begin
						data_out = {16'b0, 16'b0, code_buf[123:108], code_buf[107:92]};
						valid_out = 1'b1;
						size_n = size - 36;
						code_buf_n = code_buf << 36;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b0011??: begin
					if (size >= 'd36) begin
						data_out = {16'b0, code_buf[123:108], 16'b0, code_buf[107:92]};
						valid_out = 1'b1;
						size_n = size - 36;
						code_buf_n = code_buf << 36;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b0100??: begin
					if (size >= 'd36) begin
						data_out = {code_buf[123:108], 16'b0, 16'b0, code_buf[107:92]};
						valid_out = 1'b1;
						size_n = size - 36;
						code_buf_n = code_buf << 36;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b0101??: begin
					if (size >= 'd36) begin
						data_out = {16'b0, code_buf[123:108], code_buf[107:92], 16'b0};
						valid_out = 1'b1;
						size_n = size - 36;
						code_buf_n = code_buf << 36;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b0110??: begin
					if (size >= 'd36) begin
						data_out = {code_buf[123:108], 16'b0, code_buf[107:92], 16'b0};
						valid_out = 1'b1;
						size_n = size - 36;
						code_buf_n = code_buf << 36;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b0111??: begin
					if (size >= 'd36) begin
						data_out = {code_buf[123:108], code_buf[107:92], 16'b0, 16'b0};
						valid_out = 1'b1;
						size_n = size - 36;
						code_buf_n = code_buf << 36;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b1000??: begin
					if (size >= 'd52) begin
						data_out = {16'b0, code_buf[123:108], code_buf[107:92], code_buf[91:76]};
						valid_out = 1'b1;
						size_n = size - 52;
						code_buf_n = code_buf << 52;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b1001??: begin
					if (size >= 'd52) begin
						data_out = {code_buf[123:108], 16'b0, code_buf[107:92], code_buf[91:76]};
						valid_out = 1'b1;
						size_n = size - 52;
						code_buf_n = code_buf << 52;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b1010??: begin
					if (size >= 'd52) begin
						data_out = {code_buf[123:108], code_buf[107:92], 16'b0, code_buf[91:76]};
						valid_out = 1'b1;
						size_n = size - 52;
						code_buf_n = code_buf << 52;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b1011??: begin
					if (size >= 'd52) begin
						data_out = {code_buf[123:108], code_buf[107:92], code_buf[91:76], 16'b0};
						valid_out = 1'b1;
						size_n = size - 52;
						code_buf_n = code_buf << 52;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				6'b11????: begin
					if (size >= 'd66) begin
						data_out = code_buf[125:62];
						valid_out = 1'b1;
						size_n = size - 66;
						code_buf_n = code_buf << 66;
						out_bcnt_n = (out_bcnt <= 14) ? out_bcnt + 1 : out_bcnt;
					end
				end
				default: begin
					valid_out = 1'b0;
				end
			endcase
			end
			else begin
				valid_out = 0;
			end
		end
		else begin
			code_buf_n = code_buf;
			size_n = size;
		end
		
		// output burst start & end signal sop_o & eop_o
		sop = (out_bcnt == 'd0 & valid_out);
		eop = (out_bcnt == 'd15 & valid_out);

		if (size_n <= 'd64) begin
			ready = 1'b1;
			if (in_bcnt >= 8) begin
				ready = 0;
			end
		end
		else begin // size_N > 64
			ready = 0;
			if (out_over) begin
				ready = 1;
			end
		end

		if (valid_i & ready) begin
			if (!out_over) begin
				if (sop_i) begin
					code_buf_nn = code_buf_n | (data_i[61:0] << (66 - size_n));
					size_nn = size + 62;
				end
				else begin
					code_buf_nn = code_buf_n | (data_i << (64 - size_n));
					size_nn = size_n + 64;
				end
			end	
			in_bcnt_n = in_bcnt + 1;
			
		end
		else begin
			code_buf_nn = code_buf_n;
			size_nn = size_n;
		end
		
		if (out_bcnt == 15) begin
			out_over_n = 1;
			code_buf_nn = 0;
			size_nn = 0;
		end
		else begin
			out_over_n = 0;
		end

		if (out_over) begin
			if (in_bcnt >= 8) begin
				in_bcnt_n = 0;
				out_bcnt_n = 0;
				out_over_n = 0;
			end
		end
	end
	///////////////////////////////////////////////////////
	
	assign ready_o 	= ready;
	assign data_o 	= data_out;
	assign valid_o 	= valid_out;
	assign sop_o 	= sop;
	assign eop_o 	= eop;

endmodule


