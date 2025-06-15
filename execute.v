module execute (input [31:0] in1, in2, ImmGen, input alusrc, input [1:0] aluop, input [9:0] funct, output zero, output [31:0] aluout);

  wire [31:0] alu_B;
  wire [3:0] aluctrl;

  assign alu_B = (alusrc) ? ImmGen : in2 ;
  wire zero1;
  wire [2:0] f3;
  assign f3 = funct[2:0];
  assign zero = (f3 == 3'b000) ? zero1 :
                (f3 == 3'b001) ? ~zero1 :
                (f3 == 3'b100) ? aluout[31]:
                (f3 == 3'b101) ? ~aluout[31] :
                (f3 == 3'b110) ? in1[31:0] < alu_B[31:0] :
                (f3 == 3'b111) ? ~(in1[31:0] < alu_B[31:0]) : 0;


  //Unidade Lógico Aritimética
  ALU alu (aluctrl, in1, alu_B, aluout, zero1);

  alucontrol alucontrol (aluop, funct, aluctrl);

endmodule

module alucontrol (input [1:0] aluop, input [9:0] funct, output reg [3:0] alucontrol);

  wire [7:0] funct7;
  wire [2:0] funct3;
  wire [3:0] ALUopcode;

  assign funct3 = funct[2:0];
  assign funct7 = funct[9:3];
  assign ALUopcode = {funct7[5],funct3};

  always @(*)
  begin
    case (aluop)
      0: alucontrol <= 4'd2; // ADD to SW and LW
      1: alucontrol <= 4'd6; // SUB to branch
      2: case (funct3)
          //MUL, ADD, SUB, SLL, SLT, SLTU, XOR, SRA, OR, AND  
           0: alucontrol <= (funct7 == 1) ? /*MUL*/ 4'd10 : ((funct7 == 0) ? /* ADD */ 4'd2 : /*SUB*/ 4'd6);
           1: alucontrol <= 4'd3; // SLL
           2: alucontrol <= 4'd7; // SLT
           3: alucontrol <= 4'd9; //SLTU
           4: alucontrol <= 4'd4; // XOR
           5: alucontrol <= (funct7[5])? 4'd5:4'd8; // SRA ou SRL
           6: alucontrol <=  (funct7 == 1) ? 4'd11 /* MOD */ : 4'd1; /* OR */
           7: alucontrol <= 4'd0; // AND
           default: alucontrol <= 4'd15; // Nop
         endcase
      3: case (funct3) // immediate
           0: alucontrol <= 4'd2; //ADDI
           1: alucontrol <= 4'd3; // SLLI
           2: alucontrol <= 4'd7; // SLTI
           3: alucontrol <= 4'd9; //SLTUI
           4: alucontrol <= 4'd15; // NOP
           5: alucontrol <= (funct7[5])? 4'd5:4'd8; // SRAI or SRLI
           6: alucontrol <= 4'd1; // ORI
           7: alucontrol <= 4'd0; // ANDI
           default: alucontrol <= 4'd15; // Nop
         endcase
    endcase
  end
endmodule

module ALU (input [3:0] alucontrol, input [31:0] A, B, output reg [31:0] aluout, output zero);

  assign zero = (aluout == 0); // Zero recebe um valor lógico caso aluout seja igual a zero.

  wire [31:0] t,sh,p;
  slt subt(A,B,t);
  shiftRA shift(A,B[4:0],sh);


  always @(*) begin
      case (alucontrol)
        0: aluout <= A & B; // AND
        1: aluout <= A | B; // OR
        2: aluout <= A + B; // ADD
        3: aluout <= A << B[4:0]; // SSL A << B Shift left logico
        4: aluout <= A ^ B; // XOR
        5: aluout <= sh;
        6: aluout <= A - B; // SUB
        7: aluout <= t; //A < B ? 32'd1:32'd0; //SLT
        8: aluout <= A >> B[4:0];
        9: aluout <= A < B ? 32'd1:32'd0; //SLTU
       10: aluout <= A * B; // MUL
       11: aluout <= A % B; // MOD  
      default: aluout <= 0; //default 0, Nada acontece;
    endcase
  end
endmodule

module slt(input [31:0]a,b, output [31:0] s);
wire [31:0] sub;
assign sub = a - b;
assign s = (sub[31])?1:0;
endmodule


module shiftRA (input [31:0]a,input [4:0]b, output [31:0] o );
wire [31:0] s;
wire [31:0] t;
wire [31:0] m;

assign m = {32{1'b1}};
assign s = m >> b;
assign t = a >> b;
assign o = (a[31])?(~s|t):t;
endmodule
