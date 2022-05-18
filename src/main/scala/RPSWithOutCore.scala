import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import Param.Param
import RPSCore._
import Cache._


class RPSWithOutCoreIO(private val isaParam: Param) extends Bundle{
//  //标准时钟
//  val std_clk = Input(Bool())
//  //线程起始地址
//  val boot_addr = Input(Vec(isaParam.ThreadNumber, UInt(32.W)))
//
//  //val debugMemAddr = Input(UInt(12.W))
//  //val debugMemData = Output(UInt(isaParam.XLEN.W))
//  //val debugMemWriteData = Input(UInt(isaParam.XLEN.W))
//
//  val debugCoreIAddr = Output(UInt(isaParam.XLEN.W))
//  val debugCoreDAddr = Output(UInt(isaParam.XLEN.W))
//  val debugCoreIData = Output(UInt(isaParam.XLEN.W))
//  val debugCoreDData = Output(UInt(isaParam.XLEN.W))

  val instr_addr = Input(UInt(32.W))
  val instr_data = Output(UInt(32.W))

  val IMiss = Output(Bool())
  val DMiss = Output(Bool())


  val data_be = Input(UInt(4.W))
  val data_we = Input(Bool())
  val data_addr = Input(UInt(32.W))
  val data_wdata = Input(UInt(32.W))
  val data_rdata = Output(UInt(32.W))

  val IRreq = Input(Bool())
  val DRreq = Input(Bool())
//  val DWreq = Input(Bool())
}

class RPSWithOutCore(private val isaParam: Param) extends Module{
  val io = IO(new RPSWithOutCoreIO(isaParam))

  ///////////////////模块定义/////////////////////////
  //val core = Module(new rpu_core(isaParam))
  val Icache = Module(new Cache(isaParam))
  val Dcache = Module(new Cache(isaParam))
  val IcacheAXI = Module(new CacheAXI(isaParam))
  val DcacheAXI = Module(new CacheAXI(isaParam))
  val mem = Module(new Memory(isaParam))
  /////////////////////////////////////////////////////

  //core.io.std_clk := io.std_clk//stdclk
  //core.io.boot_addr := io.boot_addr//起始地址
//  core.io.instr_data := Icache.io.outdata//读出的指令
//  core.io.data_rdata := Dcache.io.outdata//读出的数据
//  core.io.IMiss := Icache.io.miss
//  core.io.DMiss := Dcache.io.miss//MISS

  io.IMiss := Icache.io.miss
  io.DMiss := Dcache.io.miss
  io.instr_data := Icache.io.outdata//读出的指令
  io.data_rdata := Dcache.io.outdata//读出的数据
  //////////////////////////////////////////

  Icache.io.addr := io.instr_addr
  Icache.io.writeMask := 0.U
  Icache.io.w_req := false.B
  Icache.io.writedata := 0.U
  Dcache.io.addr := io.data_addr
  Dcache.io.writeMask := io.data_be
  Dcache.io.w_req := io.data_we
  Dcache.io.writedata := io.data_wdata

  Icache.io.r_req := io.IRreq
  Dcache.io.r_req := io.DRreq
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

  val cid = RegInit(BusArbiterState.DRound)

  ///////////选择master///////////////
  //  syncMem.io.TDATAW := 0.U
  //  syncMem.io.TUSER := TUSERDefine.free
  //  syncMem.io.TVALID := false.B
  //  syncMem.io.TLAST := false.B
  //  IcacheAXI.io.TREADY := false.B
  //  IcacheAXI.io.TDATAR := 0.U
  //  DcacheAXI.io.TREADY := false.B
  //  DcacheAXI.io.TDATAR := 0.U
  when(cid === BusArbiterState.IRound){ //ICacheRound
    mem.io.TDATAW := IcacheAXI.io.TDATAW
    mem.io.TUSER := IcacheAXI.io.TUSER
    mem.io.TVALID := IcacheAXI.io.TVALID
    mem.io.TLAST := IcacheAXI.io.TLAST
    IcacheAXI.io.TREADY := mem.io.TREADY
    IcacheAXI.io.TDATAR := mem.io.TDATAR
    DcacheAXI.io.TREADY := false.B
    DcacheAXI.io.TDATAR := 0.U
  }.elsewhen(cid === BusArbiterState.DRound){//DCacheRound
    mem.io.TDATAW := DcacheAXI.io.TDATAW
    mem.io.TUSER := DcacheAXI.io.TUSER
    mem.io.TVALID := DcacheAXI.io.TVALID
    mem.io.TLAST := DcacheAXI.io.TLAST
    DcacheAXI.io.TREADY := mem.io.TREADY
    DcacheAXI.io.TDATAR := mem.io.TDATAR
    IcacheAXI.io.TREADY := false.B
    IcacheAXI.io.TDATAR := 0.U
  }.otherwise{
    mem.io.TDATAW := 0.U
    mem.io.TUSER := TUSERDefine.free
    mem.io.TVALID := false.B
    mem.io.TLAST := false.B
    DcacheAXI.io.TREADY := false.B
    DcacheAXI.io.TDATAR := 0.U
    IcacheAXI.io.TREADY := false.B
    IcacheAXI.io.TDATAR := 0.U
  }


  ///////////更新cid///////////
  when(cid === BusArbiterState.IRound){ //ICacheRound
    when(IcacheAXI.io.TUSER === TUSERDefine.free){
      cid := BusArbiterState.DRound
    }
  }.elsewhen(cid === BusArbiterState.DRound){//DCacheRound
    when(DcacheAXI.io.TUSER === TUSERDefine.free){
      cid := BusArbiterState.IRound
    }
  }


  //mem.io.debugMemAddr := io.debugMemAddr
  //io.debugMemData := mem.io.debugMemData
  //mem.io.debugMemWriteData := io.debugMemWriteData

//  io.debugCoreIAddr := core.io.instr_addr
//  io.debugCoreDAddr := core.io.data_addr
//  io.debugCoreIData := Icache.io.outdata
//  io.debugCoreDData := Dcache.io.outdata
}
