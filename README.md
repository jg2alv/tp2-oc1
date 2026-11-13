# Chip Happens: ADD decoding and execution in an educational RISC-V datapath

Chip Happens follows an instruction from its encoded fields to an arithmetic result. Within a team extension of supplied Verilog modules, I implemented the ADD path across instruction decoding and execution, connecting control signals to the operation they select.

## 1. Academic context and scope

- **Institution:** Universidade Federal de Minas Gerais (UFMG)
- **Degree:** Ciência da Computação
- **Course:** Organização de Computadores 1
- **Assignment:** Trabalho Prático 2
- **Semester:** 2025-01
- **Collaboration:** Team

The repository separates an educational 32-bit RISC-V datapath into instruction fetching, decoding, execution, data memory, and writeback. My assigned instruction was register-based ADD. Other operations appear in the shared modules, but their presence does not make them part of my individual contribution or establish complete instruction-set support.

The assignment uses a course-provided Google Colab notebook to integrate the Verilog modules, load machine code, and visualize processor state. This archive preserves the component files rather than that notebook environment.

## 2. Implementation decisions

`decode.v` extracts the opcode, source and destination register indices, and function fields. Its control unit recognizes the register-register opcode, enables register writeback, and selects the ALU control class used for those instructions. The register bank supplies the operands through the decode interface.

In `execute.v`, the operand multiplexer chooses between the second register operand and the generated immediate. ADD uses the register operand. The ALU control logic combines the instruction's function information with `aluop` to select addition, and the ALU maps that selection to `A + B`.

This division keeps instruction interpretation separate from the arithmetic expression. The important integration problem was making the decoding decision agree with operand selection and ALU control across module boundaries. An addition expression alone would not describe the instruction's full path through the design.

## 3. Tests and evaluation

The assignment's testing workflow uses Venus to assemble instruction-level tests, then loads the resulting hexadecimal machine code into the course notebook for visual inspection. For ADD, the relevant behavior is reading two register operands, generating their sum, and writing it to the destination register.

The archive contains no assembly test program or notebook output accompanying that workflow.

## 4. Learning and limitations

Following the same instruction across the decode and execute interfaces strengthened my understanding of hardware description languages, instruction encoding, and the relationship between control and datapath behavior. The exercise made a small arithmetic instruction concrete as a coordinated sequence of field extraction, operand routing, control selection, and result generation.

The archived repository does not include the integration notebook, a separate top-level module, a simulation testbench, or a build script. In addition, `fetch.v` includes `mycode.v` to populate instruction memory, but that file is absent. Restoring the missing integration and instruction-loading artifacts is necessary to reproduce end-to-end execution.

## 5. Authorship and contribution

Developed as a team project, extending Verilog modules supplied for the course.

**My contribution:** I implemented ADD by modifying `decode.v` and `execute.v`, connecting register-based decoding, operand selection, ALU control, and the addition result.
