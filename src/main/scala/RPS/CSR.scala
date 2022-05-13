package RPS

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import Param.Param

class CSRIO(private val isaParam: Param) extends Bundle{
  val CSRType = Input(csrType_t())
  val CSRAddr = Input(UInt(12.W))
  val RegFileData = Input(UInt(isaParam.XLEN.W))//rs1
  val rsData = Input(UInt(isaParam.XLEN.W))//operand2,imm类型

  val CSROut = Output(UInt(isaParam.XLEN.W))
}


class CSR(private val isaParam: Param) extends Module{
  //定义输入输出接口
  val io = IO(new CSRIO(isaParam))


  val CSReg = RegInit(VecInit(Seq.fill(64)(0.U(isaParam.XLEN.W))))//4096个CSR,内存原因，只取前64个

  val out = RegInit(0.U(isaParam.XLEN.W))

  switch(io.CSRType){
    is(csrType_t.notCsr){
      out := 0.U
    }
    is(csrType_t.csrrw){
      out := CSReg(io.CSRAddr)
      CSReg(io.CSRAddr) := io.RegFileData
    }
    is(csrType_t.csrrs){
      out := CSReg(io.CSRAddr)
      CSReg(io.CSRAddr) := CSReg(io.CSRAddr) | io.RegFileData
    }
    is(csrType_t.csrrc){
      out := CSReg(io.CSRAddr)
      CSReg(io.CSRAddr) := CSReg(io.CSRAddr) & (~io.RegFileData)
    }
    is(csrType_t.csrrwi){
      out := CSReg(io.CSRAddr)
      CSReg(io.CSRAddr) := io.rsData
    }
    is(csrType_t.csrrsi){
      out := CSReg(io.CSRAddr)
      CSReg(io.CSRAddr) := CSReg(io.CSRAddr) | io.rsData
    }
    is(csrType_t.csrrci){
      out := CSReg(io.CSRAddr)
      CSReg(io.CSRAddr) := CSReg(io.CSRAddr) & (~io.rsData)
    }
  }



  io.CSROut := out
}
