
package RPS

import chisel3._
import chisel3.util._

import RPS.Constants._

class rpu_thread_control(thread_number: Int) extends Module {
  val io = IO(new Bundle {
    // stall interface
    val to_stall = Input(Bool())
    val data_stall = Input(Bool())
    val control_stall = Input(Bool())
    // threads add interface
    val tkend = Input(Bool())
    val addtk = Input(Bool())
    val time = Input(UInt(32.W))
    val tid = Input(UInt(32.W))
    // system time
    val ti = Input(UInt(32.W))
    // pc update control
    val wb_pc = Output(Bool())
    val pc_we = Output(Bool())
    // pipeline control
    val ifid_clear = Output(Bool())
    val ifid_we = Output(Bool())
    val idex_clear = Output(Bool())
    val idex_we = Output(Bool())
    val exmm_clear = Output(Bool())
    val exmm_we = Output(Bool())
    val mmwb_clear = Output(Bool())
    val mmwb_we = Output(Bool())
    // thread id update interface
    val thread_id_we = Output(Bool())
    val thread_id_wdata = Output(UInt((log2Ceil(thread_number)).W))
  })

  val tt_queue = Mem(TABLE_SIZE, UInt(64.W))
  val tt_start = RegInit(0.U((log2Ceil(TABLE_SIZE)).W))
  val tt_end = RegInit(0.U((log2Ceil(TABLE_SIZE)).W))
  
  val run :: wait_mem :: wait_wb :: wid :: Nil = Enum(4)
  val state = RegInit(run)
  val tkend_switch = RegInit(false.B)

  tt_start := tt_start
  tt_end := tt_end
  when (io.addtk && tt_end + 1.U =/= tt_start) {
    tt_queue(tt_end) := Cat(io.time, io.tid)
    tt_end := (tt_end + 1.U) % TABLE_SIZE.U
  } .elsewhen (state === wid && tt_start =/= tt_end) {
    tt_start := (tt_start + 1.U) % TABLE_SIZE.U
  }

  tkend_switch := tkend_switch
  switch (state) {
    is (run) {
      when (io.tkend) {
        tkend_switch := true.B 
        state := wait_mem
      } .elsewhen (tt_start =/= tt_end && tt_queue(tt_start)(63, 32) < io.ti) {
        state := wait_mem
      } .otherwise {
        state := run
      }
    }
    is (wait_mem) {
      state := wait_wb
    }
    is (wait_wb) {
      state := wid
    }
    is (wid) {
      state := run
    }
  }

  when (state === wid) {
    io.wb_pc := false.B
    io.pc_we := false.B
    io.ifid_clear := false.B 
    io.ifid_we := false.B 
    io.idex_clear := false.B 
    io.idex_we := false.B 
    io.exmm_clear := false.B 
    io.exmm_we := false.B 
    io.mmwb_clear := false.B 
    io.mmwb_we := false.B 
    io.thread_id_we := true.B 
    io.thread_id_wdata := tt_queue(tt_start)(31, 0)
  } .elsewhen (state === wait_wb) {
    io.wb_pc := false.B
    io.pc_we := false.B
    io.ifid_clear := false.B 
    io.ifid_we := false.B 
    io.idex_clear := false.B 
    io.idex_we := false.B 
    io.exmm_clear := false.B 
    io.exmm_we := false.B 
    io.mmwb_clear := true.B 
    io.mmwb_we := false.B 
    io.thread_id_we := false.B 
    io.thread_id_wdata := 0.U
  } .elsewhen (state === wait_mem) {
    io.wb_pc := true.B
    io.pc_we := false.B
    io.ifid_clear := true.B 
    io.ifid_we := false.B 
    io.idex_clear := true.B 
    io.idex_we := false.B 
    io.exmm_clear := true.B 
    io.exmm_we := false.B 
    io.mmwb_clear := false.B 
    io.mmwb_we := true.B 
    io.thread_id_we := false.B 
    io.thread_id_wdata := 0.U
  } .elsewhen (io.control_stall) {
    io.wb_pc := false.B
    io.pc_we := true.B
    io.ifid_clear := true.B 
    io.ifid_we := false.B 
    io.idex_clear := true.B 
    io.idex_we := false.B 
    io.exmm_clear := false.B 
    io.exmm_we := true.B 
    io.mmwb_clear := false.B 
    io.mmwb_we := true.B 
    io.thread_id_we := false.B 
    io.thread_id_wdata := 0.U
  } .otherwise {
    io.wb_pc := false.B
    io.pc_we := !io.data_stall
    io.ifid_clear := false.B 
    io.ifid_we := !io.data_stall 
    io.idex_clear := io.data_stall
    io.idex_we := true.B 
    io.exmm_clear := false.B 
    io.exmm_we := true.B 
    io.mmwb_clear := false.B 
    io.mmwb_we := true.B 
    io.thread_id_we := false.B 
    io.thread_id_wdata := 0.U
  }
}