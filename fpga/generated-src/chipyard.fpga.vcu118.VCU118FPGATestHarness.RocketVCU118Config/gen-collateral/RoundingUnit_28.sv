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

module RoundingUnit_28(
  input  [52:0] io_in,
  input         io_roundIn,
                io_stickyIn,
                io_signIn,
  input  [2:0]  io_rm,
  output [52:0] io_out,
  output        io_inexact,
                io_cout,
                io_r_up
);

  wire inexact = io_roundIn | io_stickyIn;	// @[RoundingUnit.scala:21:19]
  wire r_up = io_rm == 3'h5 ? ~(io_in[0]) & inexact : io_rm == 3'h4 ? io_roundIn : io_rm == 3'h2 ? inexact & io_signIn : io_rm == 3'h3 ? inexact & ~io_signIn : io_rm != 3'h1 & io_rm == 3'h0 & (io_roundIn & io_stickyIn | io_roundIn & ~io_stickyIn & io_in[0]);	// @[Mux.scala:81:{58,61}, RoundingUnit.scala:20:25, :21:19, :26:{18,24,33,36}, :28:{23,25}, :29:23, :31:{15,18}]
  assign io_out = r_up ? io_in + 53'h1 : io_in;	// @[Mux.scala:81:58, RoundingUnit.scala:34:24, :35:16]
  assign io_inexact = inexact;	// @[RoundingUnit.scala:21:19]
  assign io_cout = r_up & (&io_in);	// @[Mux.scala:81:58, RoundingUnit.scala:38:{19,32}]
  assign io_r_up = r_up;	// @[Mux.scala:81:58]
endmodule

