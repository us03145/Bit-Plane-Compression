//-------------------------------------
// Design Name  : SR_COMP
// File Name    : sr_comp.v
// Function     : Synchronous Sign Reduction Encoding
//                  
// Coder        : Urim Hwang
//-------------------------------------

module SR_COMP
(
    input   wire  [63:0] 		data_i,
    input   wire                valid_i,
    input   wire                ready_i,
    input   wire                rst_n,
    input   wire                clk,

    output  wire   [63:0] 		data_o,
    output  wire   		        flag_o,
    output  wire                        ready_o,
    output  wire                        d_valid,
    output  wire			s_valid
);

    wire          [3:0]         if_fail_pos;
    wire          [3:0]         if_fail_neg;
    wire          [3:0]         if_fail;
    reg          [31:0]        data, data_n;
    reg                        flag, flag_n;
    reg           [3:0]        bcnt, bcnt_n;
    reg          [63:0]        data_out, data_out_n;
    reg                        flag_out, flag_out_n;
    reg                        d_valid_out, d_valid_out_n;
    reg                        s_valid_out, s_valid_out_n;

    assign if_fail_pos = {| data_i[63:55], | data_i[47:39], | data_i[31:23], | data_i[15:7]};
    assign if_fail_neg = ~{& data_i[63:55], & data_i[47:39], & data_i[31:23], & data_i[15:7]};
    assign if_fail = if_fail_pos & if_fail_neg;
    assign ready_o = ready_i;
    
    always @(*) begin
    	data_n = data;
    	flag_n = flag;
    	bcnt_n = bcnt;
	d_valid_out_n = 1'b0;
	s_valid_out_n = 1'b0;
	data_out_n = 'b0;
	flag_out_n = 1'b0;
        if (valid_i & ready_i) begin
           if (bcnt[0]) begin
		d_valid_out_n = 1'b1;
           	data_out_n = {data_n[31:0], data_i[55:48], data_i[39:32], data_i[23:16], data_i[7:0]};
           end else begin
	        if (bcnt == 4'b0000) begin
		    data_n = {1'b1, data_i[54:48], data_i[39:32], data_i[23:16], data_i[7:0]};
		end else begin
           	    data_n = {data_i[55:48], data_i[39:32], data_i[23:16], data_i[7:0]};
		end
           end
           bcnt_n = bcnt + 1;
           flag_n = (flag | (| if_fail));
	   if (bcnt == 4'b0000) begin
	   	flag_n = (flag_n | (data_i[55] ^ data_i[54]));
	   end
	   
           if (bcnt == 4'b1111) begin
	        s_valid_out_n = 1'b1;
           	flag_out_n = flag_n;
		flag_n = 0;
           end
        end
    end
  
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 'b0;
            flag <= 'b0;
            bcnt <= 'b0;
            data_out <= 'b0;
            flag_out <= 'b0;
	    d_valid_out <= 'b0;
	    s_valid_out <= 'b0;
        end else begin
            data <= data_n;
            flag <= flag_n;
            bcnt <= bcnt_n;
            data_out <= data_out_n;
            flag_out <= flag_out_n;
	    d_valid_out <= d_valid_out_n;
	    s_valid_out <= s_valid_out_n;
        end
    end
    
    assign data_o = data_out;
    assign flag_o = flag_out;
    assign d_valid = d_valid_out;
    assign s_valid = s_valid_out;
 
endmodule
