package RPSCore

import chisel3._
import chisel3.util._
import Param.Param

class RegisterFileIO(private val isaParam: Param) extends Bundle {
  // thread id 更新接口
  val TID_Change_En = Input(Bool())
  val TID_Changed_ID = Input(UInt((log2Ceil(isaParam.ThreadNumber)).W))
  // read ports
  val Raddr1 = Input(UInt(log2Ceil(isaParam.registerCount).W))
  val Raddr2 = Input(UInt(log2Ceil(isaParam.registerCount).W))
  val Raddr3= Input(UInt(log2Ceil(isaParam.registerCount).W))
  val Rdata1 = Output(UInt(isaParam.XLEN.W))
  val Rdata2 = Output(UInt(isaParam.XLEN.W))
  val Rdata3 = Output(UInt(isaParam.XLEN.W))
  // write port
  val Write_En = Input(Bool())
  val Waddr = Input(UInt(log2Ceil(isaParam.registerCount).W))
  val Wdata = Input(UInt(isaParam.XLEN.W))
}


class RegisterFileGroup (private val isaParam: Param) extends Module{
  val io = IO(new RegisterFileIO(isaParam))
  //当前选中的线程ID
  val TID = Reg(UInt((log2Ceil(isaParam.ThreadNumber)).W))
  //寄存器堆，全部初始化为0
  val RegFileGroup = RegInit(VecInit(Seq.fill(isaParam.ThreadNumber * isaParam.registerCount){0.U(isaParam.XLEN.W)}))

  //写使能有效 and 线程更改，优先更新线程
  when(io.TID_Change_En && (io.TID_Changed_ID < isaParam.ThreadNumber.U)) {
    TID := io.TID_Changed_ID
  } .elsewhen(io.Write_En && io.Waddr =/= 0.U) {
    RegFileGroup(Cat(TID, io.Waddr)) := io.Wdata
  }
  //读口
  io.Rdata1 := RegFileGroup(Cat(TID, io.Raddr1))
  io.Rdata2 := RegFileGroup(Cat(TID, io.Raddr2))
  io.Rdata3 := RegFileGroup(Cat(TID, io.Raddr3))
}
