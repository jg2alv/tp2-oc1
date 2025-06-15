module decode (input [31:0] inst, writedata, input clk, output [31:0] data1, data2, ImmGen, output alusrc, memread, memwrite, memtoreg, branch,
               output [1:0] aluop, output [9:0] funct);

  wire branch, memread, memtoreg, MemWrite, alusrc, regwrite;
  wire [1:0] aluop;
  wire [4:0] writereg, rs1, rs2, rd;
  wire [6:0] opcode;
  wire [9:0] funct;
  wire [6:0] funct7;
  wire [2:0] funct3;
  wire [31:0] ImmGen;


  assign opcode = inst[6:0];
  assign rs1    = inst[19:15];
  assign rs2    = inst[24:20];
  assign rd     = inst[11:7];
  assign funct7 = inst[31:25];
  assign funct3 = inst[14:12];
  assign funct = {funct7,funct3};

  ControlUnit control (opcode, inst, alusrc, memtoreg, regwrite, memread, memwrite, branch, aluop, ImmGen);

  Register_Bank Registers (clk, regwrite, rs1, rs2, rd, writedata, data1, data2);

endmodule

module ControlUnit (input [6:0] opcode, input [31:0] inst, output reg alusrc, memtoreg, regwrite, memread, memwrite, branch, output reg [1:0] aluop, output reg [31:0] ImmGen);

  always @(*) begin
    alusrc   <= 0;
    memtoreg <= 0;
    regwrite <= 0;
    memread  <= 0;
    memwrite <= 0;
    branch   <= 0;
    aluop    <= 0;
    ImmGen   <= 0;
    case(opcode)
    	7'b0110011: begin // R type == 51 = 0x33
    	    regwrite <= 1;
    	    aluop    <= 2;
		end
		7'b0010011: begin // addi == 19 ou 0x13, slti, xori, .....
	        alusrc   <= 1;
	        regwrite <= 1;
          aluop    <= 3;
	        ImmGen   <= {{20{inst[31]}},inst[31:20]};
		end
		7'b0000011: begin // lw == 3
        	alusrc   <= 1;
        	memtoreg <= 1;
        	regwrite <= 1;
        	memread  <= 1;
        	ImmGen   <= {{20{inst[31]}},inst[31:20]};
      	end
		7'b0100011: begin // sw == 35
        	alusrc   <= 1;
        	memwrite <= 1;
        	ImmGen   <= {{20{inst[31]}},inst[31:25],inst[11:7]};
      	end
    endcase
  end

endmodule

module Register_Bank (input clk, regwrite, input [4:0] read_reg1, read_reg2, writereg, input [31:0] writedata, output [31:0] read_data1, read_data2);

  integer i;
  reg [31:0] reg_bank [0:31]; // 32 registers de 32 bits cada

  // fill the memory
  initial begin
    for (i = 0; i <= 31; i++)
      reg_bank[i] <= i;
  end

  assign read_data1 = reg_bank[read_reg1];
  assign read_data2 = reg_bank[read_reg2];

  always @(posedge clk) begin
    if (regwrite)
      reg_bank[writereg] <= writedata;
  end

endmodule
