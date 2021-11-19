module ZRL_CODEBUF
(
	input wire [67:0]   		data_i,
	input wire [6:0] 		size_i,
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
	output wire  			ready_o
);


	reg [63:0] 			data_out, data_out_n;
	reg [10:0] 			size_out, size_out_n;
	reg [143:0] 			code_buf, code_buf_n;
	reg [7:0] 			buf_size, buf_size_n;
	reg [10:0]			total_size, total_size_n;
	reg				data_valid, data_valid_n;
	reg                             size_valid, size_valid_n;
	reg [3:0]			bcnt, bcnt_n;
	reg				eop_mid;


	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			data_out <= 'b0;
			size_out <= 'b0;
			code_buf <= 'b0;
			buf_size <= 'b0;
			total_size <= 'b0;
			data_valid <= 'b0;
			size_valid <= 'b0;
			bcnt <= 'b0;
		end
		else begin
			data_out <= data_out_n;
			size_out <= size_out_n;
			code_buf <= code_buf_n;
			buf_size <= buf_size_n;
			total_size <= total_size_n;
			data_valid <= data_valid_n;
			size_valid <= size_valid_n;
			bcnt <= bcnt_n;
		end
	end


	always @(*) begin
		buf_size_n = buf_size;
		total_size_n = total_size;
		code_buf_n = code_buf;
		bcnt_n = bcnt;
		data_valid_n = 1'b0;
		size_valid_n = 1'b0;
		data_out_n = 'b0;
		size_out_n = 'b0;
		eop_mid = 1'b0;
		
		if (valid_i & ready_i) begin
			code_buf_n = code_buf | (data_i << (76 - buf_size));
			buf_size_n = buf_size + size_i;
			total_size_n = total_size + size_i;

			if (eop_i) begin
				eop_mid = 1'b1;
			end

/*			if (buf_size_n >= 64) begin
				if (bcnt != 8) begin
					data_valid_n = 1'b1;
					data_out_n = code_buf_n[143:80];
					code_buf_n = code_buf_n << 64;
					buf_size_n = buf_size_n - 64;
					bcnt_n = bcnt + 1;
				end else begin
					code_buf_n = 'b0;
					buf_size_n = 0;
					total_size_n = 513;
				end
			end

			if (eop_i) begin
				if (buf_size_n != 0) begin
					if (bcnt_n == 8) begin
						buf_size_n = 0;
						bcnt_n = 0;
					end else begin
						buf_size_n = 64;
						bcnt_n = 15;
					end
				end else begin
					bcnt_n = 0;
				end
				size_valid_n = 1'b1;
				size_out_n = total_size_n;
				total_size_n = 0;
			end
*/
		end

		if (ready_i) begin
			if (buf_size_n >= 64) begin
				if (bcnt != 8) begin
					data_valid_n = 1'b1;
					data_out_n = code_buf_n[143:80];
					code_buf_n = code_buf_n << 64;
					buf_size_n = buf_size_n - 64;
					bcnt_n = bcnt + 1;
				end else begin
					code_buf_n = 'b0;
					buf_size_n = 0;
					total_size_n = 513;
				end
			end

			if (eop_mid) begin
				if (buf_size_n != 0) begin
					if (bcnt_n == 8) begin
						buf_size_n = 0;
						code_buf_n = 'b0;
						bcnt_n = 0;
					end else begin
						buf_size_n = 64;
						bcnt_n = 15;
					end
				end else begin
					bcnt_n = 0;
				end
				size_valid_n = 1'b1;
				size_out_n = total_size_n;
				total_size_n = 0;
				eop_mid = 1'b0;
			end
		end
	end

	assign data_o = data_out;
	assign size_o = size_out;
	assign d_valid = data_valid;
	assign s_valid = size_valid;
	assign ready_o = ready_i;

endmodule
