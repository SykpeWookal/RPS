
package RPS

import chisel3._
import chisel3.util._

class rpu_time_unit() extends Module {
  val io = IO(new Bundle {
    val std_clk = Input(Bool())
    // ti set interface
    val ti_we = Input(Bool())
    val ti_wdata = Input(UInt(32.W))
    // tg set interface
    val tg_we = Input(Bool())
    val tg_wdata = Input(UInt(32.W))
    // ti read interface
    val ti = Output(UInt(32.W))
  })
  
  val tick = RegInit(false.B)
  when (io.std_clk === true.B && tick === false.B) {
    tick := true.B 
  } .elsewhen (io.std_clk === false.B) {
    tick := false.B
  } .otherwise {
    tick := tick
  }

  val ti = RegInit(0.U(32.W))
  val tg = RegInit(0.U(32.W))
  val cnt = RegInit(0.U(32.W))

  when (tick) {
    cnt := cnt + 1.U
    tick := false.B
  } .otherwise {
    cnt := cnt
  }

  when (io.ti_we) {
    ti := io.ti_wdata
  } .elsewhen (cnt === tg) {
    ti := ti + 1.U
  } .otherwise {
    ti := ti 
  }

  when (io.tg_we) {
    tg := io.tg_wdata
  } .otherwise {
    tg := tg
  }

  io.ti := ti
}