//import chisel3._
//import chisel3.experimental.ChiselEnum
//import chisel3.util._
//import Param.Param
//
//
///* a dumb axi data structure */
//class AXI(private val addrWidth: Int, private val wordWidth: Int, private val idWidth: Int) extends Bundle {
//  // read channel
//  val araddr = Output(UInt(addrWidth.W))
//  val arid = Output(UInt(idWidth.W))
//  val arsize = Output(UInt(4.W))
//  val arlen = Output(UInt(8.W))
//  val arburst = Output(UInt(2.W))
//  val arlock = Output(UInt(1.W))
//  val arcache = Output(UInt(4.W))
//  val arprot = Output(UInt(3.W))
//  val arvalid = Output(Bool())
//  val arready = Input(Bool())
//
//  val rready = Output(Bool())
//  val rvalid = Input(Bool())
//  val rlast = Input(Bool())
//  val rdata = Input(UInt( .W))
//  val rresp = Input(UInt(2.W))
//  val rid = Input(UInt(idWidth.W))
//
//  // write channel
//  val awaddr = Output(UInt(addrWidth.W))
//  val awid = Output(UInt(idWidth.W))
//  val awsize = Output(UInt(4.W))
//  val awlen = Output(UInt(8.W))
//  val awburst = Output(UInt(2.W))
//  val awlock = Output(UInt(1.W))
//  val awcache = Output(UInt(4.W))
//  val awprot = Output(UInt(3.W))
//  val awvalid = Output(Bool())
//  val awready = Input(Bool())
//
//  val wdata = Output(UInt(wordWidth.W))
//  val wlast = Output(Bool())
//  val wstrb = Output(UInt((wordWidth / 8).W))
//  val wvalid = Output(Bool())
//  val wready = Input(Bool())
//
//  val bid = Input(UInt(idWidth.W))
//  val bresp = Input(UInt(2.W))
//  val bvalid = Input(Bool())
//  val bready = Output(Bool())
//
//}
//
//object IDSel extends ChiselEnum {
//  val ins, data = Value
//}
//
//
//object AXIStates extends ChiselEnum {
//  val idle, addr, rresp, wdata, bresp = Value
//}
//
//object TranslationStates extends ChiselEnum {
//  val idle, decode, respToOp, op, lastResp = Value
//}
//
///**
// * The module translates the requests from the core into axi transactions
// * Also, mechanisms for performing lr and sc is included
// * This layer serves as the serialization point
// * Problem: unaligned accesses
// * Byte enabled accesses
// * Assume aligned accesses as for risc-v, unaligned access might result in exception.
// * For unaligned accesses to this module, the behaviour is not defined
// * Note that if the accesses are aligned, it is naturally aligned to the page boundary.
// * However, when allocating the address, the cma should also start from the page boundary
// */
//// Assume 64 bit address width
//class AXITranslationLayer(coreParam: Param) extends Module {
//  class InteralRequestBundle extends Bundle {
//    val reqAddr = UInt(coreParam.isaParam.XLEN.W)
//    val reqLen = UInt(2.W)
//    val reqData = UInt(coreParam.isaParam.XLEN.W)
//    val reqType = MemoryRequestType()
//    val reqLocked = Bool()
//  }
//  private val wordWidth = coreParam.axiParam.get.axiWordWidth
//  private val genICacheReq = new ICacheReq(coreParam)
//  private val genICacheResp = new ICacheResp(coreParam)
//  private val genDCacheReq = new DCacheReq(coreParam)
//  private val genDCacheResp = new DCacheResp(coreParam)
//  private val genInternalRequestBundle = new InteralRequestBundle
//  private val scSuccRet = 0.U
//  private val scFailRet = 1.U
//  val io = IO(new Bundle {
//    val m_axi = new AXI(coreParam.isaParam.XLEN, wordWidth, log2Ceil(coreParam.nCore * 2))
//    val baseAddress = Input(UInt(coreParam.isaParam.XLEN.W))
//    val iCacheReq = Flipped(Vec(coreParam.nCore, Decoupled(genICacheReq)))
//    val iCacheResp = Vec(coreParam.nCore, Decoupled(genICacheResp))
//    val dCacheReq = Flipped(Vec(coreParam.nCore, Decoupled(genDCacheReq)))
//    val dCacheResp = Vec(coreParam.nCore, Decoupled(genDCacheResp))
//  })
//  // val iCacheRespQ = Module(new Queue(genICacheResp, coreParam.nCore))
//  // val dCacheRespQ = Module(new Queue(genDCacheResp, coreParam.nCore))
//
//  val iCacheArbiter = Module(new RRArbiter(genICacheReq, coreParam.nCore))
//  val dCacheArbiter = Module(new RRArbiter(genDCacheReq, coreParam.nCore))
//
//  iCacheArbiter.io.in <> io.iCacheReq
//  dCacheArbiter.io.in <> io.dCacheReq
//
//  val idSel = RegInit(IDSel.ins)
//  val axiState = RegInit(AXIStates.idle)
//  val translationState = RegInit(TranslationStates.idle)
//
//  val reqAddr = Reg(UInt(coreParam.isaParam.XLEN.W))
//  val reqLen = Reg(UInt(2.W))
//  val reqData = Reg(UInt(coreParam.isaParam.XLEN.W))
//  val reqType = Reg(MemoryRequestType())
//  val reqCore = Reg(UInt(log2Ceil(coreParam.nCore).W))
//  val amoOP = Reg(AMOOP())
//
//  val axiRequestQ = Module(new Queue(genInternalRequestBundle, entries=2))
//  // response can be just acknowledgement or data
//  val axiResponseQ = Module(new Queue(UInt(coreParam.isaParam.XLEN.W), entries=2))
//  val reservedAddress = Reg(Vec(coreParam.nCore, UInt(coreParam.isaParam.XLEN.W)))
//  val reservedValid = RegInit(VecInit(Seq.fill(coreParam.nCore){ false.B }))
//
//  val amoALU = Module(new AMOALU(coreParam))
//  val amoReadValue = Reg(UInt(coreParam.isaParam.XLEN.W))
//  val respData = _constructResponse(reqAddr, axiResponseQ.io.deq.bits)
//  val scFailed = RegInit(false.B)
//  val hold = RegInit(VecInit(Seq.fill(coreParam.nCore) { 0.U(2.W) }))
//  val reservedReqAddr = WireInit(VecInit(Seq.fill(coreParam.nCore) { false.B }))
//  val holdingReqAddr = WireInit(VecInit(Seq.fill(coreParam.nCore) { false.B }))
//  for { i <- 0 until coreParam.nCore } {
//    reservedReqAddr(i) := (_floorAligned(reqAddr, alignmentBit = log2Ceil(wordWidth / 8)) ===
//      _floorAligned(reservedAddress(i), alignmentBit = log2Ceil(wordWidth / 8))) &&
//      reservedValid(i)
//    holdingReqAddr(i) :=  reservedReqAddr(i) && (hold(i) =/= 0.U)
//  }
//  val someCoreHolding = holdingReqAddr.asUInt.orR
//
//  amoALU.io.amo_alu_op := amoOP
//  amoALU.io.in2 := reqData // should not be shifted
//  amoALU.io.in1 := amoReadValue // should be shifted
//  amoALU.io.isW := reqLen =/= 3.U
//
//  iCacheArbiter.io.out.ready := idSel === IDSel.ins && translationState === TranslationStates.idle
//  dCacheArbiter.io.out.ready := idSel === IDSel.data && translationState === TranslationStates.idle
//
//  axiResponseQ.io.deq.ready := false.B
//  when(idSel === IDSel.ins) {
//    axiResponseQ.io.deq.ready := io.iCacheResp(reqCore).ready
//  }.elsewhen(idSel === IDSel.data) {
//    axiResponseQ.io.deq.ready := io.dCacheResp(reqCore).ready
//  }
//
//  for { i <- 0 until coreParam.nCore } {
//    // this is different for amo vs normal load/store ops.
//    io.iCacheResp(i).valid := false.B
//    io.dCacheResp(i).valid := false.B
//    io.iCacheResp(i).bits.address := reqAddr
//    io.dCacheResp(i).bits.address := reqAddr
//    io.iCacheResp(i).bits.data := respData
//    io.dCacheResp(i).bits.data := respData
//    when(reqCore === i.U) {
//      when(translationState === TranslationStates.lastResp) {
//        when(idSel === IDSel.ins) {
//          io.iCacheResp(i).valid := axiResponseQ.io.deq.valid
//        }.elsewhen(idSel === IDSel.data) {
//          io.dCacheResp(i).valid := axiResponseQ.io.deq.valid
//          when(reqType === MemoryRequestType.amo) {
//            // for amo we should return the old value
//            io.dCacheResp(i).bits.data := amoReadValue
//          }.elsewhen(reqType === MemoryRequestType.sc) {
//            when(scFailed) {
//              // in this case no memory requests are issued
//              io.dCacheResp(i).valid := true.B
//              io.dCacheResp(i).bits.data := scFailRet
//            }.otherwise {
//              io.dCacheResp(i).bits.data := scSuccRet
//            }
//          }
//        }
//      }
//    }
//  }
//
//
//  // sequential logic
//  switch(translationState) {
//    is(TranslationStates.idle) {
//      printf("[AXI] Idle: ")
//      when(idSel === IDSel.ins) {
//        printf("ins\n")
//      }.elsewhen(idSel === IDSel.data) {
//        printf("data\n")
//      }
//      when(idSel === IDSel.ins) {
//        when(iCacheArbiter.io.out.fire()) {
//          // icache requests always results in instruction read
//          reqAddr := iCacheArbiter.io.out.bits.address
//          reqLen := iCacheArbiter.io.out.bits.length // or hard coded to isaParam.fetchWidth
//          reqType := MemoryRequestType.read
//          reqCore := iCacheArbiter.io.chosen
//          translationState := TranslationStates.decode
//        }.otherwise {
//          idSel := IDSel.data
//        }
//      }.elsewhen(idSel === IDSel.data) {
//        when(dCacheArbiter.io.out.fire()) {
//          reqAddr := dCacheArbiter.io.out.bits.address
//          reqLen := dCacheArbiter.io.out.bits.length
//          reqData := dCacheArbiter.io.out.bits.data
//          reqType := dCacheArbiter.io.out.bits.memoryType
//          reqCore := dCacheArbiter.io.chosen
//          when(dCacheArbiter.io.out.bits.isAMO) {
//            amoOP := dCacheArbiter.io.out.bits.amoOP
//          }.otherwise {
//            amoOP := AMOOP.none
//          }
//          translationState := TranslationStates.decode
//          for { i <- 0 until coreParam.nCore } {
//            when(hold(i) =/= 0.U)  {
//              hold(i) := hold(i) - 1.U
//            }
//          }
//        }.otherwise {
//          idSel := IDSel.ins
//        }
//      }
//    }
//    is(TranslationStates.decode) {
//      printf(p"[AXI] decode, addr ${Hexadecimal(reqAddr)}, core_id: ${reqCore}\n")
//      when(someCoreHolding === false.B && idSel =/= IDSel.ins) {
//        for {i <- 0 until coreParam.nCore} {
//          printf(p"[Core ${i}] rsvd: (${reservedValid(i)}, ${Hexadecimal(reservedAddress(i))}, ${hold(reqCore)}\n")
//          // invalidate other core's reservation
//          when(reservedReqAddr(i)) {
//            when(i.U === reqCore && (reqType === MemoryRequestType.sc || reqType === MemoryRequestType.lr)) {
//            }.otherwise {
//              printf(p"[Core ${i}] get flushed at address ${Hexadecimal(reqAddr)}\n")
//              reservedValid(i) := false.B
//            }
//          }
//        }
//      }
//      when(reqType === MemoryRequestType.read || reqType === MemoryRequestType.write) {
//        when(axiRequestQ.io.enq.fire()) {
//          translationState := TranslationStates.lastResp
//        }
//      }.elsewhen(reqType === MemoryRequestType.amo) {
//        when(axiRequestQ.io.enq.fire()) {
//          translationState := TranslationStates.respToOp
//        }
//      }.elsewhen(reqType === MemoryRequestType.lr) {
//        when(axiRequestQ.io.enq.fire()) {
//          translationState := TranslationStates.lastResp
//          when(someCoreHolding === false.B) {
//            hold(reqCore) := 2.U
//            reservedValid(reqCore) := true.B
//            reservedAddress(reqCore) := _floorAligned(reqAddr, log2Ceil(wordWidth / 8))
//          }
//        }
//      }.elsewhen(reqType === MemoryRequestType.sc) {
//        // note that the core might not necessarily holding the word
//        when(reservedValid(reqCore) &&
//          (_floorAligned(reservedAddress(reqCore), log2Ceil(wordWidth / 8)) ===
//            _floorAligned(reqAddr, log2Ceil(wordWidth / 8)))) {
//          when(axiRequestQ.io.enq.fire()) {
//            translationState := TranslationStates.lastResp
//            scFailed := false.B
//          }
//        }.otherwise {
//          translationState := TranslationStates.lastResp
//          scFailed := true.B
//        }
//      }
//    }
//    is(TranslationStates.respToOp) {
//      when(axiResponseQ.io.deq.fire()) {
//        amoReadValue := _constructResponse(reqAddr, axiResponseQ.io.deq.bits)
//        translationState := TranslationStates.op
//        printf("[AXI] respToOp -> op\n")
//      }
//    }
//    is(TranslationStates.op) {
//      when(axiRequestQ.io.enq.fire()) {
//        translationState := TranslationStates.lastResp
//        printf("[AXI] op -> lastResp\n")
//      }
//    }
//    is(TranslationStates.lastResp) {
//      // Note branch 1 and branch 2 will be orthogonal (corresponding to different sc cases)
//      // Branch 1
//      when(axiResponseQ.io.deq.fire()) {
//        translationState := TranslationStates.idle
//
//        when(idSel === IDSel.ins) {
//          idSel := IDSel.data
//        }.elsewhen(idSel === IDSel.data) {
//          idSel := IDSel.ins
//        }
//      }
//
//      // Branch 2
//      when(reqType === MemoryRequestType.sc && scFailed) {
//        when(io.dCacheResp(reqCore).fire()) {
//          translationState := TranslationStates.idle
//          when(idSel === IDSel.ins) {
//            idSel := IDSel.data
//          }.elsewhen(idSel === IDSel.data) {
//            idSel := IDSel.ins
//          }
//        }
//      }
//
//      // TODO: self modifying code might have a problem
//      // as the instruction load will not invalidate the reservation
//      // invalidate self reservation
//      when(reqType =/= MemoryRequestType.lr && idSel === IDSel.data) {
//        reservedValid(reqCore) := false.B
//        hold(reqCore) := 0.U
//      }
//    }
//  }
//
//  _generateCombinationalTransitionLogic()
//
//
//  val axiRequest = Reg(genInternalRequestBundle)
//
//  // default values
//  io.m_axi.arvalid := axiRequest.reqType === MemoryRequestType.read && axiState === AXIStates.addr
//  io.m_axi.araddr := axiRequest.reqAddr + io.baseAddress
//  //io.m_axi.arprot := "b010".U
//  //io.m_axi.arcache := "b1011".U
//  io.m_axi.arprot := "b000".U
//  io.m_axi.arcache := "b0011".U
//  io.m_axi.arsize := 3.U // must be fixed, so that it is compatible across different platforms
//  io.m_axi.arburst := "b01".U
//  io.m_axi.arlock := axiRequest.reqLocked
//  io.m_axi.arid := reqCore << 1.U
//  io.m_axi.arlen := 0.U // this is only for aligned accesses
//
//  io.m_axi.awvalid := axiRequest.reqType === MemoryRequestType.write && axiState === AXIStates.addr
//  io.m_axi.awaddr := axiRequest.reqAddr + io.baseAddress
//  //io.m_axi.awprot := "b010".U
//  //io.m_axi.awcache := "b1111".U
//  io.m_axi.awprot := "b000".U
//  io.m_axi.awcache := "b0011".U
//  io.m_axi.awsize := 3.U
//  io.m_axi.awburst := "b01".U
//  io.m_axi.awlock := axiRequest.reqLocked
//  io.m_axi.awid := reqCore << 1.U
//  io.m_axi.awlen := 0.U // this is only for aligned accesses
//
//  io.m_axi.wstrb := _constructStrobe(reqAddr, reqLen)
//  io.m_axi.wlast := 1.U
//  io.m_axi.wdata := _constructData(reqAddr, axiRequest.reqData)
//  io.m_axi.wvalid := axiState === AXIStates.wdata
//
//  io.m_axi.rready := axiState === AXIStates.rresp
//  io.m_axi.bready := axiState === AXIStates.bresp
//
//  axiResponseQ.io.enq.valid := (axiState === AXIStates.rresp) && io.m_axi.rvalid || (axiState === AXIStates.bresp) && io.m_axi.bvalid
//  axiRequestQ.io.deq.ready := axiState === AXIStates.idle
//  axiResponseQ.io.enq.bits := 0.U
//
//  // printf(p"axiRequest Enq ${axiRequestQ.io.enq} Deq ${axiRequestQ.io.deq}\n")
//  // printf(p"axiResponse Enq ${axiResponseQ.io.enq} Deq ${axiResponseQ.io.deq}\n")
//
//  when(axiState === AXIStates.rresp) {
//    axiResponseQ.io.enq.bits := io.m_axi.rdata
//  }
//
//  switch(axiState) {
//    is(AXIStates.idle) {
//      when(axiRequestQ.io.deq.fire()) {
//        axiRequest := axiRequestQ.io.deq.bits
//        axiState := AXIStates.addr
//      }
//    }
//    is(AXIStates.addr) {
//      when(axiRequest.reqType === MemoryRequestType.read) {
//        when(io.m_axi.arvalid && io.m_axi.arready) {
//          axiState := AXIStates.rresp
//        }
//      }.elsewhen(axiRequest.reqType === MemoryRequestType.write) {
//        when(io.m_axi.awvalid && io.m_axi.awready) {
//          axiState := AXIStates.wdata
//        }
//      }
//    }
//    is(AXIStates.rresp) {
//      // this is the only possibility
//      when(io.m_axi.rready && io.m_axi.rvalid ) {
//        when(io.m_axi.rlast) {
//          axiState := AXIStates.idle
//        }
//      }
//    }
//    is(AXIStates.wdata) {
//      when(io.m_axi.wready && io.m_axi.wvalid) {
//        axiState := AXIStates.bresp
//      }
//    }
//    is(AXIStates.bresp) {
//      when(io.m_axi.bready && io.m_axi.bvalid) {
//        axiState := AXIStates.idle
//      }
//    }
//  }
//
//  def _checkIsAMO(): Bool = {
//    val w = WireInit(false.B)
//    when(reqType === MemoryRequestType.amo) {
//      w := true.B
//    }
//    w
//  }
//
//  /**
//   * for constructing wstrb
//   */
//  def _constructStrobe(addr: UInt, len: UInt): UInt = {
//    val bits = WireInit(0.U((wordWidth / 8).W))
//    val shamtWidth = log2Ceil(wordWidth / 8)
//    switch(len) {
//      is(0.U) { bits := "b1".U }
//      is(1.U) { bits := "b11".U }
//      is(2.U) { bits := "b1111".U }
//      is(3.U) { bits := "b11111111".U }
//    }
//    (bits << addr(shamtWidth - 1, 0)).asUInt()
//  }
//  /**
//   * for constructing wdata
//   */
//  def _constructData(addr: UInt, data: UInt): UInt = {
//    val shamtWidth = log2Ceil(wordWidth / 8)
//    // printf(p"[AXI] addr: ${Hexadecimal(addr)} data: ${Hexadecimal(data)}, shiftamt: ${Cat(addr(shamtWidth - 1, 0), "b000".U(3.W))}\n")
//    (data << Cat(addr(shamtWidth - 1, 0), "b000".U(3.W))).asUInt()
//  }
//
//
//  /**
//   *  for shifting and taking the right portion of data
//   */
//  def _constructResponse(addr: UInt, data: UInt): UInt = {
//    val shamtWidth = log2Ceil(wordWidth / 8)
//    (data >> Cat(addr(shamtWidth - 1, 0), "b000".U(3.W)) ).asUInt()
//  }
//
//  // aligned to the least significant alignmentBit bits
//  def _floorAligned(addr: UInt, alignmentBit: Int): UInt = {
//    val width = addr.getWidth
//    Cat(addr(width - 1, alignmentBit), 0.U(alignmentBit.W))
//  }
//
//  def _generateCombinationalTransitionLogic(): Unit = {
//    // combinational logic for queue
//    axiRequestQ.io.enq.bits.reqAddr := _floorAligned(reqAddr, log2Ceil(wordWidth / 8))
//    axiRequestQ.io.enq.bits.reqLocked := _checkIsAMO()
//    axiRequestQ.io.enq.bits.reqType := MemoryRequestType.read
//    axiRequestQ.io.enq.bits.reqLen := reqLen
//    axiRequestQ.io.enq.bits.reqData := reqData
//    axiRequestQ.io.enq.valid := false.B
//
//    axiResponseQ.io.deq.ready := false.B
//    switch(translationState) {
//      is(TranslationStates.decode) {
//        axiRequestQ.io.enq.valid := true.B
//        switch(reqType) {
//          is(MemoryRequestType.read) {
//            axiRequestQ.io.enq.bits.reqType := MemoryRequestType.read
//          }
//          is(MemoryRequestType.write) {
//            axiRequestQ.io.enq.bits.reqType := MemoryRequestType.write
//          }
//          is(MemoryRequestType.amo) {
//            axiRequestQ.io.enq.bits.reqLocked := true.B
//            axiRequestQ.io.enq.bits.reqType := MemoryRequestType.read
//          }
//          is(MemoryRequestType.lr) {
//            axiRequestQ.io.enq.bits.reqType := MemoryRequestType.read
//          }
//          is(MemoryRequestType.sc) {
//            when(reservedValid(reqCore) && (_floorAligned(reqAddr, log2Ceil(wordWidth / 8)) === reservedAddress(reqCore))) {
//              axiRequestQ.io.enq.bits.reqType := MemoryRequestType.write
//            }.otherwise {
//              // if the reservation is invalid, simply return false
//              axiRequestQ.io.enq.valid := false.B
//            }
//          }
//        }
//      }
//      is(TranslationStates.respToOp) {
//        axiResponseQ.io.deq.ready := true.B
//      }
//      is(TranslationStates.op) { // for the write part of the amo operation
//        axiRequestQ.io.enq.valid := true.B
//        axiRequestQ.io.enq.bits.reqLocked := false.B
//        axiRequestQ.io.enq.bits.reqType := MemoryRequestType.write
//        axiRequestQ.io.enq.bits.reqLen := reqLen
//        axiRequestQ.io.enq.bits.reqData := amoALU.io.out
//      }
//      is(TranslationStates.lastResp) {
//        axiResponseQ.io.deq.ready := true.B
//      }
//    }
//  }
//}
