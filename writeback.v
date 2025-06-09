// %%writefile writeback.v

module writeback (input [31:0] aluout, readdata, input memtoreg, output [31:0] write_data);

    assign write_data = (memtoreg) ? readdata : aluout;

endmodule
