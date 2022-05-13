package RPS

import chisel3._
import chisel3.util._
import Param.Param

class ifid_bundle extends Bundle {
  val valid = Bool()
  val pc = UInt(32.W)
  val npc = UInt(32.W)
  val ir = UInt(32.W)
}

class idex_bundle extends Bundle {
  val valid = Bool()
  val pc = UInt(32.W)
  val npc = UInt(32.W)

  val r1 = UInt(32.W)
  val r2 = UInt(32.W)
  val r3 = UInt(32.W)
  val imm = UInt(32.W)
  
  val rs1 = UInt(5.W)
  val rs2 = UInt(5.W)
  val rs3 = UInt(5.W)

  val reg_write = Bool()
  val reg_write_src = reg_w_src_t()
  val reg_write_addr = UInt(5.W)

  val mem_write = Bool()
  val mem_op = mem_op_t()

  val jump = Bool()
  val branch = Bool()
  val alu_op1_src = alu_op1_src_t()
  val alu_op2_src = alu_op2_src_t()
  val alu_op = alu_op_t()
  val comp_op = comp_op_t()
  val alu_result_src = alu_result_src_t()

  val r2_src = r2_src_t()
  val tg_we = Bool()
  val ti_we = Bool()
  val to = Bool()
  val addtk = Bool()
  val tkend = Bool()

  val csrAddr = UInt(12.W)
  val csrType = csrType_t()
}

class exmm_bundle extends Bundle {
  val valid = Bool()
  val npc = UInt(32.W)

  val alu_result = UInt(32.W)
  val r2 = UInt(32.W)
  
  val mem_write = Bool()
  val mem_op = mem_op_t()

  val reg_write = Bool()
  val reg_write_src = reg_w_src_t()
  val reg_write_addr = UInt(5.W)
}

class mmwb_bundle extends Bundle {
  val valid = Bool()
  val npc = UInt(32.W)
  val alu_result = UInt(32.W)
  val mem_result = UInt(32.W)

  val reg_write = Bool()
  val reg_write_src = reg_w_src_t()
  val reg_write_addr = UInt(5.W)
}

class rpu_core(private val isaParam: Param) extends Module {
  val io = IO(new Bundle {
    val std_clk = Input(Bool())
    // boot addresses of threads
    val boot_addr = Input(Vec(isaParam.ThreadNumber, UInt(32.W)))
    // instruction memory interface
    val instr_addr = Output(UInt(32.W))
    val instr_data = Input(UInt(32.W))
    // data memory interface
    val data_we = Output(Bool())
    val data_be = Output(UInt(4.W))
    val data_addr = Output(UInt(32.W))
    val data_wdata = Output(UInt(32.W))
    val data_rdata = Input(UInt(32.W))
    // register file debug interface
    // val thread_sel = Input(UInt((log2Ceil(thread_number)).W))
    // val reg_addr = Input(UInt(5.W))
    // val reg_data = Output(UInt(32.W))
    val IMiss = Input(Bool())
    val DMiss = Input(Bool())

  })

  // thread control
  val tc = Module(new rpu_thread_control(isaParam.ThreadNumber))
  // pc group 
  val pcg = Module(new rpu_pc_group(isaParam.ThreadNumber))
  // register file group
  val regg = Module(new RegisterFileGroup(isaParam))
  // decoder
  val decoder = Module(new rpu_decoder())
  // controller
  val control = Module(new rpu_control())
  // alu
  val alu = Module(new rpu_alu())
  // comp
  val comp = Module(new rpu_comp())
  // time unit
  val tu = Module(new rpu_time_unit())

  //CSR
  val csr = Module(new CSR(isaParam))


  // IF/ID Stage Registers 
  val ifid_stage_reset = Wire(new ifid_bundle())
  ifid_stage_reset.valid := false.B
  ifid_stage_reset.pc := 0.U
  ifid_stage_reset.npc := 0.U
  ifid_stage_reset.ir := 0.U
  val ifid_stage_regs = RegInit(ifid_stage_reset)

  // ID/EX Stage Registers
  val idex_stage_reset = Wire(new idex_bundle())
  idex_stage_reset.valid := false.B 
  idex_stage_reset.pc := 0.U
  idex_stage_reset.npc := 0.U 
  idex_stage_reset.r1 := 0.U 
  idex_stage_reset.r2 := 0.U 
  idex_stage_reset.r3 := 0.U 
  idex_stage_reset.imm := 0.U 
  idex_stage_reset.rs1 := 0.U 
  idex_stage_reset.rs2 := 0.U 
  idex_stage_reset.rs3 := 0.U 
  idex_stage_reset.reg_write := false.B 
  idex_stage_reset.reg_write_src := reg_w_src_t.alu 
  idex_stage_reset.reg_write_addr := 0.U 
  idex_stage_reset.mem_write := false.B 
  idex_stage_reset.mem_op := mem_op_t.nop
  idex_stage_reset.jump := false.B 
  idex_stage_reset.branch := false.B 
  idex_stage_reset.alu_op := alu_op_t.nop 
  idex_stage_reset.alu_op1_src := alu_op1_src_t.reg 
  idex_stage_reset.alu_op2_src := alu_op2_src_t.reg 
  idex_stage_reset.comp_op := comp_op_t.nop 
  idex_stage_reset.alu_result_src := alu_result_src_t.alu
  idex_stage_reset.r2_src := r2_src_t.r2 
  idex_stage_reset.tg_we := false.B 
  idex_stage_reset.ti_we := false.B 
  idex_stage_reset.to := false.B
  idex_stage_reset.addtk := false.B 
  idex_stage_reset.tkend := false.B
  idex_stage_reset.csrAddr := 0.U
  idex_stage_reset.csrType := csrType_t.notCsr

  val idex_stage_regs = RegInit(idex_stage_reset)

  // EX/MM Stage Registers
  val exmm_stage_reset = Wire(new exmm_bundle())
  exmm_stage_reset.valid := false.B 
  exmm_stage_reset.npc := 0.U 
  exmm_stage_reset.alu_result := 0.U 
  exmm_stage_reset.r2 := 0.U 
  exmm_stage_reset.mem_write := false.B 
  exmm_stage_reset.mem_op := mem_op_t.nop
  exmm_stage_reset.reg_write := false.B 
  exmm_stage_reset.reg_write_src := reg_w_src_t.alu 
  exmm_stage_reset.reg_write_addr := 0.U 
  val exmm_stage_regs = RegInit(exmm_stage_reset)

  // MM/WB Stage Registers
  val mmwb_stage_reset = Wire(new mmwb_bundle())
  mmwb_stage_reset.valid := false.B 
  mmwb_stage_reset.npc := 0.U 
  mmwb_stage_reset.alu_result := 0.U 
  mmwb_stage_reset.mem_result := 0.U 
  mmwb_stage_reset.reg_write := false.B 
  mmwb_stage_reset.reg_write_src := reg_w_src_t.alu 
  mmwb_stage_reset.reg_write_addr := 0.U 
  val mmwb_stage_regs = RegInit(mmwb_stage_reset)


  // boot address
  pcg.io.boot_addr := io.boot_addr

  // thread id update interface
  pcg.io.thread_id_we := tc.io.thread_id_we
  pcg.io.thread_id_wdata := tc.io.thread_id_wdata
  regg.io.TID_Change_En := tc.io.thread_id_we
  regg.io.TID_Changed_ID := tc.io.thread_id_wdata

  // pc update interface
  when (tc.io.wb_pc) {
    pcg.io.npc_we := true.B 
    when (idex_stage_regs.valid) {
      pcg.io.npc_wdata := idex_stage_regs.pc 
    } .elsewhen (ifid_stage_regs.valid) {
      pcg.io.npc_wdata := ifid_stage_regs.pc 
    } .otherwise {
      pcg.io.npc_wdata := pcg.io.pc
    }
  } .elsewhen (tc.io.pc_we) {
    pcg.io.npc_we := true.B 
    when (idex_stage_regs.jump || (idex_stage_regs.branch && comp.io.result)) {
      pcg.io.npc_wdata := alu.io.result 
    } .otherwise {
      pcg.io.npc_wdata := pcg.io.pc + 4.U
    }
  } .otherwise {
    pcg.io.npc_we := false.B 
    pcg.io.npc_wdata := 0.U
  }
  
  // IF Stage
  io.instr_addr := pcg.io.pc
  // IF/ID Stage Registers
  when (tc.io.ifid_clear) {
    ifid_stage_regs := ifid_stage_reset
  } .elsewhen (tc.io.ifid_we && (io.IMiss === false.B && io.DMiss === false.B)) {
    ifid_stage_regs.valid := true.B
    ifid_stage_regs.pc := pcg.io.pc
    ifid_stage_regs.npc := pcg.io.pc + 4.U
    ifid_stage_regs.ir := io.instr_data
  } .otherwise {
    ifid_stage_regs := ifid_stage_regs
  }

  // ID Stage
  decoder.io.ir := ifid_stage_regs.ir 
  control.io.instr_type := decoder.io.instr_type
  regg.io.Raddr1 := decoder.io.rs1
  regg.io.Raddr2 := decoder.io.rs2
  regg.io.Raddr3 := decoder.io.rs3
  // ID/EX Stage Register
  when (tc.io.idex_clear) {
    idex_stage_regs := idex_stage_reset
  } .elsewhen (tc.io.idex_we && (io.IMiss === false.B && io.DMiss === false.B)) {
    idex_stage_regs.valid := ifid_stage_regs.valid
    idex_stage_regs.pc := ifid_stage_regs.pc
    idex_stage_regs.npc := ifid_stage_regs.npc
    idex_stage_regs.r1 := regg.io.Rdata1
    idex_stage_regs.r2 := regg.io.Rdata2
    idex_stage_regs.r3 := regg.io.Rdata3
    idex_stage_regs.imm := decoder.io.imm
    idex_stage_regs.rs1 := decoder.io.rs1
    idex_stage_regs.rs2 := decoder.io.rs2
    idex_stage_regs.rs3 := decoder.io.rs3

    idex_stage_regs.csrType := control.io.csrType
    idex_stage_regs.csrAddr := decoder.io.CSRAddr

    idex_stage_regs.reg_write := control.io.reg_write
    idex_stage_regs.reg_write_src := control.io.reg_write_src
    idex_stage_regs.reg_write_addr := decoder.io.rd
    idex_stage_regs.mem_write := control.io.mem_write
    idex_stage_regs.mem_op := control.io.mem_op
    idex_stage_regs.jump := control.io.jump
    idex_stage_regs.branch := control.io.branch
    idex_stage_regs.alu_op1_src := control.io.alu_op1_src
    idex_stage_regs.alu_op2_src := control.io.alu_op2_src
    idex_stage_regs.alu_op := control.io.alu_op
    idex_stage_regs.comp_op := control.io.comp_op
    idex_stage_reset.alu_result_src := control.io.alu_result_src
    idex_stage_regs.r2_src := control.io.r2_src
    idex_stage_regs.tg_we := control.io.tg_we
    idex_stage_regs.ti_we := control.io.ti_we
    idex_stage_regs.to := control.io.to
    idex_stage_regs.addtk := control.io.addtk
    idex_stage_regs.tkend := control.io.tkend
  } .otherwise {
    idex_stage_regs := idex_stage_regs
  }

  // EX Stage
  csr.io.CSRAddr := idex_stage_regs.csrAddr
  csr.io.CSRType := idex_stage_regs.csrType
  csr.io.rsData := idex_stage_regs.imm
  csr.io.RegFileData := idex_stage_regs.r1

  comp.io.op_a := idex_stage_regs.r1 
  comp.io.op_b := idex_stage_regs.r2 
  comp.io.comp_op := idex_stage_regs.comp_op
  
  when (idex_stage_regs.alu_op1_src === alu_op1_src_t.pc) {
    alu.io.op_a := idex_stage_regs.pc 
  } .otherwise {
    alu.io.op_a := idex_stage_regs.r1
  }
  when (idex_stage_regs.alu_op2_src === alu_op2_src_t.imm) {
    alu.io.op_b := idex_stage_regs.imm 
  } .otherwise {
    alu.io.op_b := idex_stage_regs.r2
  }
  alu.io.operation := idex_stage_regs.alu_op
//  alu.io.csrResult := 0.U
  alu.io.csrResult := csr.io.CSROut//CSR

  tu.io.std_clk := io.std_clk
  tu.io.ti_we := idex_stage_regs.ti_we 
  tu.io.ti_wdata := idex_stage_regs.r1 
  tu.io.tg_we := idex_stage_regs.tg_we
  tu.io.tg_wdata := idex_stage_regs.r1 

  val ts = RegInit(0.U(32.W))
  when (idex_stage_regs.to && tc.io.exmm_we) {
    ts := tu.io.ti 
  } .otherwise {
    ts := ts
  }

  val to_stall = Wire(Bool())
  to_stall := idex_stage_regs.to && tu.io.ti < idex_stage_regs.r1
  val data_stall = Wire(Bool())
  data_stall := (idex_stage_regs.reg_write && idex_stage_regs.reg_write_addr =/= 0.U &&
                  (decoder.io.rs1 === idex_stage_regs.reg_write_addr) ||
                  (decoder.io.rs2 === idex_stage_regs.reg_write_addr) ||
                  (decoder.io.rs3 === idex_stage_regs.reg_write_addr)) ||
                (exmm_stage_regs.reg_write && exmm_stage_regs.reg_write_addr =/= 0.U &&
                  (decoder.io.rs1 === exmm_stage_regs.reg_write_addr) ||
                  (decoder.io.rs2 === exmm_stage_regs.reg_write_addr) ||
                  (decoder.io.rs3 === exmm_stage_regs.reg_write_addr)) ||
                (mmwb_stage_regs.reg_write && mmwb_stage_regs.reg_write_addr =/= 0.U &&
                  (decoder.io.rs1 === mmwb_stage_regs.reg_write_addr) ||
                  (decoder.io.rs2 === mmwb_stage_regs.reg_write_addr) ||
                  (decoder.io.rs3 === mmwb_stage_regs.reg_write_addr))
  val control_stall = Wire(Bool())
  control_stall := idex_stage_regs.jump || (idex_stage_regs.branch && comp.io.result)
  
  tc.io.ti := tu.io.ti
  tc.io.to_stall := to_stall
  tc.io.data_stall := data_stall
  tc.io.control_stall := control_stall

  tc.io.tkend := idex_stage_regs.tkend 
  tc.io.addtk := idex_stage_regs.addtk 
  tc.io.time := idex_stage_regs.r1 
  tc.io.tid := idex_stage_regs.r2


  // EX/MM Stage Register
  when (tc.io.exmm_clear) {
    exmm_stage_regs := exmm_stage_reset
  } .elsewhen (tc.io.exmm_we && (io.IMiss === false.B && io.DMiss === false.B)) {
    exmm_stage_regs.valid := idex_stage_regs.valid
    exmm_stage_regs.npc := idex_stage_regs.npc
    switch (idex_stage_regs.alu_result_src) {
      is (alu_result_src_t.alu) {
        exmm_stage_regs.alu_result := alu.io.result
      }
      is (alu_result_src_t.ts) {
        exmm_stage_regs.alu_result := ts
      }
      is (alu_result_src_t.ti) {
        exmm_stage_regs.alu_result := tu.io.ti
      }
    }
    when (idex_stage_regs.r2_src === r2_src_t.r3) {
      exmm_stage_regs.r2 := idex_stage_regs.r3 
    } .otherwise {
      exmm_stage_regs.r2 := idex_stage_regs.r2
    }
    exmm_stage_regs.mem_write := idex_stage_regs.mem_write
    exmm_stage_regs.mem_op := idex_stage_regs.mem_op
    exmm_stage_regs.reg_write := idex_stage_regs.reg_write
    exmm_stage_regs.reg_write_src := idex_stage_regs.reg_write_src
    exmm_stage_regs.reg_write_addr := idex_stage_regs.reg_write_addr
  } .otherwise {
    exmm_stage_regs := exmm_stage_regs
  }

  // MM Stage
  // TODO: THIS DOES NOT CONSIDER ALIGNED MEMORY ACCESS
  // You can add -strict-aligned label to gcc to satisfy this needs
  when (exmm_stage_regs.mem_write) {
    io.data_we := true.B
    io.data_wdata := exmm_stage_regs.r2
    io.data_addr := 0.U
    io.data_be := 0.U
    switch (exmm_stage_regs.mem_op) {
      is (mem_op_t.sb) {
        io.data_addr := Cat(exmm_stage_regs.alu_result(31, 2), 0.U(2.W))
        io.data_be := 1.U(4.W) << exmm_stage_regs.alu_result(1, 0)
      }
      is (mem_op_t.sh) {
        io.data_addr := Cat(exmm_stage_regs.alu_result(31, 2), 0.U(2.W))
        when (exmm_stage_regs.alu_result(1)) {
          io.data_be := 12.U(4.W)
        } .otherwise {
          io.data_be := 3.U(4.W)
        }
      }
      is (mem_op_t.sw) {
        io.data_addr := Cat(exmm_stage_regs.alu_result(31, 2), 0.U(2.W))
        io.data_be := 15.U(4.W)
      }
    }
  } .otherwise {
    io.data_we := false.B
    io.data_wdata := 0.U
    io.data_be := 0.U 
    io.data_addr := Cat(exmm_stage_regs.alu_result(31, 2), 0.U(2.W))
  }
  // MM/WB
  when (tc.io.mmwb_clear) {
    mmwb_stage_regs := mmwb_stage_reset
  } .elsewhen (tc.io.mmwb_we && (io.IMiss === false.B && io.DMiss === false.B)) {
    mmwb_stage_regs.valid := exmm_stage_regs.valid 
    mmwb_stage_regs.npc := exmm_stage_regs.npc 
    mmwb_stage_regs.alu_result := exmm_stage_regs.alu_result
    mmwb_stage_regs.mem_result := 0.U
    switch (exmm_stage_regs.mem_op) {
      is (mem_op_t.lb) {
        mmwb_stage_regs.mem_result := Cat(Fill(24, io.data_rdata(7)), io.data_rdata(7, 0))
      }
      is (mem_op_t.lbu) {
        mmwb_stage_regs.mem_result := Cat(0.U(24.W), io.data_rdata(7, 0))
      }
      is (mem_op_t.lh) {
        mmwb_stage_regs.mem_result := Cat(Fill(16, io.data_rdata(15)), io.data_rdata(15, 0))
      }
      is (mem_op_t.lhu) {
        mmwb_stage_regs.mem_result := Cat(0.U(16.W), io.data_rdata(15, 0))
      }
      is (mem_op_t.lw) {
        mmwb_stage_regs.mem_result := io.data_rdata
      }
    }
    mmwb_stage_regs.reg_write := exmm_stage_regs.reg_write
    mmwb_stage_regs.reg_write_src := exmm_stage_regs.reg_write_src
    mmwb_stage_regs.reg_write_addr := exmm_stage_regs.reg_write_addr
  } .otherwise {
    mmwb_stage_regs := mmwb_stage_regs
  }

  regg.io.Write_En := mmwb_stage_regs.reg_write
  regg.io.Waddr := mmwb_stage_regs.reg_write_addr
  regg.io.Wdata := mmwb_stage_regs.npc
  when (mmwb_stage_regs.reg_write) {
    switch(mmwb_stage_regs.reg_write_src) {
      is (reg_w_src_t.mem) {
        regg.io.Wdata := mmwb_stage_regs.mem_result
      }
      is (reg_w_src_t.alu) {
        regg.io.Wdata := mmwb_stage_regs.alu_result
      }
      is (reg_w_src_t.pc4) {
        regg.io.Wdata := mmwb_stage_regs.npc
      }
    }
  }
  
}

