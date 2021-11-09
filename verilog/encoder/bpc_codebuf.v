module BPC_CODEBUF
(
	input wire [145:0]   		data_i,
	input wire [7:0] 		size_i,
	input wire 			valid_i,
	input wire 			ready_i,
	input wire			sop_i,	
	input wire 			eop_i,
	input wire                      rst_n,
	input wire			clk,
	
	output wire [63:0] 		data_o,
	output wire [10:0]		size_o,
	output wire 			d_valid,
	output wire			s_valid,
	output wire  			ready_o,
	output wire			sop_o,
	output wire			eop_o
);


	reg [63:0] 			data_out, data_out_n;
	reg [10:0] 			size_out, size_out_n;
	reg [383:0] 			code_buf, code_buf_n;
	reg [8:0] 			buf_size, buf_size_n;
	reg [10:0]			total_size, total_size_n;
	reg				data_valid, data_valid_n;
	reg                             size_valid, size_valid_n;
	reg				sop_out, sop_out_n;
	reg				eop_out, eop_out_n;
	reg				flush, flush_n;
	reg [3:0]			send_cnt, send_cnt_n;


	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			data_out <= 'b0;
			size_out <= 'b0;
			code_buf <= 'b0;
			buf_size <= 'b0;
			total_size <= 'b0;
			data_valid <= 'b0;
			size_valid <= 'b0;
			sop_out <= 'b0;
			eop_out <= 'b0;
			flush <= 'b0;
			send_cnt <= 'b0;
		end
		else begin
			data_out <= data_out_n;
			size_out <= size_out_n;
			code_buf <= code_buf_n;
			buf_size <= buf_size_n;
			total_size <= total_size_n;
			data_valid <= data_valid_n;
			size_valid <= size_valid_n;
			sop_out <= sop_out_n;
			eop_out <= eop_out_n;
			flush <= flush_n;
			send_cnt <= send_cnt_n;
		end
	end


	always @(*) begin
		buf_size_n = buf_size;
		total_size_n = total_size;
		code_buf_n = code_buf;
		flush_n = flush;
		send_cnt_n = send_cnt;
		data_valid_n = 1'b0;
		size_valid_n = 1'b0;
		sop_out_n = 1'b0;
		eop_out_n = 1'b0;
		
		if (valid_i & ready_i) begin
			if (total_size < 512) begin
				code_buf_n = code_buf | (data_i << (238 - buf_size));
				buf_size_n = buf_size + size_i;
				total_size_n = total_size + size_i;
			end

			if (buf_size_n >= 64) begin
				data_valid_n = 1'b1;
				data_out_n = code_buf_n[383:320];
				code_buf_n = code_buf_n << 64;
				buf_size_n = buf_size_n - 64;
				send_cnt_n = send_cnt + 1;
			end

			if (eop_i) begin
				if (send_cnt_n == 8) begin
					flush_n = 0;
					size_valid_n = 1'b1;
					size_out_n = total_size_n;
					total_size_n = 0;
					code_buf_n = 'b0;
					buf_size_n = 0;
					send_cnt_n = 0;
				end else begin
					flush_n = 1;
					if (buf_size_n == 0) begin
						flush_n = 0;
						size_valid_n = 1'b1;
						size_out_n = total_size_n;
						total_size_n = 0;
						send_cnt_n = 0;
					end else if (buf_size_n <= 64) begin
						buf_size_n = 64;
					end else if (buf_size_n <= 128) begin
						buf_size_n = 128;
					end else if (buf_size_n <= 192) begin
						buf_size_n = 192;
					end else if (buf_size_n <= 256) begin
						buf_size_n = 256;
					end else if (buf_size_n <= 320) begin
						buf_size_n = 320;
					end else begin
						buf_size_n = 384;
					end
				end
			end
		end

		if (flush & ready_i) begin
			data_valid_n = 1'b1;
			data_out_n = code_buf_n[383:320];
			code_buf_n = code_buf_n << 64;
			buf_size_n = buf_size_n - 64;
			send_cnt_n = send_cnt + 1;
			if ((send_cnt_n == 8) | (buf_size_n == 0)) begin
				flush_n = 0;
				size_valid_n = 1'b1;
				size_out_n = total_size_n;
				total_size_n = 0;
				code_buf_n = 'b0;
				buf_size_n = 0;
				send_cnt_n = 0;
			end
		end
	end

	assign data_o = data_out;
	assign size_o = size_out;
	assign d_valid = data_valid;
	assign s_valid = size_valid;
	assign ready_o = ready_i;

endmodule
