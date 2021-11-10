//-------------------------------------
// Design Name  : FIFO 
// File Name    : FIFO.v
// Function     : Asynchronous FIFO memory
//                  - threshold_o will be set when FIFO is half-filled
// Coder        : Hoyong Jin
//-------------------------------------

module FIFO #(
  parameter   BITWIDTH        = 64,
  parameter   STAGE           = 32,
  parameter   STAGE_BITWIDTH  = $clog2(STAGE)
) (
  input   wire  [BITWIDTH-1:0]  data_i,
  input   wire                  wr_i,
  input   wire                  rd_i,
  input   wire                  rst_n,
  input   wire                  clk,

  output  wire  [BITWIDTH-1:0]  data_o,
  output  wire                  full_o,
  output  wire                  empty_o,
  output  wire                  threshold_o,
  output  wire                  overflow_o,
  output  wire                  underflow_o
);

  wire  [STAGE_BITWIDTH:0]  wptr, rptr;
  wire                      fifo_we, fifo_rd;

  WRITE_POINTER #(
    .STAGE              (STAGE)
  ) WP0 (
    .wr_i               (wr_i),
    .fifo_full_i        (full_o),
    .clk                (clk),
    .rst_n              (rst_n),

    .wptr_o             (wptr),
    .fifo_we_o          (fifo_we)
  );
  READ_POINTER #(
    .STAGE              (STAGE)
  ) RP0 (
    .rd_i               (rd_i),
    .fifo_empty_i       (empty_o),
    .clk                (clk),
    .rst_n              (rst_n),

    .rptr_o             (rptr),
    .fifo_rd_o          (fifo_rd)
  );
  MEMORY_ARRAY #(
    .BITWIDTH           (BITWIDTH),
    .STAGE              (STAGE)
  ) MA0 (
    .data_i             (data_i),
    .wptr_i             (wptr),
    .rptr_i             (rptr),
    .fifo_we_i          (fifo_we),
    .clk                (clk),

    .data_o             (data_o)
  );
  STATUS_SIGNAL #(
    .STAGE              (STAGE)
  ) SS0 (
    .wr_i               (wr_i),
    .rd_i               (rd_i),
    .wptr_i             (wptr),
    .rptr_i             (rptr),
    .fifo_we_i          (fifo_we),
    .fifo_rd_i          (fifo_rd),
    .clk                (clk),
    .rst_n              (rst_n),

    .fifo_full_o        (full_o),
    .fifo_empty_o       (empty_o),
    .fifo_threshold_o   (threshold_o),
    .fifo_overflow_o    (overflow_o),
    .fifo_underflow_o   (underflow_o)
  );
endmodule

module WRITE_POINTER #(
  parameter   STAGE           = 32,
  parameter   STAGE_BITWIDTH  = $clog2(STAGE)
) (
  input   wire                      wr_i,
  input   wire                      fifo_full_i,
  input   wire                      clk,
  input   wire                      rst_n,

  output  reg   [STAGE_BITWIDTH:0]  wptr_o,
  output  wire                      fifo_we_o
);

  assign fifo_we_o = (~fifo_full_i) & wr_i;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      wptr_o <= 'd0;
    else if (fifo_we_o)
      wptr_o <= wptr_o + 'd1;
    else
      wptr_o <= wptr_o;
  end
endmodule

module READ_POINTER #(
  parameter   STAGE           = 32,
  parameter   STAGE_BITWIDTH  = $clog2(STAGE)
) (
  input   wire                      rd_i,
  input   wire                      fifo_empty_i,
  input   wire                      clk,
  input   wire                      rst_n,

  output  reg   [STAGE_BITWIDTH:0]  rptr_o,
  output  wire                      fifo_rd_o
);

  assign fifo_rd_o = (~fifo_empty_i) & rd_i;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      rptr_o <= 'd0;
    else if (fifo_rd_o)
      rptr_o <= rptr_o + 'd1;
    else
      rptr_o <= rptr_o;
  end
endmodule

module MEMORY_ARRAY #(
  parameter   BITWIDTH        = 64,
  parameter   STAGE           = 32,
  parameter   STAGE_BITWIDTH  = $clog2(STAGE)
) (
  input   wire  [BITWIDTH-1:0]      data_i,
  input   wire  [STAGE_BITWIDTH:0]  wptr_i,
  input   wire  [STAGE_BITWIDTH:0]  rptr_i,
  input   wire                      fifo_we_i,
  input   wire                      clk,

  output  wire  [BITWIDTH-1:0]      data_o
);

  reg   [BITWIDTH-1:0]  data_memory[STAGE-1:0];

  always @(posedge clk) begin
    if (fifo_we_i) begin
      data_memory[wptr_i[STAGE_BITWIDTH-1:0]] <= data_i;
    end
  end

  assign data_o = data_memory[rptr_i[STAGE_BITWIDTH-1:0]];
endmodule

module STATUS_SIGNAL #(
  parameter   STAGE           = 32,
  parameter   STAGE_BITWIDTH  = $clog2(STAGE)
) (
  input   wire                      wr_i,
  input   wire                      rd_i,
  input   wire  [STAGE_BITWIDTH:0]  wptr_i,
  input   wire  [STAGE_BITWIDTH:0]  rptr_i,
  input   wire                      fifo_we_i,
  input   wire                      fifo_rd_i,
  input   wire                      clk,
  input   wire                      rst_n,

  output  reg                       fifo_full_o,
  output  reg                       fifo_empty_o,
  output  reg                       fifo_threshold_o,
  output  reg                       fifo_overflow_o,
  output  reg                       fifo_underflow_o
);

  wire                      fbit_comp, overflow_set, underflow_set;
  wire                      ptr_equal;
  wire  [STAGE_BITWIDTH:0]  ptr_result;

  assign fbit_comp      =   wptr_i[STAGE_BITWIDTH] ^ rptr_i[STAGE_BITWIDTH];
  assign ptr_equal      =   (wptr_i[STAGE_BITWIDTH-1:0] - rptr_i[STAGE_BITWIDTH-1:0]) ? 0 : 1;
  assign ptr_result     =   wptr_i[STAGE_BITWIDTH:0] - rptr_i[STAGE_BITWIDTH:0];
  assign overflow_set   =   fifo_full_o & wr_i;
  assign underflow_set  =   fifo_empty_o & rd_i;

  // full, empty, threshold
  always @(*) begin
    fifo_full_o         =   fbit_comp & ptr_equal;
    fifo_empty_o        =   (~fbit_comp) & ptr_equal;
    fifo_threshold_o    =   (ptr_result[STAGE_BITWIDTH] || ptr_result[STAGE_BITWIDTH-1]) ? 1 : 0;
  end

  // overflow
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      fifo_overflow_o <= 0;
    end
    else begin
      fifo_overflow_o <= overflow_set ? 1 : 0;
    end
  end

  // underflow
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      fifo_underflow_o <= 0;
    end
    else begin
      fifo_underflow_o <= underflow_set ? 1 : 0;
    end
  end
endmodule
