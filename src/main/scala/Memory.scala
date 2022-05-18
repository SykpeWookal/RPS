import Cache.TUSERDefine
import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import Param.Param

import firrtl.annotations.MemoryLoadFileType
import chisel3.util.experimental.loadMemoryFromFile

//四状态FSM
object MemStates extends ChiselEnum {
  val IDLE,ReadReq,WriteReq = Value
}

class SinglePortRAM extends Module {
  val io = IO(new Bundle {
    val addr = Input(UInt(10.W))
    val dataIn = Input(UInt(32.W))
    val en = Input(Bool())
    val we = Input(Bool())
    val dataOut = Output(UInt(32.W))
  })
  val syncRAM = SyncReadMem(1<<13, UInt(32.W))
  when(io.en) {
    when(io.we) {
      syncRAM.write(io.addr, io.dataIn)
      io.dataOut := DontCare
    } .otherwise {
      io.dataOut := syncRAM.read(io.addr)
    }
  } .otherwise {
    io.dataOut := DontCare
  }
  loadMemoryFromFile(syncRAM, "src/test/memory.txt",MemoryLoadFileType.Hex)
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


  //val debugMemAddr = Input(UInt(12.W))
  //val debugMemData = Output(UInt(isaParam.XLEN.W))
  //val debugMemWriteData = Input(UInt(isaParam.XLEN.W))
}

class Memory(private val isaParam: Param) extends Module{
  val io = IO(new MemoryIO(isaParam))

  //同步读写模块,存储器深度配置
  val syncMem = Module(new SinglePortRAM)
  syncMem.io.en := true.B

  //val TREADY = WireInit(true.B)                     //从设备就绪信号
  val TDATAR = WireInit(0.U(isaParam.XLEN.W))

  val memState = RegInit(MemStates.IDLE)
  val dataBuffer = RegInit(VecInit(Seq.fill(isaParam.LINE_SIZE + 1)(0.U(isaParam.XLEN.W))))//Linesize+1个word
  val bufferValid = RegInit(VecInit(Seq.fill(isaParam.LINE_SIZE + 1)(false.B))) //指示每一位buffer是否有效

  val transferCounter = RegInit(0.U(32.W))//传输次数计数，最多支持2^32个字节流式传输
  val rwmemAddr = RegInit(0.U(30.W))//mem操作地址，word地址，右移2位


  syncMem.io.dataIn := 0.U
  syncMem.io.we := false.B
  syncMem.io.addr := 0.U
  switch(memState){
    is(MemStates.IDLE){
      /////////debugData/////////
      syncMem.io.dataIn := 0.U
      syncMem.io.we := false.B
      syncMem.io.addr := 0.U
      ///////////////////////////
      transferCounter := 0.U
      when(io.TVALID === true.B){
        rwmemAddr := io.TDATAW >> 2
        when(io.TUSER === TUSERDefine.readReq){
          memState := MemStates.ReadReq
        }.elsewhen(io.TUSER === TUSERDefine.writeReq){
          memState := MemStates.WriteReq
        }
      }
    }

    is(MemStates.ReadReq){
      when(io.TLAST === false.B) { //需要继续传输数据，由于多传一次地址，需要多一个周期

          syncMem.io.addr := rwmemAddr
          TDATAR := syncMem.io.dataOut

        rwmemAddr := rwmemAddr + 1.U
        transferCounter := transferCounter + 1.U //传输计数 +1
      }.otherwise{ //传输完成
        memState := MemStates.IDLE
      }
    }

    is(MemStates.WriteReq){
      when(io.TLAST === false.B) { //需要继续传输数据，由于多传一次地址，需要多一个周期
        //TVALID := true.B //拉高VALID

          syncMem.io.addr := rwmemAddr
          syncMem.io.dataIn := io.TDATAW
          syncMem.io.we := true.B

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

  //io.debugMemData := syncMem.read(io.debugMemAddr)

}
