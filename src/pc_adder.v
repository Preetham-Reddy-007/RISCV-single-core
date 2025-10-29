//================================================================================
// Module: pc_adder
// Author: Preetham Reddy (@Preetham-Reddy-007)
// Description: PC incrementer - adds 4 to program counter
//================================================================================

module pc_adder(a,b,c);
    input [31:0] a,b;
    output  [31:0] c;

    assign c = a + b;
    
endmodule