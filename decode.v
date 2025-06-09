//%%writefile decode.v
module decode (
  input [31:0] inst, writedata,
  input clk,
  output [31:0] data1, data2, ImmGen,
  output alusrc, memread, memwrite, memtoreg, regwrite, branch,
  output [1:0] aluop,
  output [9:0] funct
);
  reg [31:0] regfile [0:31];
  wire [4:0] rs1 = inst[19:15];
  wire [4:0] rs2 = inst[24:20];
  wire [4:0] rd  = inst[11:7];
  wire [6:0] opcode = inst[6:0];
  wire [2:0] funct3 = inst[14:12];
  wire [6:0] funct7 = inst[31:25];

  assign data1 = regfile[rs1];
  assign data2 = regfile[rs2];
  assign funct = {funct7, funct3};
  assign ImmGen = {{20{inst[31]}}, inst[31:20]};

  assign alusrc   = 0;
  assign memread  = 0;
  assign memwrite = 0;
  assign memtoreg = 0;
  assign regwrite = (opcode == 7'b0110011); // apenas tipo R
  assign branch   = 0;
  assign aluop    = 2'b10;

  always @(posedge clk) begin
    if (regwrite)
      regfile[rd] <= writedata;
  end
endmodule

