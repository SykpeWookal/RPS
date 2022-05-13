package RPS

import chisel3._ 
import chisel3.util._ 

class rpu_alu extends Module {
  val io = IO(new Bundle{
    val op_a = Input(UInt(32.W))
    val op_b = Input(UInt(32.W))
    val csrResult = Input(UInt(32.W))
    val operation = Input(alu_op_t())
    val result = Output(UInt(32.W))
  })

  io.result := 0.U
  switch(io.operation) {
    is(alu_op_t.add) {
      io.result := io.op_a + io.op_b
    }
    is(alu_op_t.sub) {
      io.result := io.op_a - io.op_b
    }
    is(alu_op_t.and) {
      io.result := io.op_a & io.op_b
    }
    is(alu_op_t.or) {
      io.result := io.op_a | io.op_b
    }
    is(alu_op_t.xor) {
      io.result := io.op_a ^ io.op_b
    }
    is(alu_op_t.sl) {
      io.result := io.op_a << io.op_b(4, 0)
    }
    is(alu_op_t.sra) {
      io.result := (io.op_a.asSInt >> io.op_b(4, 0)).asUInt
    }
    is(alu_op_t.srl) {
      io.result := io.op_a >> io.op_b(4, 0)
    }
    is(alu_op_t.lui) {
      io.result := io.op_b
    }
    is(alu_op_t.lts) {
      io.result := io.op_a.asSInt < io.op_b.asSInt
    }
    is(alu_op_t.ltu) {
      io.result := io.op_a < io.op_b
    }
    is(alu_op_t.csr){  //CSR类型直接输出，复用后面的数据通路
      io.result := io.csrResult
    }
    is(alu_op_t.nop) {
      io.result := BigInt("DEADBEEF", 16).U
    }
  }
}

class rpu_comp extends Module {
  val io = IO(new Bundle{
    val comp_op = Input(comp_op_t())
    val op_a = Input(UInt(32.W))
    val op_b = Input(UInt(32.W))
    val result = Output(Bool())
  })

  io.result := 0.U
  switch(io.comp_op) {
    is(comp_op_t.eq) {
      io.result := io.op_a === io.op_b
    }
    is(comp_op_t.ne) {
      io.result := io.op_a =/= io.op_b
    }
    is(comp_op_t.lt) {
      io.result := io.op_a.asSInt < io.op_b.asSInt
    }
    is(comp_op_t.ltu) {
      io.result := io.op_a < io.op_b
    }
    is(comp_op_t.ge) {
      io.result := io.op_a.asSInt >= io.op_b.asSInt
    }
    is(comp_op_t.geu) {
      io.result := io.op_a >= io.op_b
    }
  }
}