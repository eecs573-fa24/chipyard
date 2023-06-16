package chipyard

import org.chipsalliance.cde.config.{Config}
import freechips.rocketchip.diplomacy._

// A simple config demonstrating how to set up a basic chip in Chipyard
class ChipLikeQuadRocketConfig extends Config(
  //==================================
  // Set up TestHarness
  //==================================
  new chipyard.harness.WithAbsoluteFreqHarnessClockInstantiator ++ // use absolute frequencies for simulations in the harness
                                                                   // NOTE: This only simulates properly in VCS

  //==================================
  // Set up tiles
  //==================================
  new freechips.rocketchip.subsystem.WithAsynchronousRocketTiles(3, 3) ++    // Add rational crossings between RocketTile and uncore
  new freechips.rocketchip.subsystem.WithNBigCores(4) ++                     // quad-core (4 RocketTiles)

  //==================================
  // Set up I/O
  //==================================
  new testchipip.WithSerialTLWidth(4) ++
  new testchipip.WithSerialTLBackingMemory ++                                           // Backing memory is over serial TL protocol
  new chipyard.harness.WithSimAXIMemOverSerialTL ++                                     // Attach fast SimDRAM to TestHarness
  new freechips.rocketchip.subsystem.WithExtMemSize((1 << 30) * 4L) ++                  // 4GB max external memory
  new freechips.rocketchip.subsystem.WithNMemoryChannels(1) ++                          // 1 memory channel

  //==================================
  // Set up clock./reset
  //==================================
  new chipyard.clocking.WithPLLSelectorDividerClockGenerator ++   // Use a PLL-based clock selector/divider generator structure

  // Create the uncore clock group
  new chipyard.clocking.WithClockGroupsCombinedByName(("uncore", Seq("implicit", "sbus", "mbus", "cbus", "system_bus", "fbus", "pbus"), Nil)) ++

  new chipyard.config.AbstractConfig
)

/**
  * Chip Config generated by the GUI
  */
class ExampleChipConfig extends Config(
  // ==================================
  //   Set up TestHarness
  // ==================================
  // The HarnessBinders control generation of hardware in the TestHarness
  new chipyard.harness.WithUARTAdapter ++                          // add UART adapter to display UART on stdout, if uart is present
  new chipyard.harness.WithBlackBoxSimMem ++                       // add SimDRAM DRAM model for axi4 backing memory, if axi4 mem is enabled
  new chipyard.harness.WithSimTSIOverSerialTL ++                   // add external serial-adapter and RAM
  new chipyard.harness.WithSimDebug ++                             // add SimJTAG or SimDTM adapters if debug module is enabled
  new chipyard.harness.WithGPIOTiedOff ++                          // tie-off chiptop GPIOs, if GPIOs are present
  new chipyard.harness.WithSimSPIFlashModel ++                     // add simulated SPI flash memory, if SPI is enabled
  new chipyard.harness.WithSimAXIMMIO ++                           // add SimAXIMem for axi4 mmio port, if enabled
  new chipyard.harness.WithTieOffInterrupts ++                     // tie-off interrupt ports, if present
  new chipyard.harness.WithTieOffL2FBusAXI ++                      // tie-off external AXI4 master, if present
  new chipyard.harness.WithCustomBootPinPlusArg ++                 // drive custom-boot pin with a plusarg, if custom-boot-pin is present
  new chipyard.harness.WithClockAndResetFromHarness ++             // all Clock/Reset I/O in ChipTop should be driven by harnessClockInstantiator
  new chipyard.harness.WithAbsoluteFreqHarnessClockInstantiator ++ // generate clocks in harness with unsynthesizable ClockSourceAtFreqMHz

  // ==================================
  //   Set up I/O harness
  // ==================================
  // The IOBinders instantiate ChipTop IOs to match desired digital IOs
  // IOCells are generated for "Chip-like" IOs, while simulation-only IOs are directly punched through
  new chipyard.iobinders.WithAXI4MemPunchthrough ++
  new chipyard.iobinders.WithAXI4MMIOPunchthrough ++
  new chipyard.iobinders.WithTLMemPunchthrough ++
  new chipyard.iobinders.WithL2FBusAXI4Punchthrough ++
  new chipyard.iobinders.WithBlockDeviceIOPunchthrough ++
  new chipyard.iobinders.WithNICIOPunchthrough ++
  new chipyard.iobinders.WithSerialTLIOCells ++
  new chipyard.iobinders.WithDebugIOCells ++
  new chipyard.iobinders.WithUARTIOCells ++
  new chipyard.iobinders.WithGPIOCells ++
  new chipyard.iobinders.WithSPIIOCells ++
  new chipyard.iobinders.WithTraceIOPunchthrough ++
  new chipyard.iobinders.WithExtInterruptIOCells ++
  new chipyard.iobinders.WithCustomBootPin ++

  // ==================================
  //   Set up Memory Devices
  // ==================================

  // External memory section
  new testchipip.WithNoSerialTL ++
  new freechips.rocketchip.subsystem.WithNoMemPort ++             // remove backing memory

  new testchipip.WithMbusScratchpad(base = 0x08000000, size = 128 * 1024) ++       // use rocket l1 DCache scratchpad as base phys mem

  // Peripheral section
  new chipyard.config.WithUART(address = 0x10021000, baudrate = 115200) ++
  new chipyard.config.WithUART(address = 0x10020000, baudrate = 115200) ++

  new chipyard.config.WithGPIO(address = 0x10011000, width = 24) ++
  new chipyard.config.WithGPIO(address = 0x10010000, width = 3) ++

  // Core section
  new chipyard.config.WithBootROM ++                                // use default bootrom
  new testchipip.WithCustomBootPin ++                               // add a custom-boot-pin to support pin-driven boot address
  new testchipip.WithBootAddrReg ++                                 // add a boot-addr-reg for configurable boot address                            // use default bootrom

  // ==================================
  //   Set up tiles
  // ==================================
  // Debug settings
  new chipyard.config.WithJTAGDTMKey(idcodeVersion = 2, partNum = 0x000, manufId = 0x489, debugIdleCycles = 5) ++
  new freechips.rocketchip.subsystem.WithNBreakpoints(2) ++
  new freechips.rocketchip.subsystem.WithNBreakpoints(2) ++
  new freechips.rocketchip.subsystem.WithJtagDTM ++                 // set the debug module to expose a JTAG port

  // Cache settings
  // new freechips.rocketchip.subsystem.WithL1ICacheSets(64) ++
  // new freechips.rocketchip.subsystem.WithL1ICacheWays(2) ++
  // new freechips.rocketchip.subsystem.WithL1DCacheSets(64) ++
  // new freechips.rocketchip.subsystem.WithL1DCacheWays(2) ++
  new chipyard.config.WithL2TLBs(0) ++
  // new freechips.rocketchip.subsystem.WithInclusiveCache ++          // use Sifive L2 cache

  // Memory settings
  new chipyard.config.WithNPMPs(0) ++
  new freechips.rocketchip.subsystem.WithNMemoryChannels(2) ++      // Default 2 memory channels
  new freechips.rocketchip.subsystem.WithNoMMIOPort ++              // no top-level MMIO master port (overrides default set in rocketchip)
  new freechips.rocketchip.subsystem.WithNoSlavePort ++             // no top-level MMIO slave port (overrides default set in rocketchip)
  new freechips.rocketchip.subsystem.WithCoherentBusTopology ++     // hierarchical buses including sbus/mbus/pbus/fbus/cbus/l2

  // Core settings
  new freechips.rocketchip.subsystem.WithNExtTopInterrupts(0) ++    // no external interrupts
  new freechips.rocketchip.subsystem.WithNSmallCores(1) ++

  // ==================================
  //   Set up reset and clocking
  // ==================================
  new freechips.rocketchip.subsystem.WithDontDriveBusClocksFromSBus ++ // leave the bus clocks undriven by sbus
  new freechips.rocketchip.subsystem.WithClockGateModel ++          // add default EICG_wrapper clock gate model
  new chipyard.config.WithNoSubsystemDrivenClocks ++                // drive the subsystem diplomatic clocks from ChipTop instead of using implicit clocks
  new chipyard.config.WithInheritBusFrequencyAssignments ++         // Unspecified clocks within a bus will receive the bus frequency if set
  new chipyard.config.WithPeripheryBusFrequency(100.0) ++           // Default 500 MHz pbus
  new chipyard.config.WithMemoryBusFrequency(100.0) ++              // Default 500 MHz mbus
  new chipyard.clocking.WithPassthroughClockGenerator ++
  new chipyard.clocking.WithClockGroupsCombinedByName(("uncore", Seq("sbus", "mbus", "pbus", "fbus", "cbus", "implicit"), Seq("tile"))) ++

  // ==================================
  //   Base Settings
  // ==================================
  new freechips.rocketchip.subsystem.WithDTS("ucb-bar, chipyard", Nil) ++ // custom device name for DTS
  new freechips.rocketchip.system.BaseConfig                        // "base" rocketchip system
)

