package RPSCore

import chisel3._ 
import chisel3.experimental.ChiselEnum

object Constants {
    // val OPCODE_SYSTEM = 0x73;
    // val OPCODE_FENCE = 0x0f;
    val OPCODE_OP = 0x33; //RType
    val OPCODE_OPIMM = 0x13;
    val OPCODE_STORE = 0x23;
    val OPCODE_LOAD = 0x03;
    val OPCODE_BRANCH = 0x63;
    val OPCODE_JALR = 0x67;
    val OPCODE_JAL = 0x6f;
    val OPCODE_AUIPC = 0x17;
    val OPCODE_LUI = 0x37;

    val OPCODE_SYSTEM = 0x73///CSR

    val OPCODE_CUSTOM0 = 0x0b;

    val TABLE_SIZE = 0x10;
}


object pc_src_t extends ChiselEnum {
  val pc4, alu, pc_wb = Value
}

object rv_instr_t extends ChiselEnum {
  val nop,
      /* RV32I Base Instruction Set Except FENCE and SYSTEM */
      lui, auipc,
      jal, jalr,
      beq, bne, blt, bge, bltu, bgeu, 
      lb, lh, lw, lbu, lhu, 
      sb, sh, sw, 
      addi, slti, sltiu, xori, ori, andi, slli, srli, srai, 
      add, sub, sll, slt, sltu, xor, srl, sra, or, and,
      /* RVTT Extention Instruction Set */
      settg, setti, getti, getts, ttiat, ttoat, delay, tkend, addtk,
      ////////////////////CSR/////////////////
      csrrw,csrrs,csrrc,csrrwi,csrrsi,csrrci
      = Value
}

object csrType_t extends ChiselEnum{
  val notCsr,csrrw,csrrs,csrrc,csrrwi,csrrsi,csrrci = Value
}

object alu_op_t extends ChiselEnum {
  val nop, add, sub, xor, or, and, sl, sra, srl, lui, lts, ltu, eq ,csr= Value
}

object alu_op1_src_t extends ChiselEnum {
  val reg, pc = Value
}

object alu_op2_src_t extends ChiselEnum {
  val reg, imm = Value
}

object alu_result_src_t extends ChiselEnum {
  val alu, ts, ti = Value
}

object comp_op_t extends ChiselEnum {
  val nop, eq, ne, lt, ltu, ge, geu = Value
}

object r2_src_t extends ChiselEnum {
  val r2, r3 = Value
}

object mem_op_t extends ChiselEnum {
  val nop, lb, lh, lw, lbu, lhu, sb, sh, sw = Value
}

object reg_w_src_t extends ChiselEnum {
  val mem, alu, pc4 = Value
}