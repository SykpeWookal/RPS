package RPSCore

import chisel3._ 
import chisel3.util._ 

class rpu_control extends Module {
  val io = IO(new Bundle{
    val instr_type = Input(rv_instr_t())
    val jump = Output(Bool())
    val branch = Output(Bool())
    val alu_op1_src = Output(alu_op1_src_t())
    val alu_op2_src = Output(alu_op2_src_t())
    val alu_op = Output(alu_op_t())
    val alu_result_src = Output(alu_result_src_t())
    val comp_op = Output(comp_op_t())
    val r2_src = Output(r2_src_t())
    val tg_we = Output(Bool())
    val ti_we = Output(Bool())
    val to = Output(Bool())
    val addtk = Output(Bool())
    val tkend = Output(Bool())

    val mem_write = Output(Bool())
    val mem_op = Output(mem_op_t())

    val reg_write = Output(Bool())
    val reg_write_src = Output(reg_w_src_t())

    val csrType = Output(csrType_t())
  })
  when(io.instr_type === rv_instr_t.csrrc){
    io.csrType := csrType_t.csrrc
  }.elsewhen(io.instr_type === rv_instr_t.csrrs){
    io.csrType := csrType_t.csrrc
  }.elsewhen(io.instr_type === rv_instr_t.csrrw){
    io.csrType := csrType_t.csrrw
  }.elsewhen(io.instr_type === rv_instr_t.csrrci){
    io.csrType := csrType_t.csrrci
  }.elsewhen(io.instr_type === rv_instr_t.csrrsi){
    io.csrType := csrType_t.csrrsi
  }.elsewhen(io.instr_type === rv_instr_t.csrrwi){
    io.csrType := csrType_t.csrrwi
  }.otherwise{
    io.csrType := csrType_t.notCsr
  }

  io.jump := io.instr_type === rv_instr_t.jalr | io.instr_type === rv_instr_t.jal
  io.branch :=  io.instr_type === rv_instr_t.beq |
                io.instr_type === rv_instr_t.bne |
                io.instr_type === rv_instr_t.blt |
                io.instr_type === rv_instr_t.bge |
                io.instr_type === rv_instr_t.bltu |
                io.instr_type === rv_instr_t.bgeu
  when (io.instr_type === rv_instr_t.auipc |
        io.instr_type === rv_instr_t.jal |
        io.instr_type === rv_instr_t.beq |
        io.instr_type === rv_instr_t.bne |
        io.instr_type === rv_instr_t.blt |
        io.instr_type === rv_instr_t.bge |
        io.instr_type === rv_instr_t.bltu |
        io.instr_type === rv_instr_t.bgeu) {
    io.alu_op1_src := alu_op1_src_t.pc
  } .otherwise {
    io.alu_op1_src :=  alu_op1_src_t.reg
  }
  when (io.instr_type === rv_instr_t.add |
        io.instr_type === rv_instr_t.sub |
        io.instr_type === rv_instr_t.sll |
        io.instr_type === rv_instr_t.slt |
        io.instr_type === rv_instr_t.sltu |
        io.instr_type === rv_instr_t.xor |
        io.instr_type === rv_instr_t.srl |
        io.instr_type === rv_instr_t.sra |
        io.instr_type === rv_instr_t.or |
        io.instr_type === rv_instr_t.add) {
    io.alu_op2_src := alu_op2_src_t.reg
  } .otherwise {
    io.alu_op2_src :=  alu_op2_src_t.imm
  }
  // alu_op
  io.alu_op := alu_op_t.nop 
  switch (io.instr_type) {
    is (rv_instr_t.lb) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.lh) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.lw) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.lbu) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.lhu) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.sb) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.sh) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.sw) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.lui) {
      io.alu_op := alu_op_t.lui
    }
    is (rv_instr_t.jal) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.jalr) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.auipc) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.add) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.addi) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.beq) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.bne) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.blt) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.bge) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.bltu) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.bgeu) {
      io.alu_op := alu_op_t.add
    }
    is (rv_instr_t.sub) {
      io.alu_op := alu_op_t.sub
    }
    is (rv_instr_t.slt) {
      io.alu_op := alu_op_t.lts
    }
    is (rv_instr_t.slti) {
      io.alu_op := alu_op_t.lts
    }
    is (rv_instr_t.sltu) {
      io.alu_op := alu_op_t.ltu
    }
    is (rv_instr_t.sltiu) {
      io.alu_op := alu_op_t.ltu
    }
    is (rv_instr_t.xor) {
      io.alu_op := alu_op_t.xor
    }
    is (rv_instr_t.xori) {
      io.alu_op := alu_op_t.xor
    }
    is (rv_instr_t.or) {
      io.alu_op := alu_op_t.or
    }
    is (rv_instr_t.ori) {
      io.alu_op := alu_op_t.or
    }
    is (rv_instr_t.and) {
      io.alu_op := alu_op_t.and
    }
    is (rv_instr_t.andi) {
      io.alu_op := alu_op_t.and
    }
    is (rv_instr_t.sll) {
      io.alu_op := alu_op_t.sl
    }
    is (rv_instr_t.slli) {
      io.alu_op := alu_op_t.sl
    }
    is (rv_instr_t.srl) {
      io.alu_op := alu_op_t.srl
    }
    is (rv_instr_t.srli) {
      io.alu_op := alu_op_t.srl
    }
    is (rv_instr_t.sra) {
      io.alu_op := alu_op_t.sra
    }
    is (rv_instr_t.srai) {
      io.alu_op := alu_op_t.sra
    }
    is(rv_instr_t.csrrw){
      io.alu_op := alu_op_t.csr
    }
    is(rv_instr_t.csrrs){
      io.alu_op := alu_op_t.csr
    }
    is(rv_instr_t.csrrc){
      io.alu_op := alu_op_t.csr
    }
    is(rv_instr_t.csrrwi){
      io.alu_op := alu_op_t.csr
    }
    is(rv_instr_t.csrrsi){
      io.alu_op := alu_op_t.csr
    }
    is(rv_instr_t.csrrci){
      io.alu_op := alu_op_t.csr
    }

  }
  // alu_result_src
  when (io.instr_type === rv_instr_t.getts) {
    io.alu_result_src := alu_result_src_t.ts 
  } .elsewhen (io.instr_type === rv_instr_t.getti) {
    io.alu_result_src := alu_result_src_t.ti
  } .otherwise {
    io.alu_result_src := alu_result_src_t.alu 
  }
  // comp_op
  io.comp_op := comp_op_t.nop
  switch (io.instr_type) {
    is (rv_instr_t.beq) {
      io.comp_op := comp_op_t.eq
    }
    is (rv_instr_t.bne) {
      io.comp_op := comp_op_t.ne
    }
    is (rv_instr_t.blt) {
      io.comp_op := comp_op_t.lt
    }
    is (rv_instr_t.bge) {
      io.comp_op := comp_op_t.ge
    }
    is (rv_instr_t.bltu) {
      io.comp_op := comp_op_t.ltu
    }
    is (rv_instr_t.bgeu) {
      io.comp_op := comp_op_t.geu
    }
  }
  // r2_src
  when (io.instr_type === rv_instr_t.ttoat) {
    io.r2_src := r2_src_t.r3
  } .otherwise {
    io.r2_src := r2_src_t.r2 
  }
  io.tg_we := io.instr_type === rv_instr_t.settg
  io.ti_we := io.instr_type === rv_instr_t.setti
  io.to := io.instr_type === rv_instr_t.ttiat |
           io.instr_type === rv_instr_t.ttoat |
           io.instr_type === rv_instr_t.delay
  io.addtk := io.instr_type === rv_instr_t.addtk
  io.tkend := io.instr_type === rv_instr_t.tkend
  io.mem_write := io.instr_type === rv_instr_t.sb |
                  io.instr_type === rv_instr_t.sh |
                  io.instr_type === rv_instr_t.sw |
                  io.instr_type === rv_instr_t.ttoat
  io.mem_op := mem_op_t.nop 
  switch (io.instr_type) {
    is (rv_instr_t.sb) {
      io.mem_op := mem_op_t.sb
    }
    is (rv_instr_t.sh) {
      io.mem_op := mem_op_t.sh
    }
    is (rv_instr_t.sw) {
      io.mem_op := mem_op_t.sw
    }
    is (rv_instr_t.ttoat) {
      io.mem_op := mem_op_t.sw
    }
    is (rv_instr_t.lb) {
      io.mem_op := mem_op_t.lb
    }
    is (rv_instr_t.lbu) {
      io.mem_op := mem_op_t.lbu
    }
    is (rv_instr_t.lh) {
      io.mem_op := mem_op_t.lh
    }
    is (rv_instr_t.lhu) {
      io.mem_op := mem_op_t.lhu
    }
    is (rv_instr_t.lw) {
      io.mem_op := mem_op_t.lw
    }
    is (rv_instr_t.ttiat) {
      io.mem_op := mem_op_t.lw
    }
  }
  io.reg_write := io.instr_type === rv_instr_t.lui |
                  io.instr_type === rv_instr_t.auipc |
                  io.instr_type === rv_instr_t.addi |
                  io.instr_type === rv_instr_t.slti |
                  io.instr_type === rv_instr_t.sltu |
                  io.instr_type === rv_instr_t.xori |
                  io.instr_type === rv_instr_t.ori |
                  io.instr_type === rv_instr_t.andi |
                  io.instr_type === rv_instr_t.slli |
                  io.instr_type === rv_instr_t.srli |
                  io.instr_type === rv_instr_t.srai |
                  io.instr_type === rv_instr_t.add |
                  io.instr_type === rv_instr_t.sub |
                  io.instr_type === rv_instr_t.sll |
                  io.instr_type === rv_instr_t.slt |
                  io.instr_type === rv_instr_t.sltu |
                  io.instr_type === rv_instr_t.xor |
                  io.instr_type === rv_instr_t.srl |
                  io.instr_type === rv_instr_t.sra |
                  io.instr_type === rv_instr_t.or |
                  io.instr_type === rv_instr_t.and |
                  io.instr_type === rv_instr_t.lb |
                  io.instr_type === rv_instr_t.lh |
                  io.instr_type === rv_instr_t.lw |
                  io.instr_type === rv_instr_t.lbu |
                  io.instr_type === rv_instr_t.lhu |
                  io.instr_type === rv_instr_t.jalr |
                  io.instr_type === rv_instr_t.jal |
                  io.instr_type === rv_instr_t.getti |
                  io.instr_type === rv_instr_t.getts |
                  io.instr_type === rv_instr_t.ttiat |
                  io.instr_type === rv_instr_t.csrrw |
                  io.instr_type === rv_instr_t.csrrs |
                  io.instr_type === rv_instr_t.csrrc |
                  io.instr_type === rv_instr_t.csrrwi |
                  io.instr_type === rv_instr_t.csrrsi |
                  io.instr_type === rv_instr_t.csrrci
  when (io.instr_type === rv_instr_t.lb |
        io.instr_type === rv_instr_t.lh |
        io.instr_type === rv_instr_t.lw |
        io.instr_type === rv_instr_t.lbu |
        io.instr_type === rv_instr_t.lhu |
        io.instr_type === rv_instr_t.ttiat) {
    io.reg_write_src := reg_w_src_t.mem
  } .elsewhen (io.instr_type === rv_instr_t.jalr |
                io.instr_type === rv_instr_t.jal) {
    io.reg_write_src := reg_w_src_t.pc4
  } .otherwise {
    io.reg_write_src := reg_w_src_t.alu 
  }
}