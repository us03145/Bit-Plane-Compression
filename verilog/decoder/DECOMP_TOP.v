module DECOMP_TOP (
	input wire 		rst_n,
	input wire		clk,

	input wire [63:0] 	data_i,
	input wire 		valid_i,
	input wire 		ready_i,
	input wire 		sop_i,
	input wire 		eop_i,

	output wire [63:0] 	data_o,
	output wire 		valid_o,
	output wire 		ready_o,
	output wire 		sop_o,
	output wire 		eop_o
);
	reg 	[1:0] 		mode;
	parameter IDLE = 2'b00, BPC = 2'b01, ZRL = 2'b10, SR = 2'b11;

	always @(*) begin
		if (!rst_n)
			mode = 0;
		else begin
			if (sop_i) begin
				mode = (data_i[63:62] == 2'b00) ? BPC :
				       (data_i[63:62] == 2'b01) ? ZRL :
				       (data_i[63]    == 1'b1 ) ? SR  : mode;
			end
		end
	end

	wire [63:0] zrl_data_i;
	wire zrl_valid_i;
	wire [63:0] zrl_data_o;
	wire zrl_valid_o;
	wire zrl_ready_o;
	wire zrl_sop_o;
	wire zrl_eop_o;
	ZRLE_DECOMP ZRL_DECOMP_ENGINE(
		.rst_n(rst_n),
		.clk(clk),

		.data_i(zrl_data_i),
		.valid_i(zrl_valid_i),
		.ready_i(ready_i),
		.sop_i(sop_i),
		.eop_i(eop_i),

		.data_o(zrl_data_o),
		.valid_o(zrl_valid_o),
		.ready_o(zrl_ready_o),
		.sop_o(zrl_sop_o),
		.eop_o(zrl_eop_o)
	);

	wire [63:0] sr_data_i;
	wire sr_valid_i;
	wire [63:0] sr_data_o;
	wire sr_valid_o;
	wire sr_ready_o;
	wire sr_sop_o;
	wire sr_eop_o;
	SR_DECOMP SR_DECOMP_ENGINE(
		.rst_n(rst_n),
		.clk(clk),

		.data_i(sr_data_i),
		.valid_i(sr_valid_i),
		.ready_i(ready_i),
		.sop_i(sop_i),
		.eop_i(eop_i),

		.data_o(sr_data_o),
		.valid_o(sr_valid_o),
		.ready_o(sr_ready_o),
		.sop_o(sr_sop_o),
		.eop_o(sr_eop_o)
	);
	
	wire [63:0] bpc_data_i;
	wire bpc_valid_i;
	wire [63:0] bpc_data_o;
	wire bpc_valid_o;
	wire bpc_ready_o;
	wire bpc_sop_o;
	wire bpc_eop_o;
	BPC_DECOMP BPC_DECOMP_ENGINE(
		.rst_n(rst_n),
		.clk(clk),

		.data_i(bpc_data_i),
		.valid_i(bpc_valid_i),
		.ready_i(ready_i),
		.sop_i(sop_i),
		.eop_i(eop_i),

		.data_o(bpc_data_o),
		.valid_o(bpc_valid_o),
		.ready_o(bpc_ready_o),
		.sop_o(bpc_sop_o),
		.eop_o(bpc_eop_o)
	);

	assign zrl_data_i 	= (mode == ZRL) ? data_i : 'b0;
	assign sr_data_i	= (mode == SR ) ? data_i : 'b0;
	assign bpc_data_i 	= (mode == BPC) ? data_i : 'b0;

	assign zrl_valid_i 	= (mode == ZRL) ? valid_i : 'b0;
	assign sr_valid_i 	= (mode == SR ) ? valid_i : 'b0;
	assign bpc_valid_i 	= (mode == BPC) ? valid_i : 'b0;

	assign ready_o 		= zrl_ready_o & sr_ready_o & bpc_ready_o;

	assign data_o 		= (mode == ZRL) ? zrl_data_o :
				  (mode == SR ) ? sr_data_o  :
				  (mode == BPC) ? bpc_data_o : 'b0;

	assign valid_o 		= (mode == ZRL) ? zrl_valid_o :
				  (mode == SR ) ? sr_valid_o  :
				  (mode == BPC) ? bpc_valid_o : 'b0;	

	assign sop_o 		= (mode == ZRL) ? zrl_sop_o :
				  (mode == SR ) ? sr_sop_o  :
				  (mode == BPC) ? bpc_sop_o : 'b0;

	assign eop_o		= (mode == ZRL) ? zrl_eop_o :
				  (mode == SR ) ? sr_eop_o  :
				  (mode == BPC) ? bpc_eop_o : 'b0;

endmodule

