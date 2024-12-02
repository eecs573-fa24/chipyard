#!/bin/bash

set -e


############################################
# Copy Chisel CAM Module
# cp cam-dependents/CAMRoCC.scala ../generators/rocket-chip/src/main/scala/tile/CAMRoCC.scala
############################################


############################################
# Clearing out the build directory
cd ../sims/verilator
rm -f simulator-chipyard.harness-CamRoCCConfig
cd generated-src
rm -rf chipyard.harness.TestHarness.CamRoCCConfig
############################################


############################################
# Generate Verilog
cd ..
make -j$(nproc) CONFIG=CamRoCCConfig verilog
############################################


############################################
# Inserting CAM Module
cd ../../scripts/cam-dependents
cp RocketTile.sv ../../sims/verilator/generated-src/chipyard.harness.TestHarness.CamRoCCConfig/gen-collateral/RocketTile.sv
# read -p "Check if SV file was changed!!! Press enter to continue"
############################################


############################################
# Compiling Test
cd ../../tests
cmake -S ./ -B ./build/ -D CMAKE_BUILD_TYPE=Debug
cmake --build ./build/ --target lzw
cmake --build ./build/ --target lzw-rocc
############################################


############################################
# Run lzw-rocc
cd ../sims/verilator
make -j$(nproc) CONFIG=CamRoCCConfig run-binary BINARY=../../tests/lzw-rocc.riscv
############################################