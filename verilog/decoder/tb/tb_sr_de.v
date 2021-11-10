`timescale 1ns/100ps

module TB_SR_DE;
        reg             clk, rstn;
        reg             valid_i;
	reg 		sop_i;
	reg 		eop_i;
        reg [63:0]      data_i;
        reg 		ready_i;
	wire [63:0]     data_o;
        wire            ready_o;
	wire 		sop_o, eop_o;
        wire            valid_o;

SR_DECOMP m0(
        .clk(clk),
        .rst_n(rstn),
        .data_i(data_i),
        .sop_i(sop_i),
        .eop_i(eop_i),
	.ready_i(ready_i),
        .valid_i(valid_i),
        .ready_o(ready_o),
        .sop_o(sop_o),
        .eop_o(eop_o),
        .valid_o(valid_o),
        .data_o(data_o)
);

reg [63:0] input_data[0:15];
integer i;

always
        #5 clk <= ~clk;

initial begin						// expected output
        input_data[0]  = 64'h8000000001010101;		// 0000000000000000
        input_data[1]  = 64'h0202020203030303;		// 0001000100010001
        input_data[2]  = 64'h0404040405050505;		// 0002000200020002
	input_data[3]  = 64'h0606060607070707;		// 0003000300030003
        input_data[4]  = 64'h0808080809090909;		// 0004000400040004
        input_data[5]  = 64'h0a0a0a0a0b0b0b0b;		// 0005000500050005
        input_data[6]  = 64'h0c0c0c0c0d0d0d0d;		// 0006000600060006
        input_data[7]  = 64'h0e0e0e0e0f0f0f0f;		// 0007000700070007
        input_data[8]  = 64'hf0f0f0f0f1f1f1f1; 		// 0008000800080008
        input_data[9]  = 64'hf2f2f2f2f3f3f3f3;		// 0009000900090009
        input_data[10] = 64'hf4f4f4f4f5f5f5f5;		// 000a000a000a000a
        input_data[11] = 64'hf6f6f6f6f7f7f7f7;		// 000b000b000b000b
        input_data[12] = 64'hf8f8f8f8f9f9f9f9;		// 000c000c000c000c
        input_data[13] = 64'hfafafafafbfbfbfb;		// 000d000d000d000d
        input_data[14] = 64'hfcfcfcfcfdfdfdfd;		// 000e000e000e000e
        input_data[15] = 64'hfefefefeffffffff;		// 000f000f000f000f ...
	
	clk <= 1'b1;
	rstn <= 1'b0;
	i = 0;
	#1 rstn = 1; valid_i = 1; sop_i = 1; eop_i = 0; data_i = input_data[i]; ready_i = 1;
	#10;
	while (i < 16) begin
		if (ready_o) begin
			i = i + 1;
			data_i = input_data[i];
			valid_i = (i < 16);
			sop_i = (i==0 || i==8 || i==16);
			eop_i = (i==7 || i==15 || i==23);
		end
		#10;
	end
	valid_i = 0;

	#100 $finish;
end

always #10 if (valid_o) $display($time, "\tinput data = %h\tdata = %h\tvalid = %d\tsop_o = %d\teop_o = %d", data_i, data_o, valid_o, sop_o, eop_o);


//initial $monitor($time, "\tinput data = %h\tready = %d\tdata = %h\tvalid = %d\tsop_o = %d\teop_o = %d", data_i, ready_o, data_o, valid_o, sop_o, eop_o);


endmodule
