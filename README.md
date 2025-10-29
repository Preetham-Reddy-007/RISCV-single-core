# RISC-V Single Core Processor

A complete implementation of a 32-bit RISC-V processor featuring a 5-stage pipeline architecture with comprehensive hazard detection and resolution.

## Author
**Preetham Reddy**  
GitHub: [@Preetham-Reddy-007](https://github.com/Preetham-Reddy-007)

---

## Overview

This project implements a fully functional RV32I (RISC-V 32-bit Integer) processor with a classic 5-stage pipeline design. The processor supports all standard RV32I instructions and includes advanced features for handling pipeline hazards.

### Key Features

- ✅ **Complete RV32I ISA Implementation** - All I, R, S, B, and J-type instructions
- ✅ **5-Stage Pipeline** - Fetch → Decode → Execute → Memory → Write-back
- ✅ **Data Forwarding** - Minimizes stalls by bypassing data between pipeline stages
- ✅ **Hazard Detection** - Automatic detection and resolution of data and control hazards
- ✅ **Branch Handling** - Pipeline flushing for branch mispredictions
- ✅ **Fully Synthesizable** - Clean Verilog HDL suitable for FPGA implementation

---

## Architecture

### Pipeline Stages

1. **Instruction Fetch (IF)**
   - Retrieves instructions from instruction memory
   - Updates program counter

2. **Instruction Decode (ID)**
   - Decodes instruction fields
   - Reads register file
   - Generates control signals
   - Sign-extends immediate values

3. **Execute (EX)**
   - Performs ALU operations
   - Calculates branch targets
   - Evaluates branch conditions

4. **Memory (MEM)**
   - Accesses data memory for loads and stores
   - Passes through ALU results

5. **Write-Back (WB)**
   - Writes results back to register file
   - Selects appropriate data source

### Hazard Handling

#### Data Hazards
- **Forwarding**: Bypasses data from MEM and WB stages to EX stage
- **Stalling**: Inserts bubbles for load-use dependencies that cannot be resolved by forwarding

#### Control Hazards
- **Flush**: Clears incorrect instructions from pipeline on branch taken
- **Branch Resolution**: Branches resolved in Execute stage to minimize penalty

---

## Supported Instructions

### R-Type (Register-Register)
```
add, sub, and, or, xor, sll, srl, sra, slt, sltu
```

### I-Type (Immediate)
```
addi, andi, ori, xori, slli, srli, srai, slti, sltiu, lw
```

### S-Type (Store)
```
sw, sh, sb
```

### B-Type (Branch)
```
beq, bne, blt, bge, bltu, bgeu
```

### J-Type (Jump)
```
jal, jalr
```

---

## Project Structure

```
RISCV-single-core-v2/
├── src/
│   ├── pipeline_top.v          # Top-level module
│   ├── fetch_cycle.v           # IF stage
│   ├── decode_cycle.v          # ID stage
│   ├── execute_cycle.v         # EX stage
│   ├── memory_cycle.v          # MEM stage
│   ├── write_cycle.v           # WB stage
│   ├── alu.v                   # Arithmetic Logic Unit
│   ├── control_unit_top.v      # Control unit
│   ├── hazard_unit.v           # Forwarding logic
│   ├── stall_hazard.v          # Stall detection
│   ├── branch_hazard.v         # Branch handling
│   ├── register_file.v         # 32x32 register file
│   ├── data_memory.v           # Data memory
│   ├── instruction_memory.v    # Instruction ROM
│   └── memfile.hex             # Program memory
├── tb/
│   └── Pipeline_tb.v           # Testbench
├── flist.txt                   # Compilation file list
├── Updated_Architecture.JPG    # Architecture diagram
└── README.md                   # This file
```

---

## Getting Started

### Prerequisites

You'll need the following tools installed:

- **Icarus Verilog** - For compilation and simulation
- **GTKWave** - For waveform viewing
- **Venus RISC-V Simulator** - For generating machine code

#### Installation

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install iverilog gtkwave
```

**macOS:**
```bash
brew install icarus-verilog gtkwave
```

### Quick Start

1. **Clone or download this repository**

2. **Compile the design:**
```bash
iverilog -o processor.vvp -f flist.txt tb/Pipeline_tb.v
```

3. **Run simulation:**
```bash
vvp processor.vvp
```

4. **View waveforms:**
```bash
gtkwave pipeline_top.vcd
```

---

## Writing Programs

### Step 1: Write Assembly Code

Use the Venus RISC-V Simulator to write your assembly program:

```assembly
# Example: Simple addition
addi x1, x0, 10    # x1 = 10
addi x2, x0, 20    # x2 = 20
add  x3, x1, x2    # x3 = x1 + x2 = 30
sw   x3, 0(x0)     # Store result to memory
```

### Step 2: Generate Machine Code

1. Open your code in Venus Simulator
2. Click "Assemble"
3. Click "Dump" → "Machine Code"
4. Save the output

### Step 3: Prepare Hex File

1. Add `v2.0 raw` as the first line
2. Remove all `0x` prefixes
3. Save as `src/memfile.hex`

Example hex file:
```
v2.0 raw
00A00093
01400113
002081B3
0037A023
```

---

## Example Program

### Comprehensive Test Program

```assembly
# Initialize registers
addi x1, x0, 10       # x1 = 10
addi x2, x0, 5        # x2 = 5

# Arithmetic
add  x3, x1, x2       # x3 = 15
sub  x4, x1, x2       # x4 = 5

# Logical operations
and  x5, x1, x2       # x5 = x1 & x2
or   x6, x1, x2       # x6 = x1 | x2

# Shifts
sll  x7, x1, x2       # x7 = x1 << x2
srl  x8, x1, x2       # x8 = x1 >> x2 (logical)

# Memory operations
sw   x3, 0(x2)        # Store x3 to memory
lw   x9, 0(x2)        # Load from memory

# Branch (conditional)
beq  x1, x2, skip     # Branch if equal (won't take)
addi x10, x0, 1       # x10 = 1

skip:
addi x11, x0, 100     # x11 = 100
```

---

## Simulation and Testing

### Running Tests

The included testbench will:
- Reset the processor
- Run for approximately 3500ns
- Generate waveform output in `pipeline_top.vcd`

### Viewing Results

Important signals to monitor in GTKWave:
- `clk`, `rst` - Clock and reset
- `InstrD` - Current instruction in Decode stage
- `PCE` - Program counter in Execute stage
- `ALU_ResultM` - ALU result in Memory stage
- `ResultW` - Final result being written back
- `RegWriteW` - Register write enable

### Checking Register Values

To see register file contents:
```
pipeline_top.decode.register.reg_mem[1]
pipeline_top.decode.register.reg_mem[2]
...
```

---

## Performance

### Pipeline Efficiency
- **Ideal CPI**: 1.0 (one instruction per cycle)
- **Typical CPI**: ~1.2 (with hazards)
- **Pipeline Stages**: 5
- **Latency**: 5 cycles for first instruction

### Hazard Impact
- **Data forwarding**: Resolves most RAW hazards without stalling
- **Load-use**: Requires 1 cycle stall
- **Branches**: 2-3 cycle penalty on taken branches

---

## Design Decisions

### Why 5-Stage Pipeline?
The classic 5-stage pipeline offers:
- Good balance between complexity and performance
- Well-understood hazard handling techniques
- Suitable for educational purposes and FPGA implementation
- Industry-standard architecture

### Hazard Mitigation Strategy
1. **Forwarding first** - Bypass data whenever possible
2. **Stall when necessary** - Only for unavoidable dependencies
3. **Early branch resolution** - Resolve in EX stage to minimize penalty

---

## Technical Specifications

| Feature | Specification |
|---------|--------------|
| ISA | RV32I Base Integer |
| Pipeline Stages | 5 |
| Register File | 32 × 32-bit registers |
| Data Memory | Configurable size |
| Instruction Memory | ROM-based |
| Addressing Mode | Byte-addressable |
| Endianness | Little-endian |

---

## Known Limitations

- No cache implementation (direct memory access)
- Single-issue pipeline (one instruction at a time)
- Static branch prediction (assume not-taken)
- RV32I base only (no M, A, F, D extensions)
- No interrupts or exceptions

---

## Future Enhancements

Potential improvements for this design:

- [ ] Dynamic branch prediction
- [ ] Instruction and data caches
- [ ] Support for M extension (multiply/divide)
- [ ] Exception and interrupt handling
- [ ] Performance counters
- [ ] Pipeline visualization tools

---

## Debugging Tips

### Common Issues

**Problem**: Simulation doesn't produce output
- **Solution**: Check that `memfile.hex` exists and has correct format

**Problem**: Compilation errors
- **Solution**: Verify all files listed in `flist.txt` are present

**Problem**: Incorrect results
- **Solution**: Check instruction encoding and memory initialization

### GTKWave Tips

1. Add signals in logical groups (by pipeline stage)
2. Use markers to track instruction flow
3. Check hazard signals to understand stalls/flushes
4. Compare expected vs actual register values

---

## References

### Technical Resources
- [RISC-V ISA Specification](https://riscv.org/technical/specifications/)
- *Digital Design and Computer Architecture: RISC-V Edition* by Harris & Harris
- [Venus RISC-V Simulator](https://venus.cs61c.org/)

### Tools
- [Icarus Verilog Documentation](http://iverilog.icarus.com/)
- [GTKWave Manual](http://gtkwave.sourceforge.net/)

---

## License

This project is available under the MIT License. See LICENSE file for details.

---

## Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests
- Improve documentation

---

## Acknowledgments

This processor design follows classical RISC pipeline principles as described in computer architecture textbooks and is implemented for educational purposes.

---

## Contact

**Preetham Reddy**  
GitHub: [@Preetham-Reddy-007](https://github.com/Preetham-Reddy-007)

For questions, issues, or contributions, please open an issue on GitHub.

---

*Built with passion for computer architecture and digital design* 🚀
