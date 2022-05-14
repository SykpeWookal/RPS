package RPSCore

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import Param.Param

object ALUOP extends ChiselEnum {
  val add, addw, sub, subw, xor, or, and, sll, srl, sra, sllw, srlw, sraw, slt, sltu, in1, in2, undef = Value

  def isSub(s: ALUOP.Type): Bool = s === ALUOP.sub || s === ALUOP.subw
  def isCmp(s: ALUOP.Type): Bool = s === ALUOP.slt || s === ALUOP.sltu
}


class ALUIO(private val isaParam: Param) extends Bundle {
  val in1 = Input(UInt(isaParam.XLEN.W))
  val in2 = Input(UInt(isaParam.XLEN.W))
  val aluop = Input(ALUOP())
  val aluout = Output(UInt(isaParam.XLEN.W))

  // RV64I extension
  val isW = Input(Bool()) // whether OP-32/OP-IMM-32 in RV64, i.e. word operations
}


class ALU(isaParam: Param) extends Module{
  require(!isaParam.Multiplication, "ALU does not support multiplication and division extension")
  val io = IO(new ALUIO(isaParam))
  // for RV32, shamt takes lower 5 bits of in2
  // for RV64, shamt takes lower 6 bits of in2
  private val shamtWidth = log2Ceil(isaParam.XLEN)
  private val shamt = WireInit(Cat(
    (io.in2(shamtWidth - 1) & !io.isW & (isaParam.XLEN == 64).B).asUInt,
    io.in2(shamtWidth - 2, 0)))


  private val w = 31
  private val isSub: Bool = ALUOP.isSub(io.aluop)
  private val isCmp: Bool = ALUOP.isCmp(io.aluop)
  private val isSubOrCmp: Bool = isSub || isCmp
  private val in2_inv: UInt = Mux(isSubOrCmp, ~io.in2, io.in2).asUInt
  private val adder_out: UInt = io.in1 + in2_inv + isSubOrCmp

  // default value
  private val out = WireInit(0.U(isaParam.XLEN.W))

  switch(io.aluop) {
    is(ALUOP.add) { out := adder_out }
    is(ALUOP.sub) { out := adder_out }
    is(ALUOP.xor) { out := io.in1 ^ io.in2 }
    is(ALUOP.or) { out := io.in1 | io.in2 }
    is(ALUOP.and) { out := io.in1 & io.in2 }
    is(ALUOP.sll) { out := io.in1 << shamt }
    is(ALUOP.srl) { out := io.in1 >> shamt }
    is(ALUOP.sra) { out := (io.in1.asSInt >> shamt).asUInt }
    is(ALUOP.slt) { out := Cat(Fill(isaParam.XLEN - 1, 0.U), io.in1.asSInt < io.in2.asSInt) }
    is(ALUOP.sltu) { out := Cat(Fill(isaParam.XLEN - 1, 0.U), io.in1 < io.in2) }

    // RV64I extension
    is(ALUOP.addw) { out := adder_out }
    is(ALUOP.subw) { out := adder_out }
    is(ALUOP.sllw) { out := io.in1(w, 0) << shamt }
    is(ALUOP.srlw) { out := io.in1(w, 0) >> shamt }
    is(ALUOP.sraw) { out := (io.in1(w, 0).asSInt >> shamt).asUInt }

    // others
    // these two outputs are useful for bypassing intermediates like csr and store
    is(ALUOP.in1) { out := io.in1 }
    is(ALUOP.in2) { out := io.in2 }
    is(ALUOP.undef) { out := 0.U }
  }
  io.aluout := out
  if(isaParam.XLEN > 32) {
    when(io.isW) {
      require(isaParam.XLEN == 64)
      io.aluout := Cat(Fill(32, out(w)), out(w, 0))
    }
  }
}
