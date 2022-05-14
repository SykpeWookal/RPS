import Cache.TUSERDefine
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import Param.Param

//四状态FSM
object MemStates extends ChiselEnum {
  val IDLE,ReadReq,WriteReq = Value
}


class MemoryIO(private val isaParam: Param) extends Bundle{
  ////////////AXI端///////////////
  //val addr  = Input(UInt(isaParam.XLEN.W))      //地址
  val TVALID = Input(Bool())                      //MasterValid
  val TREADY = Output(Bool())                     //从设备就绪信号
  val TDATAW = Input(UInt(isaParam.XLEN.W))
  val TDATAR = Output(UInt(isaParam.XLEN.W))

  val TLAST = Input(Bool())
  val TUSER = Input(TUSERDefine())

  //val writedata = Input(UInt(isaParam.XLEN.W))  //CPU写的数据，一次写一个word
  //val outdata = Output(UInt(isaParam.XLEN.W))   //读出的数据，一次读一个word

  //val miss = Output(Bool())
}

class Memory(private val isaParam: Param) extends Module{
  val io = IO(new MemoryIO(isaParam))

  //同步读写模块,存储器深度配置
  val mem = SyncReadMem(1<<13,UInt(isaParam.XLEN.W))

  //val TREADY = WireInit(true.B)                     //从设备就绪信号
  val TDATAR = WireInit(0.U(isaParam.XLEN.W))

  val memState = RegInit(MemStates.IDLE)
  val dataBuffer = RegInit(VecInit(Seq.fill(isaParam.LINE_SIZE + 1)(0.U(isaParam.XLEN.W))))//Linesize+1个word
  val bufferValid = RegInit(VecInit(Seq.fill(isaParam.LINE_SIZE + 1)(false.B))) //指示每一位buffer是否有效

  val transferCounter = RegInit(0.U(32.W))//传输次数计数，最多支持2^32个字节流式传输
  val rwmemAddr = RegInit(0.U(30.W))//mem操作地址，word地址，右移2位

  switch(memState){
    is(MemStates.IDLE){
      transferCounter := 0.U
      when(io.TVALID === true.B){
        when(io.TUSER === TUSERDefine.readReq){
          memState := MemStates.ReadReq
        }.elsewhen(io.TUSER === TUSERDefine.writeReq){
          memState := MemStates.WriteReq
        }
      }
    }
    is(MemStates.ReadReq){
      when(io.TLAST === false.B) { //需要继续传输数据，由于多传一次地址，需要多一个周期
        //TVALID := true.B //拉高VALID
        when(transferCounter === 0.U){ //先传地址
          rwmemAddr := io.TDATAW << 2
        }.otherwise{
          TDATAR := mem.read(rwmemAddr)
        }
        rwmemAddr := rwmemAddr + 1.U
        transferCounter := transferCounter + 1.U //传输计数 +1
      }.otherwise{ //传输完成
        memState := MemStates.IDLE
      }
    }
    is(MemStates.WriteReq){
      when(io.TLAST === false.B) { //需要继续传输数据，由于多传一次地址，需要多一个周期
        //TVALID := true.B //拉高VALID
        when(transferCounter === 0.U){ //先传地址
          rwmemAddr := io.TDATAW << 2
        }.otherwise{
          mem.write(rwmemAddr,io.TDATAW)
        }
        rwmemAddr := rwmemAddr + 1.U
        transferCounter := transferCounter + 1.U //传输计数 +1
      }.otherwise{ //传输完成
        memState := MemStates.IDLE
      }
    }

  }


  //处于IDLE状态表示当前能接收一次传输
  //io.TREADY := Mux(memState === MemStates.IDLE, true.B, false.B)
  io.TREADY := true.B
  io.TDATAR := TDATAR

}
