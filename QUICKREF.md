# Quick Reference

## Compilation & Simulation

### Compile
```bash
iverilog -o processor.vvp -f flist.txt tb/Pipeline_tb.v
```

### Simulate
```bash
vvp processor.vvp
```

### View Waveforms
```bash
gtkwave pipeline_top.vcd
```

## Key Signals

### Control Signals
- `RegWriteW` - Register write enable
- `MemWriteM` - Memory write enable
- `ALUSrcE` - ALU source select
- `PCSrcE` - PC source (for branches)

### Pipeline Registers
- `InstrD` - Instruction in Decode
- `PCE` - Program Counter in Execute
- `ALU_ResultM` - ALU result in Memory
- `ResultW` - Final writeback result

### Hazard Signals
- `ForwardAE`, `ForwardBE` - Forwarding control
- `StallF`, `StallD` - Stall signals
- `FlushD`, `FlushE` - Flush signals

## Common Commands

### Clean Build
```bash
rm -f *.vvp *.vcd
iverilog -o processor.vvp -f flist.txt tb/Pipeline_tb.v
vvp processor.vvp
```

### Quick Test
```bash
make clean && make run  # if Makefile exists
```

## Instruction Formats

### R-Type
`funct7[7] rs2[5] rs1[5] funct3[3] rd[5] opcode[7]`

### I-Type
`imm[12] rs1[5] funct3[3] rd[5] opcode[7]`

### S-Type
`imm[7] rs2[5] rs1[5] funct3[3] imm[5] opcode[7]`

### B-Type
`imm[7] rs2[5] rs1[5] funct3[3] imm[5] opcode[7]`

### J-Type
`imm[20] rd[5] opcode[7]`

## Memory File Format

```
v2.0 raw
00A00093
01400113
002081B3
```

First line must be `v2.0 raw`
Each line is one 32-bit instruction in hex
No `0x` prefixes

## GTKWave Tips

Add signals in groups:
1. Clock and Reset
2. Fetch Stage (PC, instruction)
3. Decode Stage (registers, control)
4. Execute Stage (ALU, branches)
5. Memory Stage (memory operations)
6. Writeback Stage (final results)
7. Hazard signals

## Debugging

### Check Register Values
```
pipeline_top.decode.register.reg_mem[1]
pipeline_top.decode.register.reg_mem[2]
...
```

### Check Memory
```
pipeline_top.memory.data_mem.mem[0]
pipeline_top.memory.data_mem.mem[1]
...
```

### Common Issues
- No output: Check memfile.hex exists
- Wrong results: Verify instruction encoding
- Compilation error: Check flist.txt paths
