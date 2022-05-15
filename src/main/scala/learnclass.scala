import chisel3._
import chisel3.util._
import chisel3.tester._
import chisel3.tester.RawTester.test
//import scala.collection._

class learnclassMem(length: Int) extends Module {
  val io = IO(new Bundle {
    val inaddr = Input(UInt(5.W))
    val en = Input(Bool())
    val indata = Input(UInt(32.W))
    val out = Output(UInt(32.W))
  })
  // Arbiter doesn't have a convenience constructor, so it's built like any Module
  val mem = SyncReadMem(32,UInt(32.W))  // 2 to 1 Priority Arbiter

  when(io.en){
    mem.write(io.inaddr, io.indata)
  }

  io.out := mem.read(io.inaddr)
}


class learnclass(length: Int) extends Module {
  // ram.scala
    val io = IO(new Bundle {
      val addr = Input(UInt(10.W))
      val dataIn = Input(UInt(32.W))
      val en = Input(Bool())
      val we = Input(Bool())
      val dataOut = Output(UInt(32.W))
    })
    val syncRAM = SyncReadMem(1024, UInt(32.W))
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
}

object T1 extends App {
  test(new Module {
    // Example circuit using a Queue
    val io = IO(new Bundle {
      val in = Flipped(Decoupled(UInt(8.W)))
      val out = Decoupled(UInt(8.W))
    })
    val queue = Queue(io.in, 2)  // 2-element queue
    io.out <> queue
  }) { c =>
    c.io.out.ready.poke(false.B)
    c.io.in.valid.poke(true.B)  // Enqueue an element
    c.io.in.bits.poke(42.U)
    println(s"Starting:")
    println(s"\tio.in: ready=${c.io.in.ready.peek().litValue}")
    println(s"\tio.out: valid=${c.io.out.valid.peek().litValue}, bits=${c.io.out.bits.peek().litValue}")
    c.clock.step(1)

    c.io.in.valid.poke(true.B)  // Enqueue another element
    c.io.in.bits.poke(43.U)
    // What do you think io.out.valid and io.out.bits will be?
    println(s"After first enqueue:")
    println(s"\tio.in: ready=${c.io.in.ready.peek().litValue}")
    println(s"\tio.out: valid=${c.io.out.valid.peek().litValue}, bits=${c.io.out.bits.peek().litValue}")
    c.clock.step(1)

    c.io.in.valid.poke(true.B)  // Read a element, attempt to enqueue
    c.io.in.bits.poke(44.U)
    c.io.out.ready.poke(true.B)
    // What do you think io.in.ready will be, and will this enqueue succeed, and what will be read?
    println(s"On first read:")
    println(s"\tio.in: ready=${c.io.in.ready.peek()}")
    println(s"\tio.out: valid=${c.io.out.valid.peek()}, bits=${c.io.out.bits.peek()}")
    c.clock.step(1)

    c.io.in.valid.poke(false.B)  // Read elements out
    c.io.out.ready.poke(true.B)
    // What do you think will be read here?
    println(s"On second read:")
    println(s"\tio.in: ready=${c.io.in.ready.peek()}")
    println(s"\tio.out: valid=${c.io.out.valid.peek()}, bits=${c.io.out.bits.peek()}")
    c.clock.step(1)

    // Will a third read produce anything?
    println(s"On third read:")
    println(s"\tio.in: ready=${c.io.in.ready.peek()}")
    println(s"\tio.out: valid=${c.io.out.valid.peek()}, bits=${c.io.out.bits.peek()}")
    c.clock.step(1)
  }
}

object T2 extends App {
  test(new Module {
    // Example circuit using a priority arbiter
    val io = IO(new Bundle {
      val in = Flipped(Vec(2, Decoupled(UInt(8.W))))
      val out = Decoupled(UInt(8.W))
    })
    // Arbiter doesn't have a convenience constructor, so it's built like any Module
    val arbiter = Module(new Arbiter(UInt(8.W), 2))  // 2 to 1 Priority Arbiter
    arbiter.io.in <> io.in
    io.out <> arbiter.io.out
  }) { c =>
    c.io.in(0).valid.poke(false.B)
    c.io.in(1).valid.poke(false.B)
    c.io.out.ready.poke(false.B)
    println(s"Start:")
    println(s"\tin(0).ready=${c.io.in(0).ready.peek().litValue}, in(1).ready=${c.io.in(1).ready.peek().litValue}")
    println(s"\tout.valid=${c.io.out.valid.peek().litValue}, out.bits=${c.io.out.bits.peek().litValue}")
    c.io.in(1).valid.poke(true.B)  // Valid input 1
    c.io.in(1).bits.poke(42.U)
    c.io.out.ready.poke(true.B)
    // What do you think the output will be?
    println(s"valid input 1:")
    println(s"\tin(0).ready=${c.io.in(0).ready.peek().litValue}, in(1).ready=${c.io.in(1).ready.peek().litValue}")
    println(s"\tout.valid=${c.io.out.valid.peek().litValue}, out.bits=${c.io.out.bits.peek().litValue}")
    c.io.in(0).valid.poke(true.B)  // Valid inputs 0 and 1
    c.io.in(0).bits.poke(43.U)
    // What do you think the output will be? Which inputs will be ready?
    println(s"valid inputs 0 and 1:")
    println(s"\tin(0).ready=${c.io.in(0).ready.peek().litValue}, in(1).ready=${c.io.in(1).ready.peek().litValue}")
    println(s"\tout.valid=${c.io.out.valid.peek().litValue}, out.bits=${c.io.out.bits.peek().litValue}")
    c.io.in(1).valid.poke(false.B)  // Valid input 0
    // What do you think the output will be?
    println(s"valid input 0:")
    println(s"\tin(0).ready=${c.io.in(0).ready.peek().litValue}, in(1).ready=${c.io.in(1).ready.peek().litValue}")
    println(s"\tout.valid=${c.io.out.valid.peek().litValue}, out.bits=${c.io.out.bits.peek().litValue}")
  }
}


object ttt extends App {
  val saturate = false
  (new chisel3.stage.ChiselStage).emitVerilog(new learnclass(4))
}


