package RPSCore

import chisel3._ 
import chisel3.util._ 

import RPSCore.Constants._

class rpu_decoder extends Module {
  val io = IO(new Bundle{
    val ir = Input(UInt(32.W))
    val instr_type = Output(rv_instr_t())
    val rs1 = Output(UInt(5.W))
    val rs2 = Output(UInt(5.W))
    val rs3 = Output(UInt(5.W))
    val rd = Output(UInt(5.W))
    val imm = Output(UInt(32.W))

    //val CSRType = Output(csrType_t())  //在CU里生成
    val CSRAddr = Output(UInt(12.W))
  })

  //io.CSRType := csrType_t.notCsr
  io.CSRAddr := io.ir(31,20)

  io.instr_type := rv_instr_t.nop
  switch(io.ir(6, 0)) {
    is (OPCODE_LUI.U) {
      io.instr_type := rv_instr_t.lui
    }
    is (OPCODE_AUIPC.U) {
      io.instr_type := rv_instr_t.auipc
    }
    is (OPCODE_JAL.U) {
      io.instr_type := rv_instr_t.jal
    }
    is (OPCODE_JALR.U) {
      io.instr_type := rv_instr_t.jalr
    }
    is (OPCODE_OPIMM.U) {
      switch(io.ir(14, 12)) {
        is (0.U) {
          io.instr_type := rv_instr_t.addi
        }
        is (1.U) {
          io.instr_type := rv_instr_t.slli
        }
        is (2.U) {
          io.instr_type := rv_instr_t.slti
        }
        is (3.U) {
          io.instr_type := rv_instr_t.sltiu
        }
        is (4.U) {
          io.instr_type := rv_instr_t.xori
        }
        is (5.U) {
          when (io.ir(31, 25) === 0.U) {
            io.instr_type := rv_instr_t.srli
          } .elsewhen (io.ir(31, 25) === 32.U) {
            io.instr_type := rv_instr_t.srai
          }
        }
        is (6.U) {
          io.instr_type := rv_instr_t.ori
        }
        is (7.U) {
          io.instr_type := rv_instr_t.andi
        }
      }
    }
    is (OPCODE_OP.U) {
      switch(io.ir(14, 12)) {
        is (0.U) {
          when (io.ir(31, 25) === 0.U) {
            io.instr_type := rv_instr_t.add
          } .elsewhen (io.ir(31, 25) === 32.U) {
            io.instr_type := rv_instr_t.sub
          }
        }
        is (1.U) {
          io.instr_type := rv_instr_t.sll
        }
        is (2.U) {
          io.instr_type := rv_instr_t.slt
        }
        is (3.U) {
          io.instr_type := rv_instr_t.sltu
        }
        is (4.U) {
          io.instr_type := rv_instr_t.xor
        }
        is (5.U) {
          when (io.ir(31, 25) === 0.U) {
            io.instr_type := rv_instr_t.srl
          } .elsewhen (io.ir(31, 25) === 32.U) {
            io.instr_type := rv_instr_t.sra
          }
        }
        is (6.U) {
          io.instr_type := rv_instr_t.or
        }
        is (7.U) {
          io.instr_type := rv_instr_t.and
        }
      }
    }
    is (OPCODE_LOAD.U) {
      switch(io.ir(14, 12)) {
        is (0.U) {
          io.instr_type := rv_instr_t.lb
        }
        is (1.U) {
          io.instr_type := rv_instr_t.lh
        }
        is (2.U) {
          io.instr_type := rv_instr_t.lw
        }
        is (4.U) {
          io.instr_type := rv_instr_t.lbu
        }
        is (5.U) {
          io.instr_type := rv_instr_t.lhu
        }
      }
    }
    is (OPCODE_STORE.U) {
      switch(io.ir(14, 12)) {
        is (0.U) {
          io.instr_type := rv_instr_t.sb
        }
        is (1.U) {
          io.instr_type := rv_instr_t.sh
        }
        is (2.U) {
          io.instr_type := rv_instr_t.sw
        }
      }
    }
    is (OPCODE_BRANCH.U) {
      switch(io.ir(14, 12)) {
        is (0.U) {
          io.instr_type := rv_instr_t.beq
        }
        is (1.U) {
          io.instr_type := rv_instr_t.bne
        }
        is (4.U) {
          io.instr_type := rv_instr_t.blt
        }
        is (5.U) {
          io.instr_type := rv_instr_t.bge
        }
        is (6.U) {
          io.instr_type := rv_instr_t.bltu
        }
        is (7.U) {
          io.instr_type := rv_instr_t.bgeu
        }
      }
    }
    is (OPCODE_CUSTOM0.U) {
      switch(io.ir(14, 12)) {
        is (0.U) {
          when (io.ir(31, 25) === 0.U) {
            io.instr_type := rv_instr_t.settg
          } .elsewhen (io.ir(31, 25) === 1.U) {
            io.instr_type := rv_instr_t.setti
          } .elsewhen (io.ir(31, 25) === 1.U) {
            io.instr_type := rv_instr_t.getti
          } .elsewhen (io.ir(31, 25) === 1.U) {
            io.instr_type := rv_instr_t.getts
          }
        }
        is (1.U) {
          when (io.ir(31, 25) === 0.U) {
            io.instr_type := rv_instr_t.ttiat
          } .elsewhen (io.ir(31, 25) === 1.U) {
            io.instr_type := rv_instr_t.ttoat
          }
        }
        is (2.U) {
          when (io.ir(31, 25) === 0.U) {
            io.instr_type := rv_instr_t.delay
          }
        }
        is (3.U) {
          when (io.ir(31, 25) === 0.U) {
            io.instr_type := rv_instr_t.tkend
          } .elsewhen (io.ir(31, 25) === 1.U) {
            io.instr_type := rv_instr_t.addtk
          }
        }
      }
    }
    is(OPCODE_SYSTEM.U){  //CSR
      switch(io.ir(14,12)){
        is(1.U){
          //io.CSRType := csrType_t.csrrw
          io.instr_type := rv_instr_t.csrrw
        }
        is(2.U){
          //io.CSRType := csrType_t.csrrs
          io.instr_type := rv_instr_t.csrrs
        }
        is(3.U){
          //io.CSRType := csrType_t.csrrc
          io.instr_type := rv_instr_t.csrrc
        }
        is(5.U){
          //io.CSRType := csrType_t.csrrwi
          io.instr_type := rv_instr_t.csrrwi
        }
        is(6.U){
          //io.CSRType := csrType_t.csrrsi
          io.instr_type := rv_instr_t.csrrsi
        }
        is(7.U){
          //io.CSRType := csrType_t.csrrci
          io.instr_type := rv_instr_t.csrrci
        }
      }
    }
  }


  io.rs1 := io.ir(19, 15)
  io.rs2 := io.ir(24, 20)
  io.rd := io.ir(11, 7)
  when (io.instr_type === rv_instr_t.ttoat) {
    io.rs3 := io.rd
  } .otherwise {
    io.rs3 := 0.U
  }

  io.imm := BigInt("deadbeef", 16).U
  when (io.instr_type === rv_instr_t.lui |
        io.instr_type === rv_instr_t.auipc) {
    io.imm := io.ir & BigInt("fffff000", 16).U
  } .elsewhen (io.instr_type === rv_instr_t.jal) {
    io.imm := Cat(Fill(12, io.ir(31)), io.ir(19, 12), io.ir(20), io.ir(30, 21), 0.U(1.W))
  } .elsewhen (io.instr_type === rv_instr_t.jalr) {
    io.imm := Cat(Fill(21, io.ir(31)), io.ir(31, 20))
  } .elsewhen (io.instr_type === rv_instr_t.beq |
               io.instr_type === rv_instr_t.bne |
               io.instr_type === rv_instr_t.blt |
               io.instr_type === rv_instr_t.bge |
               io.instr_type === rv_instr_t.bltu |
               io.instr_type === rv_instr_t.bgeu) {
    io.imm := Cat(Fill(20, io.ir(31)), io.ir(7), io.ir(30, 25), io.ir(11, 8), 0.U(1.W))
  } .elsewhen (io.instr_type === rv_instr_t.lb |
               io.instr_type === rv_instr_t.lh |
               io.instr_type === rv_instr_t.lw |
               io.instr_type === rv_instr_t.lbu |
               io.instr_type === rv_instr_t.lhu |
               io.instr_type === rv_instr_t.addi |
               io.instr_type === rv_instr_t.slti |
               io.instr_type === rv_instr_t.sltiu |
               io.instr_type === rv_instr_t.xori |
               io.instr_type === rv_instr_t.ori |
               io.instr_type === rv_instr_t.andi |
               io.instr_type === rv_instr_t.slli |
               io.instr_type === rv_instr_t.srli |
               io.instr_type === rv_instr_t.srai) {
    io.imm := Cat(Fill(21, io.ir(31)), io.ir(30, 20))
  } .elsewhen (io.instr_type === rv_instr_t.sb |
               io.instr_type === rv_instr_t.sh |
               io.instr_type === rv_instr_t.sw) {
    io.imm := Cat(Fill(21, io.ir(31)), io.ir(30, 25), io.ir(11, 7))
  } .elsewhen(io.instr_type === rv_instr_t.csrrw |
              io.instr_type === rv_instr_t.csrrs |
              io.instr_type === rv_instr_t.csrrc |
              io.instr_type === rv_instr_t.csrrwi |
              io.instr_type === rv_instr_t.csrrsi |
              io.instr_type === rv_instr_t.csrrci ){
    io.imm := Cat(Fill(27,0.U),io.ir(19,15))//0扩展
  }
}