import Cache.TUSERDefine
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import Param.Param

//四状态FSM
object MemStates extends ChiselEnum {
  val IDLE,Busy = Value
}


class MemoryIO(private val isaParam: Param) extends Bundle{
  ////////////AXI端///////////////
  //val addr  = Input(UInt(isaParam.XLEN.W))      //地址
  val TVALID = Input(Bool())                      //MasterValid
  val TREADY = Output(Bool())                     //从设备就绪信号
  val TDATAW = Input(UInt(isaParam.XLEN.W))
  val TDATAR = Output(UInt(isaParam.XLEN.W))

  val TUSER = Input(TUSERDefine())

  //val writedata = Input(UInt(isaParam.XLEN.W))  //CPU写的数据，一次写一个word
  //val outdata = Output(UInt(isaParam.XLEN.W))   //读出的数据，一次读一个word

  //val miss = Output(Bool())
}

class Memory(private val isaParam: Param) extends Module{
  val io = IO(new MemoryIO(isaParam))

  //同步读写模块,存储器深度配置
  val mem = SyncReadMem(1<<13,UInt(isaParam.XLEN.W))

  val memState = RegInit(MemStates.IDLE)
  val dataBuffer = RegInit(VecInit(Seq.fill(isaParam.LINE_SIZE + 1)(0.U(isaParam.XLEN.W))))//Linesize+1个word
  val bufferValid = RegInit(VecInit(Seq.fill(isaParam.LINE_SIZE + 1)(false.B))) //指示每一位buffer是否有效

  switch(memState){
    is(MemStates.IDLE){
      when(io.TVALID === true.B){
        memState := MemStates.Busy
      }
    }

  }


  //处于IDLE状态表示当前能接收一次传输
  io.TREADY := Mux(memState === MemStates.IDLE, true.B, false.B)


}
