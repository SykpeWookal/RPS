
package RPSCore

import chisel3._
import chisel3.util._

class rpu_pc_group(thread_number: Int) extends Module {
  val io = IO(new Bundle {
    // boot address setup
    val boot_addr = Input(Vec(thread_number, UInt(32.W)))
    // thread id update interface
    val thread_id_we = Input(Bool())
    val thread_id_wdata = Input(UInt((log2Ceil(thread_number)).W))
    // pc update interface
    val npc_we = Input(Bool())
    val npc_wdata = Input(UInt(32.W))
    // read interface
    val pc = Output(UInt(32.W))
  })
  
  val vec_values = VecInit(Seq.fill(thread_number) { 0.U(32.W) })
  for (i <- 0 to thread_number - 1) {
    vec_values(i) := io.boot_addr(i)
  }
  val pc_group = RegInit(vec_values)

  val thread_id = Reg(UInt((log2Ceil(thread_number)).W))

  when(io.thread_id_we && io.thread_id_wdata < thread_number.U) {
    thread_id := io.thread_id_wdata
  } .elsewhen(io.npc_we) {
      pc_group(thread_id) := io.npc_wdata
  }
  io.pc := pc_group(thread_id)
}