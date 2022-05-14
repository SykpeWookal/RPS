import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import Param.Param
import RPSCore._
import Cache._

class RPSIO(private val isaParam: Param) extends Bundle{
  //标准时钟
  val std_clk = Input(Bool())
  //线程起始地址
  val boot_addr = Input(Vec(isaParam.ThreadNumber, UInt(32.W)))
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



}
