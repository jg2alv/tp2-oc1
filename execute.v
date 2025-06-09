// %%writefile execute.v
module execute (
  input [31:0] in1, in2, ImmGen,
  input alusrc,
  input [1:0] aluop,
  input [9:0] funct,
  output zero,
  output [31:0] aluout
);
  wire [31:0] srcb;
  assign srcb = alusrc ? ImmGen : in2;

  reg [31:0] res;
  assign aluout = res;
  assign zero = (res == 0);

  always @(*) begin
    case (aluop)
      2'b00: res = in1 + srcb; // load/store
      2'b10: begin             // tipo R
        case (funct)
          10'b0000000000: res = in1 + srcb; // add
          default: res = 0;
        endcase
      end
      default: res = 0;
    endcase
  end
endmodule

