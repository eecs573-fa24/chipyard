// Generated by CIRCT unknown git version
// Standard header to adapt well known macros to our needs.
`ifndef RANDOMIZE
  `ifdef RANDOMIZE_REG_INIT
    `define RANDOMIZE
  `endif // RANDOMIZE_REG_INIT
`endif // not def RANDOMIZE
`ifndef RANDOMIZE
  `ifdef RANDOMIZE_MEM_INIT
    `define RANDOMIZE
  `endif // RANDOMIZE_MEM_INIT
`endif // not def RANDOMIZE

// RANDOM may be set to an expression that produces a 32-bit random unsigned value.
`ifndef RANDOM
  `define RANDOM $random
`endif // not def RANDOM

// Users can define 'PRINTF_COND' to add an extra gate to prints.
`ifndef PRINTF_COND_
  `ifdef PRINTF_COND
    `define PRINTF_COND_ (`PRINTF_COND)
  `else  // PRINTF_COND
    `define PRINTF_COND_ 1
  `endif // PRINTF_COND
`endif // not def PRINTF_COND_

// Users can define 'ASSERT_VERBOSE_COND' to add an extra gate to assert error printing.
`ifndef ASSERT_VERBOSE_COND_
  `ifdef ASSERT_VERBOSE_COND
    `define ASSERT_VERBOSE_COND_ (`ASSERT_VERBOSE_COND)
  `else  // ASSERT_VERBOSE_COND
    `define ASSERT_VERBOSE_COND_ 1
  `endif // ASSERT_VERBOSE_COND
`endif // not def ASSERT_VERBOSE_COND_

// Users can define 'STOP_COND' to add an extra gate to stop conditions.
`ifndef STOP_COND_
  `ifdef STOP_COND
    `define STOP_COND_ (`STOP_COND)
  `else  // STOP_COND
    `define STOP_COND_ 1
  `endif // STOP_COND
`endif // not def STOP_COND_

// Users can define INIT_RANDOM as general code that gets injected into the
// initializer block for modules with registers.
`ifndef INIT_RANDOM
  `define INIT_RANDOM
`endif // not def INIT_RANDOM

// If using random initialization, you can also define RANDOMIZE_DELAY to
// customize the delay used, otherwise 0.002 is used.
`ifndef RANDOMIZE_DELAY
  `define RANDOMIZE_DELAY 0.002
`endif // not def RANDOMIZE_DELAY

// Define INIT_RANDOM_PROLOG_ for use in our modules below.
`ifndef INIT_RANDOM_PROLOG_
  `ifdef RANDOMIZE
    `ifdef VERILATOR
      `define INIT_RANDOM_PROLOG_ `INIT_RANDOM
    `else  // VERILATOR
      `define INIT_RANDOM_PROLOG_ `INIT_RANDOM #`RANDOMIZE_DELAY begin end
    `endif // VERILATOR
  `else  // RANDOMIZE
    `define INIT_RANDOM_PROLOG_
  `endif // RANDOMIZE
`endif // not def INIT_RANDOM_PROLOG_

module FPUFMAPipe(
  input         clock,
                reset,
                io_in_valid,
                io_in_bits_ren3,
                io_in_bits_swap23,
  input  [2:0]  io_in_bits_rm,
  input  [1:0]  io_in_bits_fmaCmd,
  input  [64:0] io_in_bits_in1,
                io_in_bits_in2,
                io_in_bits_in3,
  output [64:0] io_out_bits_data,
  output [4:0]  io_out_bits_exc
);

  wire [32:0] _fma_io_out;	// @[FPU.scala:723:19]
  reg         valid;	// @[FPU.scala:711:22]
  reg  [2:0]  in_rm;	// @[FPU.scala:712:15]
  reg  [1:0]  in_fmaCmd;	// @[FPU.scala:712:15]
  reg  [64:0] in_in1;	// @[FPU.scala:712:15]
  reg  [64:0] in_in2;	// @[FPU.scala:712:15]
  reg  [64:0] in_in3;	// @[FPU.scala:712:15]
  always @(posedge clock) begin
    valid <= io_in_valid;	// @[FPU.scala:711:22]
    if (io_in_valid) begin
      in_rm <= io_in_bits_rm;	// @[FPU.scala:712:15]
      in_fmaCmd <= io_in_bits_fmaCmd;	// @[FPU.scala:712:15]
      in_in1 <= io_in_bits_in1;	// @[FPU.scala:712:15]
      if (io_in_bits_swap23)
        in_in2 <= 65'h80000000;	// @[FPU.scala:712:15, :719:32]
      else
        in_in2 <= io_in_bits_in2;	// @[FPU.scala:712:15]
      if (io_in_bits_ren3 | io_in_bits_swap23)	// @[FPU.scala:720:21]
        in_in3 <= io_in_bits_in3;	// @[FPU.scala:712:15]
      else	// @[FPU.scala:720:21]
        in_in3 <= (io_in_bits_in1 ^ io_in_bits_in2) & 65'h100000000;	// @[FPU.scala:712:15, :715:{32,50}]
    end
  end // always @(posedge)
  `ifndef SYNTHESIS
    `ifdef FIRRTL_BEFORE_INITIAL
      `FIRRTL_BEFORE_INITIAL
    `endif // FIRRTL_BEFORE_INITIAL
    logic [31:0] _RANDOM_0;
    logic [31:0] _RANDOM_1;
    logic [31:0] _RANDOM_2;
    logic [31:0] _RANDOM_3;
    logic [31:0] _RANDOM_4;
    logic [31:0] _RANDOM_5;
    logic [31:0] _RANDOM_6;
    initial begin
      `ifdef INIT_RANDOM_PROLOG_
        `INIT_RANDOM_PROLOG_
      `endif // INIT_RANDOM_PROLOG_
      `ifdef RANDOMIZE_REG_INIT
        _RANDOM_0 = `RANDOM;
        _RANDOM_1 = `RANDOM;
        _RANDOM_2 = `RANDOM;
        _RANDOM_3 = `RANDOM;
        _RANDOM_4 = `RANDOM;
        _RANDOM_5 = `RANDOM;
        _RANDOM_6 = `RANDOM;
        valid = _RANDOM_0[0];	// @[FPU.scala:711:22]
        in_rm = _RANDOM_0[21:19];	// @[FPU.scala:711:22, :712:15]
        in_fmaCmd = _RANDOM_0[23:22];	// @[FPU.scala:711:22, :712:15]
        in_in1 = {_RANDOM_0[31:28], _RANDOM_1, _RANDOM_2[28:0]};	// @[FPU.scala:711:22, :712:15]
        in_in2 = {_RANDOM_2[31:29], _RANDOM_3, _RANDOM_4[29:0]};	// @[FPU.scala:712:15]
        in_in3 = {_RANDOM_4[31:30], _RANDOM_5, _RANDOM_6[30:0]};	// @[FPU.scala:712:15]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL
      `FIRRTL_AFTER_INITIAL
    `endif // FIRRTL_AFTER_INITIAL
  `endif // not def SYNTHESIS
  MulAddRecFNPipe fma (	// @[FPU.scala:723:19]
    .clock             (clock),
    .reset             (reset),
    .io_validin        (valid),	// @[FPU.scala:711:22]
    .io_op             (in_fmaCmd),	// @[FPU.scala:712:15]
    .io_a              (in_in1[32:0]),	// @[FPU.scala:712:15, :728:12]
    .io_b              (in_in2[32:0]),	// @[FPU.scala:712:15, :729:12]
    .io_c              (in_in3[32:0]),	// @[FPU.scala:712:15, :730:12]
    .io_roundingMode   (in_rm),	// @[FPU.scala:712:15]
    .io_out            (_fma_io_out),
    .io_exceptionFlags (io_out_bits_exc)
  );
  assign io_out_bits_data = {32'h0, _fma_io_out};	// @[FPU.scala:723:19, :733:12]
endmodule

