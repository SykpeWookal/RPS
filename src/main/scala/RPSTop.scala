import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import Param.Param
import RPSCore._
import Cache._

//仲裁状态
object BusArbiterState extends ChiselEnum {
  val IRound,DRound = Value
}

class RPSIO(private val isaParam: Param) extends Bundle{
  //标准时钟
  val std_clk = Input(Bool())
  //线程起始地址
  val boot_addr = Input(Vec(isaParam.ThreadNumber, UInt(32.W)))

  val debugMemAddr = Input(UInt(12.W))
  val debugMemData = Output(UInt(isaParam.XLEN.W))
}

class RPSTop(private val isaParam: Param) extends Module{
  val io = IO(new RPSIO(isaParam))

  ///////////////////模块定义/////////////////////////
  val core = Module(new rpu_core(isaParam))
  val Icache = Module(new Cache(isaParam))
  val Dcache = Module(new Cache(isaParam))
  val IcacheAXI = Module(new CacheAXI(isaParam))
  val DcacheAXI = Module(new CacheAXI(isaParam))
  val mem = Module(new Memory(isaParam))
 /////////////////////////////////////////////////////

  core.io.std_clk := io.std_clk//stdclk
  core.io.boot_addr := io.boot_addr//起始地址
  core.io.instr_data := Icache.io.outdata//读出的指令
  core.io.data_rdata := Dcache.io.outdata//读出的数据
  core.io.IMiss := Icache.io.miss
  core.io.DMiss := Dcache.io.miss//MISS
  //////////////////////////////////////////

  Icache.io.addr := core.io.instr_addr
  Icache.io.writeMask := 0.U
  Icache.io.w_req := false.B
  Icache.io.writedata := 0.U
  Dcache.io.addr := core.io.data_addr
  Dcache.io.writeMask := core.io.data_be
  Dcache.io.w_req := core.io.data_we
  Dcache.io.writedata := core.io.data_wdata

  Icache.io.r_req := true.B
  Dcache.io.r_req := false.B
  /////待处理：读请求
  /////////////////////////////////////////
  Icache.io.mem_rd_line := IcacheAXI.io.mem_rd_line
  Icache.io.cacheAXI_gnt := IcacheAXI.io.cacheAXI_gnt
  Dcache.io.mem_rd_line := DcacheAXI.io.mem_rd_line
  Dcache.io.cacheAXI_gnt := DcacheAXI.io.cacheAXI_gnt
  ////////////////////////////////////////////////
  //////////////////AXI-cache/////////////
  IcacheAXI.io.mem_addr := Icache.io.mem_addr
  IcacheAXI.io.mem_rd_req := Icache.io.mem_rd_req
  IcacheAXI.io.mem_wr_req := Icache.io.mem_wr_req
  IcacheAXI.io.mem_wr_line := Icache.io.mem_wr_line
  DcacheAXI.io.mem_addr := Dcache.io.mem_addr
  DcacheAXI.io.mem_rd_req := Dcache.io.mem_rd_req
  DcacheAXI.io.mem_wr_req := Dcache.io.mem_wr_req
  DcacheAXI.io.mem_wr_line := Dcache.io.mem_wr_line

  val cid = RegInit(BusArbiterState.IRound)

  ///////////选择master///////////////
  mem.io.TDATAW := 0.U
  mem.io.TUSER := TUSERDefine.free
  mem.io.TVALID := false.B
  mem.io.TLAST := false.B
  IcacheAXI.io.TREADY := false.B
  IcacheAXI.io.TDATAR := 0.U
  DcacheAXI.io.TREADY := false.B
  DcacheAXI.io.TDATAR := 0.U
  when(cid === BusArbiterState.IRound){ //ICacheRound
    mem.io.TDATAW := IcacheAXI.io.TDATAW
    mem.io.TUSER := IcacheAXI.io.TUSER
    mem.io.TVALID := IcacheAXI.io.TVALID
    mem.io.TLAST := IcacheAXI.io.TLAST
    IcacheAXI.io.TREADY := mem.io.TREADY
    IcacheAXI.io.TDATAR := mem.io.TDATAR
  }.elsewhen(cid === BusArbiterState.DRound){//DCacheRound
    mem.io.TDATAW := DcacheAXI.io.TDATAW
    mem.io.TUSER := DcacheAXI.io.TUSER
    mem.io.TVALID := DcacheAXI.io.TVALID
    mem.io.TLAST := DcacheAXI.io.TLAST
    DcacheAXI.io.TREADY := mem.io.TREADY
    DcacheAXI.io.TDATAR := mem.io.TDATAR
  }
  ///////////更新cid///////////
  when(cid === BusArbiterState.IRound){ //ICacheRound
    when(IcacheAXI.io.TUSER =/= TUSERDefine.free){
      cid := BusArbiterState.DRound
    }
  }.elsewhen(cid === BusArbiterState.DRound){//DCacheRound
    when(DcacheAXI.io.TUSER =/= TUSERDefine.free){
      cid := BusArbiterState.IRound
    }
  }


  mem.io.debugMemAddr := io.debugMemAddr
  io.debugMemData := mem.io.debugMemData

}
