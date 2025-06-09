// %%writefile fetch.v

module fetch (input zero, rst, clk, branch, input [31:0] sigext, output [31:0] inst);

  wire [31:0] pc, pc_4, new_pc;

  assign pc_4 = 4 + pc; // pc+4  Adder
  assign new_pc = (branch & zero) ? pc + sigext : pc_4; // new PC Mux

  PC program_counter(new_pc, clk, rst, pc);

  reg [31:0] inst_mem [0:31];

  assign inst = inst_mem[pc[31:2]];

  initial begin
    // Exemplos

`include "mycode.v"
  end

endmodule

module PC (input [31:0] pc_in, input clk, rst, output reg [31:0] pc_out);

  always @(posedge clk) begin
    pc_out <= pc_in;
    if (~rst)
      pc_out <= 0;
  end

endmodule
