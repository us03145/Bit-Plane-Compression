//-------------------------------------
// Design Name  : ZRL_COMP
// File Name    : zrle_comp.v
// Function     : Synchronous ZRL Encoding
//                  
// Coder        : Urim Hwang
//-------------------------------------

module ZRL_COMP
(
    input   wire  [63:0] 	data_i,
    input   wire                valid_i,
    input   wire                ready_i,
    input   wire                sop_i,
    input   wire                eop_i,
    input   wire                rst_n,
    input   wire                clk,

    output  wire   [67:0]        data_o,
    output  wire   [6:0]         size_o,
    output  wire                 sop_o,
    output  wire                 eop_o,
    output  wire                 valid_o,
    output  wire                ready_o
);

    wire          [3:0]         if_nonzero;
    reg          [67:0]        data, data_n;
    reg          [6:0]         size, size_n;
    reg                        sop, sop_n;
    reg                        eop, eop_n;
    reg                        valid_out, valid_n;

    assign if_nonzero = {| data_i[63:48], | data_i[47:32], | data_i[31:16], | data_i[15:0]};
    assign ready_o = ready_i;
    
    always @(*) begin
        if (valid_i & ready_i) begin
	    sop_n = 'b0;
	    eop_n = 'b0;
            case (if_nonzero)
                4'b0000: begin
		    if (sop_i) begin
			data_n = {2'b01, 6'b000000, 60'b0};
			size_n = 8;
			sop_n = 1'b1;
		    end else begin
                        data_n = {6'b000000, 62'b0};
                        size_n = 6;
		    end
                end
                4'b0001: begin 
		    if (sop_i) begin
                        data_n = {2'b01, 6'b000001, data_i[15:0], 44'b0};
                        size_n = 24;
			sop_n = 1'b1;
		    end else begin
                        data_n = {6'b000001, data_i[15:0], 46'b0};
                        size_n = 22;
		    end
                end
                4'b0010: begin
		    if (sop_i) begin
                        data_n = {2'b01, 5'b00001, data_i[31:16], 45'b0};
                        size_n = 23;
			sop_n = 1'b1;
		    end else begin
                        data_n = {5'b00001, data_i[31:16], 47'b0};
                        size_n = 21;
		    end
                end
                4'b0100: begin
		    if (sop_i) begin
			data_n = {2'b01, 5'b00010, data_i[47:32], 45'b0};
                        size_n = 23;
			sop_n = 1'b1;
		    end else begin
                        data_n = {5'b00010, data_i[47:32], 47'b0};
                        size_n = 21;
		    end
	        end
                4'b1000: begin
		    if (sop_i) begin
			data_n = {2'b01, 5'b00011, data_i[63:48], 45'b0};
                        size_n = 23;
			sop_n = 1'b1;
		    end else begin
                        data_n = {5'b00011, data_i[63:48], 47'b0};
                        size_n = 21;
		    end
                   
                end
                4'b0011: begin
		    if (sop_i) begin
			data_n = {2'b01, 4'b0010, data_i[31:16], data_i[15:0], 30'b0};
                        size_n = 38;
			sop_n = 1'b1;
		    end else begin
                        data_n = {4'b0010, data_i[31:16], data_i[15:0], 32'b0};
                        size_n = 36;
		    end
                end
                4'b0101: begin
		    if (sop_i) begin
			data_n = {2'b01, 4'b0011, data_i[47:32], data_i[15:0], 30'b0};
                        size_n = 38;
			sop_n = 1'b1;
		    end else begin
                        data_n = {4'b0011, data_i[47:32], data_i[15:0], 32'b0};
                        size_n = 36;
		    end
                end
                4'b1001: begin
		    if (sop_i) begin
			data_n = {2'b01, 4'b0100, data_i[63:48], data_i[15:0], 30'b0};
                        size_n = 38;
			sop_n = 1'b1;
		    end else begin
                        data_n = {4'b0100, data_i[63:48], data_i[15:0], 32'b0};
                        size_n = 36;
		    end
                end
                4'b0110: begin
		    if (sop_i) begin
			data_n = {2'b01, 4'b0101, data_i[47:32], data_i[31:16], 30'b0};
                        size_n = 38;
			sop_n = 1'b1;
		    end else begin
                        data_n = {4'b0101, data_i[47:32], data_i[31:16], 32'b0};
                        size_n = 36;
		    end
                end
                4'b1010: begin
		    if (sop_i) begin
                        data_n = {2'b01, 4'b0110, data_i[63:48], data_i[31:16], 30'b0};
                        size_n = 38;
			sop_n = 1'b1;
		    end else begin
                        data_n = {4'b0110, data_i[63:48], data_i[31:16], 32'b0};
                        size_n = 36;
		    end
                end
                4'b1100: begin
		    if (sop_i) begin
			data_n = {2'b01, 4'b0111, data_i[63:48], data_i[47:32], 30'b0};
                        size_n = 38;
			sop_n = 1'b1;
		    end else begin
                        data_n = {4'b0111, data_i[63:48], data_i[47:32], 32'b0};
                        size_n = 36;
		    end
                end
                4'b0111: begin
		    if (sop_i) begin
			data_n = {2'b01, 4'b1000, data_i[47:32], data_i[31:16], data_i[15:0], 14'b0};
                        size_n = 54;
			sop_n = 1'b1;
		    end else begin
                        data_n = {4'b1000, data_i[47:32], data_i[31:16], data_i[15:0], 16'b0};
                        size_n = 52;
		    end
                end
                4'b1011: begin
		    if (sop_i) begin
			data_n = {2'b01, 4'b1001, data_i[63:48], data_i[31:16], data_i[15:0], 14'b0};
                        size_n = 54;
			sop_n = 1'b1;
		    end else begin
                        data_n = {4'b1001, data_i[63:48], data_i[31:16], data_i[15:0], 16'b0};
                        size_n = 52;
		    end
                end
                4'b1101: begin
		    if (sop_i) begin
			data_n = {2'b01, 4'b1010, data_i[63:48], data_i[47:32], data_i[15:0], 14'b0};
                        size_n = 54;
			sop_n = 1'b1;
		    end else begin
                        data_n = {4'b1010, data_i[63:48], data_i[47:32], data_i[15:0], 16'b0};
                        size_n = 52;
		    end
                end
                4'b1110: begin
		    if (sop_i) begin
			data_n = {2'b01, 4'b1011, data_i[63:48], data_i[47:32], data_i[31:16], 14'b0};
                        size_n = 54;
			sop_n = 1'b1;
		    end else begin
                        data_n = {4'b1011, data_i[63:48], data_i[47:32], data_i[31:16], 16'b0};
                        size_n = 52;
		    end
                end
                4'b1111: begin
		    if (sop_i) begin
			data_n = {2'b01, 2'b11, data_i};
                        size_n = 68;
			sop_n = 1'b1;
		    end else begin
                        data_n = {2'b11, data_i, 2'b0};
                        size_n = 66;
		    end
                end
            endcase
	    if (eop_i) begin
                eop_n = 1'b1;
            end
	    valid_n = 1'b1;
        end else begin
	    valid_n = 1'b0;
	end
    end
  
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 0;
            size <= 0;
	    sop <= 0;
	    eop <= 0;
	    valid_out <= 0;
        end else begin
            data <= data_n;
            size <= size_n;
	    sop <= sop_n;
	    eop <= eop_n;
	    valid_out <= valid_n;
        end
    end

    assign data_o = data;
    assign size_o = size;
    assign sop_o = sop;
    assign eop_o = eop;
    assign valid_o = valid_out;

 
endmodule
