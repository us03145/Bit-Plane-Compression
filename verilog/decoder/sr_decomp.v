
module SR_DECOMP 
(	input wire			rst_n,
	input wire			clk,
	
	input wire			valid_i,
	input wire [63:0]		data_i,
	input wire			sop_i,
	input wire			eop_i,
	
	input wire 			ready_i,

	output wire			ready_o,
	output reg			sop_o,
	output reg			eop_o,
	
	output wire			valid_o,
	output wire [63:0]		data_o
);
	
	reg				ready;
	reg [63:0]			data_out;
	reg				valid_out;
	reg [3:0]			bcnt, bcnt_n;		// burst count
	
	// Sequential logic //////////////////////////////////////////////
	always @(posedge clk or negedge rst_n) begin
		if (!rst_n) begin
			bcnt 		<= 4'b0;
		end
		else begin
			bcnt 		<= bcnt_n;
		end
	end
	////////////////////////////////////////////////////////////////////////////////////
	
	// rstn		____----------------------------------------------------------------
	// clk		____----____----____----____----____----____----____----____----____
	// sop_i	____--------________________________________________________________
	// data_i	____x===============x===============x===============x===============
	// valid_i	____----------------------------------------------------------------
	// ready_o	____--------________--------________--------________--------________
	// data_o	____x=======x=======x=======x=======x=======x=======x=======x=======
	// bcnt		____x   0   x   1   x   2   x   3   x   4   x   5   x   6   x   7   
	// valid_o	____----------------------------------------------------------------
	// ready_i	____----------------------------------------------------------------

	// Combination logic////////////////////////////////////////////////////////////////
	always @(*) begin
		bcnt_n = bcnt;
		valid_out = 0;
		data_out = 0;

		if (bcnt % 2 == 0) begin
			ready = 1;
		end else begin
			ready = 0;
		end
		if (valid_i) begin	
			if (!valid_out | (valid_out & ready_i)) begin
				if (bcnt == 0) begin
					data_out[63:55] = data_i[62] ? 9'b111111111 : 9'b000000000;
					data_out[54:48] = data_i[62:56];
					data_out[47:40] = data_i[55] ? 8'b11111111 : 8'b00000000;
					data_out[39:32] = data_i[55:48];
					data_out[31:24] = data_i[47] ? 8'b11111111 : 8'b00000000;
					data_out[23:16] = data_i[47:40];
					data_out[15: 8] = data_i[39] ? 8'b11111111 : 8'b00000000;
					data_out[ 7: 0] = data_i[39:32];
					valid_out = 1;
					bcnt_n = 1;
				end 
				else if (bcnt % 2 == 0) begin
					data_out[63:56] = data_i[63] ? 8'b11111111 : 8'b00000000;
					data_out[55:48] = data_i[63:56];
					data_out[47:40] = data_i[55] ? 8'b11111111 : 8'b00000000;
					data_out[39:32] = data_i[55:48];
					data_out[31:24] = data_i[47] ? 8'b11111111 : 8'b00000000;
					data_out[23:16] = data_i[47:40];
					data_out[15: 8] = data_i[39] ? 8'b11111111 : 8'b00000000;
					data_out[ 7: 0] = data_i[39:32];
					valid_out = 1;
					bcnt_n = bcnt + 1;
				end
				else if (bcnt % 2 == 1) begin
					data_out[63:56] = data_i[31] ? 8'b11111111 : 8'b00000000;
					data_out[55:48] = data_i[31:24];
					data_out[47:40] = data_i[23] ? 8'b11111111 : 8'b00000000;
					data_out[39:32] = data_i[23:16];
					data_out[31:24] = data_i[15] ? 8'b11111111 : 8'b00000000;
					data_out[23:16] = data_i[15: 8];
					data_out[15: 8] = data_i[ 7] ? 8'b11111111 : 8'b00000000;
					data_out[ 7: 0] = data_i[ 7: 0];
					valid_out = 1;
					bcnt_n = bcnt + 1;
				end
			end
		end				
		
		sop_o = (bcnt == 0 & valid_out);
		eop_o = (bcnt == 15 & valid_out);

	end
	
	assign ready_o = ready;
	assign data_o = data_out;
	assign valid_o = valid_out;
	
endmodule
