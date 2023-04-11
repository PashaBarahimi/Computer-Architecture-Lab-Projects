module InstructionMemory #(
    parameter Count = 1024
)(
    input [31:0] pc,
    output reg [31:0] inst
);
    wire [31:0] adr;
    assign adr = {pc[31:2], 2'b00}; // Align address to the word boundary

    always @(adr) begin
        case (adr)
            32'd0:   inst = 32'b1110_00_1_1101_0_0000_0000_000000010100; // MOV   R0,  #20            -> R0 = 20
            32'd4:   inst = 32'b1110_00_1_1101_0_0000_0001_101000000001; // MOV   R1,  #4096          -> R1 = 4096
            32'd8:   inst = 32'b1110_00_1_1101_0_0000_0010_000100000011; // MOV   R2,  #0xC00000000   -> R2 = -1073741824
            32'd12:  inst = 32'b1110_00_0_0100_1_0010_0011_000000000010; // ADDS  R3,  R2, R2         -> R3 = -2147483648
            32'd16:  inst = 32'b1110_00_0_0101_0_0000_0100_000000000000; // ADC   R4,  R0, R0         -> R4 = 41
            32'd20:  inst = 32'b1110_00_0_0010_0_0100_0101_000100000100; // SUB   R5,  R4, R4, LSL #2 -> R5= -123
            32'd24:  inst = 32'b1110_00_0_0110_0_0000_0110_000010100000; // SBC   R6,  R0, R0, LSR #1 -> R6 = 10
            32'd28:  inst = 32'b1110_00_0_1100_0_0101_0111_000101000010; // ORR   R7,  R5, R2         -> R7 = -123
            32'd32:  inst = 32'b1110_00_0_0000_0_0111_1000_000000000011; // AND   R8,  R7, R3         -> R8 = -2147483648
            32'd36:  inst = 32'b1110_00_0_1111_0_0000_1001_000000000110; // MVN   R9,  R6             -> R9 = -11
            32'd40:  inst = 32'b1110_00_0_0001_0_0100_1010_000000000101; // EOR   R10, R4, R5         -> R10 = -84
            32'd44:  inst = 32'b1110_00_0_1010_1_1000_0000_000000000110; // CMP   R8,  R6             -> z = 0
            32'd48:  inst = 32'b0001_00_0_0100_0_0001_0001_000000000001; // ADDNE R1,  R1, R1         -> R1 = 8192
            32'd52:  inst = 32'b1110_00_0_1000_1_1001_0000_000000001000; // TST   R9,  R8             -> z = 0
            32'd56:  inst = 32'b0000_00_0_0100_0_0010_0010_000000000010; // ADDEQ R2,  R2, R2         -> R2 = -1073741824
            32'd60:  inst = 32'b1110_00_1_1101_0_0000_0000_101100000001; // MOV   R0,  #1024          -> R0 = 1024
            32'd64:  inst = 32'b1110_01_0_0100_0_0000_0001_000000000000; // STR   R1,  [R0], #0       -> MEM[1024] = 8192
            32'd68:  inst = 32'b1110_01_0_0100_1_0000_1011_000000000000; // LDR   R11, [R0], #0       -> R11 = 8192
            32'd72:  inst = 32'b1110_01_0_0100_0_0000_0010_000000000100; // STR	  R2,  [R0], #4	      -> MEM[1028] = -1073741824
            32'd76:  inst = 32'b1110_01_0_0100_0_0000_0011_000000001000; // STR	  R3,  [R0], #8	      -> MEM[1032] = -2147483648
            32'd80:  inst = 32'b1110_01_0_0100_0_0000_0100_000000001101; // STR	  R4,  [R0], #13      -> MEM[1036] = 41
            32'd84:  inst = 32'b1110_01_0_0100_0_0000_0101_000000010000; // STR	  R5,  [R0], #16      -> MEM[1040] = -123
            32'd88:  inst = 32'b1110_01_0_0100_0_0000_0110_000000010100; // STR	  R6,  [R0], #20      -> MEM[1044] = 10
            32'd92:  inst = 32'b1110_01_0_0100_1_0000_1010_000000000100; // LDR	  R10, [R0], #4	      -> R10 = -1073741824
            32'd96:  inst = 32'b1110_01_0_0100_0_0000_0111_000000011000; // STR	  R7,  [R0], #24      -> MEM[1048] = -123
            32'd100: inst = 32'b1110_00_1_1101_0_0000_0001_000000000100; // MOV	  R1,  #4             -> R1 = 4
            32'd104: inst = 32'b1110_00_1_1101_0_0000_0010_000000000000; // MOV	  R2,  #0             -> R2 = 0
            32'd108: inst = 32'b1110_00_1_1101_0_0000_0011_000000000000; // MOV	  R3,  #0             -> R3 = 0
            32'd112: inst = 32'b1110_00_0_0100_0_0000_0100_000100000011; // ADD	  R4,  R0, R3, LSL #2 -> R4 = 1024
            32'd116: inst = 32'b1110_01_0_0100_1_0100_0101_000000000000; // LDR	  R5,  [R4], #0       ->
            32'd120: inst = 32'b1110_01_0_0100_1_0100_0110_000000000100; // LDR	  R6,  [R4], #4       ->
            32'd124: inst = 32'b1110_00_0_1010_1_0101_0000_000000000110; // CMP	  R5,  R6             ->
            32'd128: inst = 32'b1100_01_0_0100_0_0100_0110_000000000000; // STRGT R6,  [R4], #0       ->
            32'd132: inst = 32'b1100_01_0_0100_0_0100_0101_000000000100; // STRGT R5,  [R4], #4       ->
            32'd136: inst = 32'b1110_00_1_0100_0_0011_0011_000000000001; // ADD	  R3,  R3,   #1       ->
            32'd140: inst = 32'b1110_00_1_1010_1_0011_0000_000000000011; // CMP	  R3,  #3             ->
            32'd144: inst = 32'b1011_10_1_0_111111111111111111110111;    // BLT	  #-9                 ->
            32'd148: inst = 32'b1110_00_1_0100_0_0010_0010_000000000001; // ADD	  R2,  R2,   #1       ->
            32'd152: inst = 32'b1110_00_0_1010_1_0010_0000_000000000001; // CMP	  R2,  R1             ->
            32'd156: inst = 32'b1011_10_1_0_111111111111111111110011;    // BLT	  #-13                ->
            32'd160: inst = 32'b1110_01_0_0100_1_0000_0001_000000000000; // LDR	  R1,  [R0], #0	      -> R1 = -2147483648
            32'd164: inst = 32'b1110_01_0_0100_1_0000_0010_000000000100; // LDR	  R2,  [R0], #4	      -> R2 = -1073741824
            32'd168: inst = 32'b1110_01_0_0100_1_0000_0011_000000001000; // LDR	  R3,  [R0], #8	      -> R3 = 41
            32'd172: inst = 32'b1110_01_0_0100_1_0000_0100_000000001100; // LDR	  R4,  [R0], #12      -> R4 = 8192
            32'd176: inst = 32'b1110_01_0_0100_1_0000_0101_000000010000; // LDR	  R5,  [R0], #16      -> R5 = -123
            32'd180: inst = 32'b1110_01_0_0100_1_0000_0110_000000010100; // LDR	  R6,  [R0], #20      -> R4 = 10
            32'd184: inst = 32'b1110_10_1_0_111111111111111111111111;    // B	  #-1                 ->
        endcase
    end
endmodule
