package Cache

import chisel3._
import chisel3.util._
import chisel3.experimental.ChiselEnum
import Param.Param


//四状态FSM
object CacheStates extends ChiselEnum {
  val IDLE,SwapOut,SwapIn,SwapInOK = Value
}


class CacheIO(private val isaParam: Param) extends Bundle{
  ////////////CPU端///////////////
  val addr  = Input(UInt(isaParam.XLEN.W))      //地址
  val r_req = Input(Bool())                     //读请求
  val w_req = Input(Bool())                     //写请求

  val writedata = Input(UInt(isaParam.XLEN.W))  //CPU写的数据，一次写一个word
  val outdata = Output(UInt(isaParam.XLEN.W))   //读出的数据，一次读一个word

  val miss = Output(Bool())

  //////////////AXI端/////////////////////////
  val mem_addr = Output(UInt((isaParam.TAG_ADDR_LEN + isaParam.SET_ADDR_LEN).W))//给存储器的地址
  val mem_rd_req = Output(Bool())
  val mem_wr_req = Output(Bool())
  val mem_wr_line = Output(Vec(1 << isaParam.LINE_ADDR_LEN,UInt(isaParam.XLEN.W)))
  val mem_rd_line = Input(Vec(1 << isaParam.LINE_ADDR_LEN,UInt(isaParam.XLEN.W)))
  val cacheAXI_gnt = Input(Bool())


}



class Cache(private val isaParam: Param) extends Module {
  //定义输入输出接口
  val io = IO(new CacheIO(isaParam))

//  //定义本地变量
//  private val MEM_ADDR_LEN    = isaParam.TAG_ADDR_LEN + isaParam.SET_ADDR_LEN ; // 计算主存地址长度 MEM_ADDR_LEN，主存大小=2^MEM_ADDR_LEN个line
//  private val UNUSED_ADDR_LEN = 32 - isaParam.TAG_ADDR_LEN - isaParam.SET_ADDR_LEN - isaParam.LINE_ADDR_LEN - 2 ; // 计算未使用的地址的长度
//  private val LINE_SIZE       = 1 << isaParam.LINE_ADDR_LEN  ;         // 计算 line 中 word 的数量，即 2^LINE_ADDR_LEN 个word 每 line
//  private val SET_SIZE        = 1 << isaParam.SET_ADDR_LEN   ;         // 计算一共有多少组，即 2^SET_ADDR_LEN 个组
//  private val WAY_SIZE        = 1 << isaParam.WAY_CNT   ;


  val CacheMem = RegInit(VecInit(Seq.fill(isaParam.SET_SIZE)(VecInit(Seq.fill(isaParam.WAY_SIZE)(VecInit(Seq.fill(isaParam.LINE_SIZE)(0.U(isaParam.XLEN.W)))))))) // SET_SIZE个line，每个line有LINE_SIZE个word


  val cache_tags = RegInit(VecInit(Seq.fill(isaParam.SET_SIZE)(VecInit(Seq.fill(isaParam.WAY_SIZE)(0.U((isaParam.TAG_ADDR_LEN).W)))))) // SET_SIZE个TAG
  val valid = RegInit(VecInit(Seq.fill(isaParam.SET_SIZE)(VecInit(Seq.fill(isaParam.WAY_SIZE)(false.B)))))      // SET_SIZE个valid(有效位)
  val dirty = RegInit(VecInit(Seq.fill(isaParam.SET_SIZE)(VecInit(Seq.fill(isaParam.WAY_SIZE)(false.B)))))      // SET_SIZE个dirty(脏位)



  // 将输入地址addr拆分成这5个部分  拆分 32bit ADDR
  val word_addr = io.addr(2-1,0)
  val line_addr = io.addr(isaParam.LINE_ADDR_LEN+1, 2)
  val set_addr = io.addr(isaParam.SET_ADDR_LEN+isaParam.LINE_ADDR_LEN+1, isaParam.LINE_ADDR_LEN+2)
  val tag_addr = io.addr(isaParam.TAG_ADDR_LEN+isaParam.SET_ADDR_LEN+isaParam.LINE_ADDR_LEN+1, isaParam.SET_ADDR_LEN+isaParam.LINE_ADDR_LEN+2)
  val unused_addr = io.addr(isaParam.XLEN-1, isaParam.TAG_ADDR_LEN+isaParam.SET_ADDR_LEN+isaParam.LINE_ADDR_LEN+2)
  ////////////////////////////////

  val mem_rd_set_addr = RegInit(0.U(isaParam.SET_ADDR_LEN.W))
  val mem_rd_tag_addr = RegInit(0.U(isaParam.TAG_ADDR_LEN.W))
  val mem_rd_addr = Cat(mem_rd_tag_addr, mem_rd_set_addr)
  val mem_wr_addr = RegInit(0.U(isaParam.MEM_ADDR_LEN.W))


//  val mem_wr_line = RegInit(VecInit(Seq.fill(LINE_SIZE)(0.U(isaParam.XLEN.W))))
//  val mem_rd_line = WireInit(VecInit(Seq.fill(LINE_SIZE)(0.U(isaParam.XLEN.W))))
//  val cacheAXI_gnt = WireInit(false.B)

  val cache_Hit = WireInit(false.B)
  val way_hit = WireInit(0.U)

//判断是否命中
  when(io.w_req | io.r_req){
        cache_Hit := false.B
        way_hit := 0.U
    for( i <- 0 until(isaParam.WAY_SIZE)){
      when(valid(set_addr)(i.U)===true.B && cache_tags(set_addr)(i.U)===tag_addr){
        cache_Hit := true.B
        way_hit := i.U
      }
    }
  }


  val cacheState = RegInit(CacheStates.IDLE)

  //////////////////////////////////////////
  val wayout_choice = WireInit(0.U(isaParam.WAY_CNT.W))
  ///*******替换策略*******///
  ////////////////FIFO////////////////
  if(isaParam.replacement == 0){
    val FIFO_Choice = RegInit(VecInit(Seq.fill(isaParam.SET_SIZE)(0.U(isaParam.XLEN.W))))//只需要对于每一个set，分别用一个变量记录该set应该换出的way号即可
    switch(cacheState){
      is(CacheStates.IDLE){
        wayout_choice := FIFO_Choice(set_addr)
      }
      is(CacheStates.SwapInOK){
        FIFO_Choice(set_addr) := ((FIFO_Choice(set_addr)+1.U) % isaParam.WAY_SIZE.U)
      }
    }
  }
    /////////////////////LRU////////////
  else if(isaParam.replacement == 1){

  }

  ///////////////LRU/////////////////
  //////////////////////////////////////////



  val out = WireInit(0.U(isaParam.XLEN.W))
  val mem_wr_line = RegInit(VecInit(Seq.fill(isaParam.LINE_SIZE)(0.U(isaParam.XLEN.W))))
  ////////Cache FSM/////////////////
  switch(cacheState){
    is(CacheStates.IDLE){  //IDLE
      when(cache_Hit){ //命中
        when(io.r_req === true.B){  //读请求
          //io.outdata := CacheMem(set_addr)(way_hit)(line_addr)
          out := CacheMem(set_addr)(way_hit)(line_addr)
        }.elsewhen(io.w_req === true.B){  //写请求
          CacheMem(set_addr)(way_hit)(line_addr) := io.writedata
          dirty(set_addr)(way_hit) := true.B
        }.otherwise{
          cacheState := CacheStates.IDLE
        }
      }.otherwise{ //未命中
        when(io.w_req | io.r_req){
          when(valid(set_addr)(wayout_choice) === true.B && dirty(set_addr)(wayout_choice) === true.B){
            cacheState := CacheStates.SwapOut
            mem_wr_addr := Cat(cache_tags(set_addr)(wayout_choice),set_addr)
            mem_wr_line := CacheMem(set_addr)(wayout_choice)
          }.otherwise{
            cacheState := CacheStates.SwapIn
          }
          mem_rd_tag_addr := tag_addr
          mem_rd_set_addr := set_addr
        }
      }
    }
    is(CacheStates.SwapOut){ //换出状态
      when(io.cacheAXI_gnt === true.B){
        cacheState := CacheStates.SwapIn
      }
    }
    is(CacheStates.SwapIn){ //换入状态
      when(io.cacheAXI_gnt === true.B){
        cacheState := CacheStates.SwapInOK
      }
    }
    is(CacheStates.SwapInOK){ //换入后写入cache
      cacheState := CacheStates.IDLE
      cache_tags(mem_rd_set_addr)(wayout_choice) := mem_rd_tag_addr
      valid(mem_rd_set_addr)(wayout_choice) := true.B
      dirty(mem_rd_set_addr)(wayout_choice) := false.B
      for(i <- 0 until(isaParam.LINE_SIZE)){
        CacheMem(mem_rd_set_addr)(wayout_choice)(i.U) := io.mem_rd_line(i.U)
        //CacheMem(mem_rd_set_addr)(wayout_choice)(i.U) := 1234.U
      }
    }
  }


//  val mem_rd_req = Wire(Bool())
//  val mem_wr_req = Wire(Bool())
  io.mem_rd_req := Mux(cacheState === CacheStates.SwapIn,true.B,false.B)
  io.mem_wr_req := Mux(cacheState === CacheStates.SwapOut,true.B,false.B)

//  val mem_addr = Wire(UInt(MEM_ADDR_LEN.W))//给存储器的地址
  io.mem_addr := Mux(io.mem_rd_req === true.B, mem_rd_addr, Mux(io.mem_wr_req, mem_wr_addr, 0.U))


  io.outdata := out
  io.mem_wr_line := mem_wr_line
  io.miss := (io.r_req | io.w_req) & ~(cache_Hit & cacheState === CacheStates.IDLE)
}