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

module ResetWrangler(
  input  auto_in_1_clock,
         auto_in_1_reset,
         auto_in_0_clock,
         auto_in_0_reset,
  output auto_out_1_reset,
         auto_out_0_clock,
         auto_out_0_reset
);

  wire        _deglitched_deglitch_io_q;	// @[AsyncResetReg.scala:73:21]
  wire [13:0] _debounced_debounce_io_q;	// @[AsyncResetReg.scala:88:21]
  wire        causes = auto_in_0_reset | auto_in_1_reset;	// @[ResetWrangler.scala:20:54]
  wire        increment = _debounced_debounce_io_q != 14'h2710;	// @[AsyncResetReg.scala:88:21, ResetWrangler.scala:32:28]
  AsyncResetRegVec_w14_i0 debounced_debounce (	// @[AsyncResetReg.scala:88:21]
    .clock (auto_in_0_clock),
    .reset (causes),	// @[ResetWrangler.scala:20:54]
    .io_d  (_debounced_debounce_io_q + 14'h1),	// @[AsyncResetReg.scala:88:21, ResetWrangler.scala:33:30]
    .io_en (increment),	// @[ResetWrangler.scala:32:28]
    .io_q  (_debounced_debounce_io_q)
  );
  AsyncResetReg deglitched_deglitch (	// @[AsyncResetReg.scala:73:21]
    .io_d   (increment),	// @[ResetWrangler.scala:32:28]
    .io_clk (auto_in_0_clock),
    .io_rst (causes),	// @[ResetWrangler.scala:20:54]
    .io_q   (_deglitched_deglitch_io_q)
  );
  ResetCatchAndSync_d3_VCU118FPGATestHarness_UNIQUIFIED x1_reset_catcher (	// @[ResetCatchAndSync.scala:39:28]
    .clock         (auto_in_0_clock),
    .reset         (_deglitched_deglitch_io_q),	// @[AsyncResetReg.scala:73:21]
    .io_sync_reset (auto_out_0_reset)
  );
  ResetCatchAndSync_d3_VCU118FPGATestHarness_UNIQUIFIED bundleOut_1_reset_catcher (	// @[ResetCatchAndSync.scala:39:28]
    .clock         (auto_in_1_clock),
    .reset         (_deglitched_deglitch_io_q),	// @[AsyncResetReg.scala:73:21]
    .io_sync_reset (auto_out_1_reset)
  );
  assign auto_out_0_clock = auto_in_0_clock;
endmodule

