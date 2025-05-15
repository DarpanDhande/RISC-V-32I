# RISC-V RV32I Single-Cycle CPU

## Overview

This repository contains a full Verilog implementation of a single-cycle CPU that supports the complete RV32I instruction set based on the RISC-V specification. It includes core components such as the program counter, instruction memory, register file, ALU, data memory, control units, and multiplexers. The CPU executes one instruction per clock cycle and is ideal for educational purposes and basic CPU architecture understanding.

## Supported Instructions

The CPU supports all RV32I base instructions, including:

* **Arithmetic & Logic:** ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU, ADDI, ANDI, ORI, XORI, SLTI, SLTIU
* **Branching:** BEQ, BNE, BLT, BGE, BLTU, BGEU
* **Memory Access:** LW, SW, LH, SH, LB, SB, LBU, LHU
* **Jumping:** JAL, JALR
* **Upper Immediate:** LUI, AUIPC
* **System:** ECALL, EBREAK, FENCE

## Top-Level Module

The main integration is done in the `Single_Cycle_Top` module which connects and orchestrates all the individual components.

```
module Single_Cycle_Top(clk , rst);
```

This module uses the following components:

### Program Counter and Control

* **P\_C.v**: Registers the current PC value.
* **PC\_adder.v**: Adds 4 to PC.
* **pc\_mux.v**: Chooses between PC+4 or branch target.
* **pc\_target\_adder.v**: Calculates target address for branch and JAL.
* **pc\_jalr\_adder.v**: Handles JALR computation.

### Instruction Fetch & Decode

* **Instr\_Mem.v**: Instruction memory.
* **main\_decoder.v**: Decodes opcode and generates control signals.
* **alu\_decoder.v**: Decodes ALU operation from function bits.

### Registers and Sign Extension

* **Reg\_file.v**: 32 general-purpose registers.
* **Sign\_Extend.v**: Extracts and sign-extends immediate values.

### ALU & Multiplexers

* **alu.v**: Core arithmetic and logic unit.
* **alumux.v**: Selects between register and immediate operand.
* **resultmux.v**: Chooses between ALU result and load data.

### Memory Access

* **Data\_Memory.v**: RAM used for data.
* **store\_case.v**: Handles byte/halfword/word storage based on funct3.
* **load\_case.v**: Extracts correct load format from memory output.

## Control Flow Signals

* `ALUOp`: 2-bit signal from main decoder to ALU decoder.
* `ImmSrc`: Controls which immediate format to use.
* `ALUSrc`: Selects register or immediate as ALU input.
* `ResultSrc`: Selects between ALU or memory result.
* `RegWrite`: Enables writing back to register file.
* `MemWrite`: Enables memory write.
* `PCSrc`: Determines branch/jump.
* `halt`: Stops PC increment (used for `EBREAK`).
* `overflow`, `zero`, `negative`, `carry`: Used for branch decisions.

## System Instructions

* **ECALL**: Resets PC to `0x00000000`, halting program for host interaction.
* **EBREAK**: Sets `halt` high to freeze PC value.
* **FENCE**: Detected but no action taken in single-cycle model (relevant in multi-stage CPUs).

## Example ALU Control Logic

ALUControl signals are 4-bit and map as follows:

* `0000`: ADD
* `0001`: SUB
* `0010`: AND
* `0011`: OR
* `0100`: XOR
* `0101`: SLT
* `0110`: SLL
* `0111`: SRA
* `1000`: SRL
* `1001`: SLTU

## Clocking

This is a single-cycle CPU. Each instruction is fetched, decoded, executed, and results written back in a single rising clock edge.

## How to Simulate

Use any Verilog simulator (ModelSim, Icarus Verilog, Vivado) to test this module. The instruction memory can be initialized using a `.mem` or `.hex` file. Test benches should check:

* Arithmetic correctness
* Load/store to memory
* Branch accuracy
* ECALL/EBREAK functionality

## Future Enhancements

* Add support for multi-cycle or pipelined architecture.
* Instruction cache, data cache.
* Exception handling and CSR register support.

## References

* RISC-V Instruction Set Manual: Volume I: Unprivileged ISA, v2.2
* [https://riscv.org/technical/specifications/](https://riscv.org/technical/specifications/)

License
This project is open source and free to use under the MIT License.

Author: Darpan Dnyandeo Dhnade
Date: 15-05-2025
