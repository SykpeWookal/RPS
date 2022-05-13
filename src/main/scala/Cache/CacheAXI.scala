package Cache

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import Param.Param


//AXI Master FSM
object CacheAXIStates extends ChiselEnum{
  val IDLE,ReadReq,WriteReq,Resp = Value
}

object TUSERDefine extends ChiselEnum{
  val free,readReq,writeReq = Value
}

class CacheAXIIO(private val isaParam: Param) extends Bundle{
  ////////////Cache端///////////////
  val mem_addr = Input(UInt((isaParam.TAG_ADDR_LEN + isaParam.SET_ADDR_LEN).W)) //给存储器的地址
  val mem_rd_req = Input(Bool())
  val mem_wr_req = Input(Bool())
  val mem_wr_line = Input(Vec(isaParam.LINE_SIZE, UInt(isaParam.XLEN.W)))
  val mem_rd_line = Output(Vec(isaParam.LINE_SIZE,UInt(isaParam.XLEN.W)))
  val cacheAXI_gnt = Output(Bool()) //回送给cache的握手信号

  //////////////AXI端/////////////////////////

  val TVALID = Output(Bool())
  val TLAST = Output(Bool())
  val TREADY = Input(Bool())
  //一次传输一个word
  val TDATAR = Input(UInt(isaParam.XLEN.W))
  val TDATAW = Output(UInt(isaParam.XLEN.W))
  val TUSER = Output(TUSERDefine())

}



class CacheAXI (private val isaParam: Param) extends Module {
  val io = IO(new CacheAXIIO(isaParam))  //IO


  val transferCounter = RegInit(0.U(32.W))//传输次数计数，最多支持2^32个字节流式传输

  val cacheAXIState = RegInit(CacheAXIStates.IDLE)//初始化为IDLE状态

  val TLAST = WireInit(false.B)
  val TVALID = WireInit(false.B)
  val TUSER = WireInit(TUSERDefine.free)

  val TDATAW = WireInit(0.U(isaParam.XLEN.W))

  val rdLine = RegInit(VecInit(Seq.fill(isaParam.LINE_SIZE)(0.U)))//read Line

  switch(cacheAXIState){
    is(CacheAXIStates.IDLE){
      TVALID := false.B //置低VALID
      TLAST := false.B //传输结束信号
      transferCounter := 0.U  //计数器复原
      TUSER := TUSERDefine.free
      when(io.mem_rd_req === true.B){
        when(io.TREADY === true.B){
          cacheAXIState := CacheAXIStates.ReadReq
        }
      }
      when(io.mem_wr_req === true.B){
        when(io.TREADY === true.B){
          cacheAXIState := CacheAXIStates.WriteReq
        }
      }
    }///IDLE

    is(CacheAXIStates.ReadReq){   //作为主设备Master，发起读请求
      TUSER := TUSERDefine.readReq //读请求
      when(io.TREADY === true.B){//slave设备有效时开始传输
        when(transferCounter <= isaParam.LINE_SIZE.U) { //需要继续传输数据，由于多传一次地址，需要多一个周期
          TVALID := true.B //拉高VALID
          when(transferCounter === 0.U){ //先传地址
            TDATAW := Cat(0.U(isaParam.UNUSED_ADDR_LEN.W), io.mem_addr, 0.U((isaParam.LINE_ADDR_LEN+2).W))
          }.otherwise{
            rdLine(transferCounter-1.U) := io.TDATAR
          }
          transferCounter := transferCounter + 1.U //传输计数 +1
        }.otherwise{ //传输完成
          TVALID := false.B //置低VALID
          TLAST := true.B //传输结束信号
          cacheAXIState := CacheAXIStates.Resp //传输完成，给cache回应
        }
      }

    }//ReadReq

    is(CacheAXIStates.WriteReq){  //作为主设备Master，发起写请求
      TUSER := TUSERDefine.writeReq
      when(io.TREADY === true.B){ //slave设备有效时开始传输
        when(transferCounter <= isaParam.LINE_SIZE.U){ //需要继续传输数据，由于多传一次地址，需要多一个周期
          TVALID := true.B //拉高VALID
          when(transferCounter === 0.U){ //先传地址
            TDATAW := Cat(0.U(isaParam.UNUSED_ADDR_LEN.W), io.mem_addr, 0.U((isaParam.LINE_ADDR_LEN+2).W))
          }.otherwise{
            TDATAW := io.mem_wr_line(transferCounter-1.U)
          }
          transferCounter := transferCounter + 1.U //传输计数 +1
        }.otherwise{ //传输完成
          TVALID := false.B //置低VALID
          TLAST := true.B //传输结束信号
          cacheAXIState := CacheAXIStates.Resp //传输完成，给cache回应
        }
      }
    }

    is(CacheAXIStates.Resp){
      cacheAXIState := CacheAXIStates.IDLE
    }
  }

  io.TUSER := TUSER
  io.TVALID := TVALID
  io.TLAST := TLAST
  io.TDATAW := TDATAW
  io.mem_rd_line := rdLine
  io.cacheAXI_gnt := Mux(cacheAXIState === CacheAXIStates.Resp, true.B, false.B)
}