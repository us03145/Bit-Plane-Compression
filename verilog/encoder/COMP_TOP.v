module COMP_TOP #(
    parameter   D_BITWIDTH        = 64,
    parameter   D_STAGE           = 16,
    parameter   D_STAGE_BITWIDTH  = $clog2(16),
    parameter   S_BITWIDTH        = 11,
    parameter   S_STAGE           = 16,
    parameter   S_STAGE_BITWIDTH  = $clog2(16),
    parameter   SR_BITWIDTH       = 1
) (
    input   wire          clk,
    input   wire          rst_n,

    input   wire  [63:0]  data_i,
    input   wire          valid_i,
    input   wire          ready_i,
    input   wire          sop_i,
    input   wire          eop_i,

    output  wire  [63:0]  data_o,
    output  wire          valid_o,
    output  wire          ready_o,
    output  wire          sop_o,
    output  wire          eop_o
);

    wire  [145:0] bpc_data_mid;
    wire  [7:0]   bpc_size_mid;
    wire          bpc_sop_mid;
    wire          bpc_eop_mid;
    wire          bpc_valid_mid;
    wire          bpc_ready_out;
    wire          bpc_ready_in;
    wire  [63:0]  bpc_data_out;
    wire  [10:0]  bpc_size_out;
    wire          bpc_d_valid;
    wire          bpc_s_valid;
    wire          bpc_ready_mid;
    wire          bpc_sop_out;
    wire          bpc_eop_out;   

    wire  [63:0]  bpc_fifo_d_out;
    wire          bpc_fifo_d_full;
    wire          bpc_fifo_d_empty;
    wire          bpc_fifo_d_th;
    wire          bpc_fifo_d_over;
    wire          bpc_fifo_d_under;
    wire  [10:0]  bpc_fifo_s_out;
    wire          bpc_fifo_s_full;
    wire          bpc_fifo_s_empty;
    wire          bpc_fifo_s_th;
    wire          bpc_fifo_s_over;
    wire          bpc_fifo_s_under;

    wire  [67:0]  zrl_data_mid;
    wire  [6:0]   zrl_size_mid;
    wire          zrl_sop_mid;
    wire          zrl_eop_mid;
    wire          zrl_valid_mid;
    wire          zrl_ready_out;
    wire          zrl_ready_in;
    wire  [63:0]  zrl_data_out;
    wire  [10:0]  zrl_size_out;
    wire          zrl_d_valid;
    wire          zrl_s_valid;
    wire          zrl_ready_mid;
    wire          zrl_sop_out;
    wire          zrl_eop_out;
    
    wire  [63:0]  zrl_fifo_d_out;
    wire          zrl_fifo_d_full;
    wire          zrl_fifo_d_empty;
    wire          zrl_fifo_d_th;
    wire          zrl_fifo_d_over;
    wire          zrl_fifo_d_under;
    wire  [10:0]  zrl_fifo_s_out;
    wire          zrl_fifo_s_full;
    wire          zrl_fifo_s_empty;
    wire          zrl_fifo_s_th;
    wire          zrl_fifo_s_over;
    wire          zrl_fifo_s_under;

    wire  [63:0]  sr_data_out;
    wire          sr_size_out;
    wire          sr_ready_out;
    wire          sr_ready_in;
    wire          sr_d_valid;
    wire          sr_s_valid;
    
    wire  [63:0]  sr_fifo_d_out;
    wire          sr_fifo_d_full;
    wire          sr_fifo_d_empty;
    wire          sr_fifo_d_th;
    wire          sr_fifo_d_over;
    wire          sr_fifo_d_under;
    wire          sr_fifo_s_out;
    wire          sr_fifo_s_full;
    wire          sr_fifo_s_empty;
    wire          sr_fifo_s_th;
    wire          sr_fifo_s_over;
    wire          sr_fifo_s_under;

    wire  [2:0]   ok_flag;
    wire          done;
    wire  [1:0]   mode;
    reg   [2:0]   bcnt, bcnt_n;
    reg           pad_flag;
    reg           bpc_flag;
    reg   [2:0]   bpc_cnt;
    reg           zrl_flag;
    reg   [2:0]   zrl_cnt;
    reg           valid_out;
    reg           sop_out, eop_out;
    reg           data_rd_bpc;
    reg           data_rd_zrl;
    reg           data_rd_sr;
    reg           size_rd_all;

    BPC_COMP BE0
    (
        .data_i           (data_i),
	.valid_i          (valid_i),
	.ready_i          (bpc_ready_mid),
	.sop_i            (sop_i),
	.eop_i            (eop_i),
	.rst_n            (rst_n),
	.clk              (clk),

	.data_o           (bpc_data_mid),
	.size_o           (bpc_size_mid),
	.sop_o            (bpc_sop_mid),
	.eop_o            (bpc_eop_mid),
	.valid_o          (bpc_valid_mid),
	.ready_o          (bpc_ready_out)
    );
    BPC_CODEBUF BEBUF
    (
	.data_i           (bpc_data_mid),
	.size_i           (bpc_size_mid),
	.valid_i          (bpc_valid_mid),
	.ready_i          (bpc_ready_in),
	.sop_i            (bpc_sop_mid),
	.eop_i            (bpc_eop_mid),
	.rst_n            (rst_n),
	.clk              (clk),

	.data_o           (bpc_data_out),
	.size_o           (bpc_size_out),
	.d_valid          (bpc_d_valid),
	.s_valid          (bpc_s_valid),
	.ready_o          (bpc_ready_mid),
	.sop_o            (bpc_sop_out),
	.eop_o            (bpc_eop_out)
    );
    FIFO #(
        .BITWIDTH         (D_BITWIDTH),
	.STAGE            (D_STAGE),
	.STAGE_BITWIDTH   (D_STAGE_BITWIDTH)
    ) FIFO_BPC_D (
        .data_i           (bpc_data_out),
	.wr_i             (bpc_d_valid),
	.rd_i             (data_rd_bpc),
	.rst_n            (rst_n),
	.clk              (clk),

	.data_o           (bpc_fifo_d_out),
	.full_o           (bpc_fifo_d_full),
	.empty_o          (bpc_fifo_d_empty),
	.threshold_o      (bpc_fifo_d_th),
	.overflow_o       (bpc_fifo_d_over),
	.underflow_o      (bpc_fifo_d_under)
    );
    FIFO #(
        .BITWIDTH         (S_BITWIDTH),
	.STAGE            (S_STAGE),
	.STAGE_BITWIDTH   (S_STAGE_BITWIDTH)
    ) FIFO_BPC_S (
        .data_i           (bpc_size_out),
	.wr_i             (bpc_s_valid),
	.rd_i             (size_rd_all),
	.rst_n            (rst_n),
	.clk              (clk),

	.data_o           (bpc_fifo_s_out),
	.full_o           (bpc_fifo_s_full),
        .empty_o          (bpc_fifo_s_empty),
        .threshold_o      (bpc_fifo_s_th),
        .overflow_o       (bpc_fifo_s_over),
        .underflow_o      (bpc_fifo_s_under)
    );
    ZRL_COMP ZE0
    (
        .data_i           (data_i),
	.valid_i          (valid_i),
	.ready_i          (zrl_ready_mid),
	.sop_i            (sop_i),
	.eop_i            (eop_i),
	.rst_n            (rst_n),
	.clk              (clk),

	.data_o           (zrl_data_mid),
	.size_o           (zrl_size_mid),
	.sop_o            (zrl_sop_mid),
	.eop_o            (zrl_eop_mid),
	.valid_o          (zrl_valid_mid),
	.ready_o          (zrl_ready_out)
    );
    ZRL_CODEBUF ZEBUF
    (
        .data_i           (zrl_data_mid),
	.size_i           (zrl_size_mid),
	.valid_i          (zrl_valid_mid),
	.ready_i          (zrl_ready_in),
	.sop_i            (zrl_sop_mid),
	.eop_i            (zrl_eop_mid),
	.rst_n            (rst_n),
	.clk              (clk),

	.data_o           (zrl_data_out),
	.size_o           (zrl_size_out),
	.d_valid          (zrl_d_valid),
	.s_valid          (zrl_s_valid),
	.ready_o          (zrl_ready_mid),
	.sop_o            (zrl_sop_out),
	.eop_o            (zrl_eop_out)
    );
    FIFO #(
        .BITWIDTH         (D_BITWIDTH),
	.STAGE            (D_STAGE),
	.STAGE_BITWIDTH   (D_STAGE_BITWIDTH)
    ) FIFO_ZRL_D (
        .data_i           (zrl_data_out),
	.wr_i             (zrl_d_valid),
	.rd_i             (data_rd_zrl),
	.rst_n            (rst_n),
	.clk              (clk),

	.data_o           (zrl_fifo_d_out),
	.full_o           (zrl_fifo_d_full),
	.empty_o          (zrl_fifo_d_empty),
	.threshold_o      (zrl_fifo_d_th),
	.overflow_o       (zrl_fifo_d_over),
	.underflow_o      (zrl_fifo_d_under)
    );
    FIFO #(
        .BITWIDTH         (S_BITWIDTH),
	.STAGE            (S_STAGE),
	.STAGE_BITWIDTH   (S_STAGE_BITWIDTH)
    ) FIFO_ZRL_S (
        .data_i           (zrl_size_out),
	.wr_i             (zrl_s_valid),
	.rd_i             (size_rd_all),
	.rst_n            (rst_n),
	.clk              (clk),

	.data_o           (zrl_fifo_s_out),
	.full_o           (zrl_fifo_s_full),
        .empty_o          (zrl_fifo_s_empty),
        .threshold_o      (zrl_fifo_s_th),
        .overflow_o       (zrl_fifo_s_over),
        .underflow_o      (zrl_fifo_s_under)
    );
    SR_COMP SE0
    (
        .data_i           (data_i),
	.valid_i          (valid_i),
	.ready_i          (sr_ready_in),
	.rst_n            (rst_n),
	.clk              (clk),

	.data_o           (sr_data_out),
	.flag_o           (sr_size_out),
	.ready_o          (sr_ready_out),
	.d_valid          (sr_d_valid),
	.s_valid          (sr_s_valid)
    );
    FIFO #(
        .BITWIDTH         (D_BITWIDTH),
	.STAGE            (D_STAGE),
	.STAGE_BITWIDTH   (D_STAGE_BITWIDTH)
    ) FIFO_SR_D (
        .data_i           (sr_data_out),
	.wr_i             (sr_d_valid),
	.rd_i             (data_rd_sr),
	.rst_n            (rst_n),
	.clk              (clk),

	.data_o           (sr_fifo_d_out),
	.full_o           (sr_fifo_d_full),
	.empty_o          (sr_fifo_d_empty),
	.threshold_o      (sr_fifo_d_th),
	.overflow_o       (sr_fifo_d_over),
	.underflow_o      (sr_fifo_d_under)
    );
    FIFO #(
        .BITWIDTH         (SR_BITWIDTH),
	.STAGE            (S_STAGE),
	.STAGE_BITWIDTH   (S_STAGE_BITWIDTH)
    ) FIFO_SR_S (
        .data_i           (sr_size_out),
	.wr_i             (sr_s_valid),
	.rd_i             (size_rd_all),
	.rst_n            (rst_n),
	.clk              (clk),

	.data_o           (sr_fifo_s_out),
	.full_o           (sr_fifo_s_full),
        .empty_o          (sr_fifo_s_empty),
        .threshold_o      (sr_fifo_s_th),
        .overflow_o       (sr_fifo_s_over),
        .underflow_o      (sr_fifo_s_under)
    );


    //  clk 		____----____----____---____---____----____
    //  bu_cnt 		____x 1     2       3     
    //  mode		____x 1     1        ...   x 2 ...
    //  rd (mode != 0) 	____x zrl_rd 1	===========x
    //	data_o  	____x zrl==================x sr ===
    //	
    //

    assign sr_ready_in = ready_i & (~sr_fifo_d_full);
    assign zrl_ready_in = ready_i & (~zrl_fifo_d_full);
    assign bpc_ready_in = ready_i & (~bpc_fifo_d_full);

    assign valid_o = valid_out;
    assign ready_o = sr_ready_out & zrl_ready_out & bpc_ready_out;
    assign sop_o = sop_out;
    assign eop_o = eop_out;

    assign done = (~sr_fifo_s_empty) & (~zrl_fifo_s_empty) & (~bpc_fifo_s_empty);

    assign ok_flag[2] = (sr_fifo_s_out == 0) ? 1'b1 : 1'b0;
    assign ok_flag[1] = (zrl_fifo_s_out <= 512) ? 1'b1 : 1'b0;
    assign ok_flag[0] = (bpc_fifo_s_out <= 512) ? 1'b1 : 1'b0;

    assign mode = (ok_flag == 3'b111) ? 2'b01 :
                  (ok_flag == 3'b110) ? 2'b01 :
                  (ok_flag == 3'b101) ? 2'b01 :
                  (ok_flag == 3'b100) ? 2'b01 :
                  (ok_flag == 3'b011) ? 2'b10 :
                  (ok_flag == 3'b010) ? 2'b10 :
                  (ok_flag == 3'b001) ? 2'b11 :
                  (ok_flag == 3'b000) ? 2'b11 : 2'b00;

    assign data_o = (pad_flag == 1'b1) ? 'b0 :
	            (mode == 2'b01) ? sr_fifo_d_out :
                    (mode == 2'b10) ? zrl_fifo_d_out :
                    (mode == 2'b11) ? bpc_fifo_d_out : 'b0;

    always @(posedge clk or negedge rst_n) begin
	if (~rst_n) begin
            bcnt <= 'b0;
        end else begin
            bcnt <= bcnt_n;
        end
    end

    always @(*) begin
	bcnt_n = bcnt;
	if (ready_i) begin
	    if (done) begin
		sop_out = 0;
		eop_out = 0;
		size_rd_all = 0;
		data_rd_zrl = 1;
		data_rd_sr = 1;
		data_rd_bpc = 1;
		pad_flag = 0;
		if (bcnt == 0) begin
	            sop_out = 1;
		    if (zrl_fifo_s_out < 449) begin
			zrl_flag = 1;
		        zrl_cnt = zrl_fifo_s_out[8:6] + (| zrl_fifo_s_out[5:0]);
		    end else begin
			zrl_flag = 0;
		    end
		    if (bpc_fifo_s_out < 449) begin
			bpc_flag = 1;
			bpc_cnt = bpc_fifo_s_out[8:6] + (| bpc_fifo_s_out[5:0]);
		    end else begin
			bpc_flag = 0;
		    end
	        end else if (bcnt == 7) begin
		    eop_out = 1;
		    size_rd_all = 1;
		end
		if (zrl_flag & (bcnt >= zrl_cnt)) begin
		    data_rd_zrl = 0;
		    if (mode == 2'b10) begin
			pad_flag = 1;
		    end
		end
		if (bpc_flag & (bcnt >= bpc_cnt)) begin
	            data_rd_bpc = 0;
		    if (mode == 2'b11) begin
			pad_flag = 1;
		    end
		end
		valid_out = 1;
		bcnt_n = bcnt + 1;
	    end else begin
		data_rd_bpc = 0;
		data_rd_zrl = 0;
		data_rd_sr = 0;
		size_rd_all = 0;
		sop_out = 0;
		eop_out = 0;
		valid_out = 0;
	    end
        end else begin
            data_rd_bpc = 0;
	    data_rd_zrl = 0;
	    data_rd_sr = 0;
	    size_rd_all = 0;
	    sop_out = 0;
	    eop_out = 0;
	    valid_out = 0;
        end
    end

endmodule
