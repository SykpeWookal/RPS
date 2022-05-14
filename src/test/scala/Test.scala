import Param.Param
import RPSCore._
import Cache._
import chisel3._
import chisel3.util._
import chisel3.iotesters._



import scala.util._

class RegTest(c: RegisterFileGroup) extends PeekPokeTester(c) {
  val randNum = new Random
  for (i <- 0 until 10) {
    val a = randNum.nextInt(256)
    val b = randNum.nextInt(256)
    poke(c.io.Raddr1, 0)
    poke(c.io.Raddr2, 1)
    step(10)
    expect(c.io.Rdata1, 0x00000000)
    expect(c.io.Rdata2, 0x00000000)
  }
}
object RegTestGen extends App {
  val isaParam = new Param(XLEN = 32,
    ThreadNumber = 2,
    Embedded = false,
    Atomic = true,
    Multiplication = false,
    Compressed = false,
    SingleFloatingPoint = false,
    DoubleFloatingPoint = false)
  chisel3.iotesters.Driver.execute(args, () => new RegisterFileGroup(isaParam))(c => new RegTest(c))
}




object CacheGen extends App {
  val isaParam = new Param(XLEN = 32,
    ThreadNumber = 2,
    Embedded = false,
    Atomic = true,
    Multiplication = false,
    Compressed = false,
    SingleFloatingPoint = false,
    DoubleFloatingPoint = false)
  (new chisel3.stage.ChiselStage).emitVerilog(new Cache(isaParam))
}

object CacheAXIGen extends App {
  val isaParam = new Param(XLEN = 32,
    ThreadNumber = 2,
    Embedded = false,
    Atomic = true,
    Multiplication = false,
    Compressed = false,
    SingleFloatingPoint = false,
    DoubleFloatingPoint = false)
  (new chisel3.stage.ChiselStage).emitVerilog(new CacheAXI(isaParam))
}

object memGen extends App {
  val isaParam = new Param(XLEN = 32,
    ThreadNumber = 2,
    Embedded = false,
    Atomic = true,
    Multiplication = false,
    Compressed = false,
    SingleFloatingPoint = false,
    DoubleFloatingPoint = false)
  (new chisel3.stage.ChiselStage).emitVerilog(new Memory(isaParam))
}

//Core综合
object rpu_core extends App {
  val isaParam = new Param(XLEN = 32,
    ThreadNumber = 2,
    Embedded = false,
    Atomic = true,
    Multiplication = false,
    Compressed = false,
    SingleFloatingPoint = false,
    DoubleFloatingPoint = false)
  (new chisel3.stage.ChiselStage).emitVerilog(new rpu_core(isaParam))
}


object CSR extends App {
  val isaParam = new Param(XLEN = 32,
    ThreadNumber = 2,
    Embedded = false,
    Atomic = true,
    Multiplication = false,
    Compressed = false,
    SingleFloatingPoint = false,
    DoubleFloatingPoint = false)
  (new chisel3.stage.ChiselStage).emitVerilog(new CSR(isaParam))
}


class CacheTest(c: Cache) extends PeekPokeTester(c) {

  val randNum = new Random
  for (i <- 0 until 1) {
    var a = randNum.nextInt(8192)   //按3 3 6的长度设置总共用了地址的低14位
//    val b = randNum.nextInt(8192)

    a = a - (a % 4)   //取对齐地址

    println(s"addr= $a \n")
    //T=0
    poke(c.io.addr, a)
    poke(c.io.r_req, true)
    poke(c.io.w_req, false)
    poke(c.io.writedata,0)
    expect(c.io.miss,true)
    expect(c.io.outdata,0)
    //expect(c.cache_Hit,false)
    //expect(c.cacheState,CacheStates.IDLE)

    step(1)
    //SWAP IN
    expect(c.io.miss,true)
    expect(c.io.mem_rd_req,true)
    expect(c.io.mem_addr,a >> 5)
    expect(c.io.mem_wr_req,false)

    step(10)
    expect(c.io.miss,true)
    for(k <- 0 until(CacheTestGen.isaParam.LINE_SIZE)){
      poke(c.io.mem_rd_line(k),514+k)
    }
    step(1)
    poke(c.io.cacheAXI_gnt,true)


    step(1) //SWAPIN OK
    poke(c.io.cacheAXI_gnt,false)
    expect(c.io.miss,true)


    step(1) //IDLE
    expect(c.io.miss,false)
    val b = (a>>2) % 8
    expect(c.io.outdata,514+b)


  }
}


object CacheTestGen extends App {
  val isaParam = new Param(XLEN = 32,
    ThreadNumber = 2,
    Embedded = false,
    Atomic = true,
    Multiplication = false,
    Compressed = false,
    SingleFloatingPoint = false,
    DoubleFloatingPoint = false)
  chisel3.iotesters.Driver.execute(args, () => new Cache(isaParam))(c => new CacheTest(c))
}