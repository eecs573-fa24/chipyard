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

module CLZ_17(
  input  [48:0] io_in,
  output [5:0]  io_out
);

  assign io_out = io_in[48] ? 6'h0 : io_in[47] ? 6'h1 : io_in[46] ? 6'h2 : io_in[45] ? 6'h3 : io_in[44] ? 6'h4 : io_in[43] ? 6'h5 : io_in[42] ? 6'h6 : io_in[41] ? 6'h7 : io_in[40] ? 6'h8 : io_in[39] ? 6'h9 : io_in[38] ? 6'hA : io_in[37] ? 6'hB : io_in[36] ? 6'hC : io_in[35] ? 6'hD : io_in[34] ? 6'hE : io_in[33] ? 6'hF : io_in[32] ? 6'h10 : io_in[31] ? 6'h11 : io_in[30] ? 6'h12 : io_in[29] ? 6'h13 : io_in[28] ? 6'h14 : io_in[27] ? 6'h15 : io_in[26] ? 6'h16 : io_in[25] ? 6'h17 : io_in[24] ? 6'h18 : io_in[23] ? 6'h19 : io_in[22] ? 6'h1A : io_in[21] ? 6'h1B : io_in[20] ? 6'h1C : io_in[19] ? 6'h1D : io_in[18] ? 6'h1E : io_in[17] ? 6'h1F : io_in[16] ? 6'h20 : io_in[15] ? 6'h21 : io_in[14] ? 6'h22 : io_in[13] ? 6'h23 : io_in[12] ? 6'h24 : io_in[11] ? 6'h25 : io_in[10] ? 6'h26 : io_in[9] ? 6'h27 : io_in[8] ? 6'h28 : io_in[7] ? 6'h29 : io_in[6] ? 6'h2A : io_in[5] ? 6'h2B : io_in[4] ? 6'h2C : io_in[3] ? 6'h2D : io_in[2] ? 6'h2E : io_in[1] ? 6'h2F : 6'h30;	// @[CLZ.scala:18:42, Mux.scala:47:70]
endmodule

