circuit learnclass :
  module learnclass :
    input clock : Clock
    input reset : UInt<1>
    input io_in : UInt<8>
    output io_out : UInt<8>
    input io_consts_0 : UInt<8>
    input io_consts_1 : UInt<8>
    input io_consts_2 : UInt<8>
    input io_consts_3 : UInt<8>

    reg regs_0 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), regs_0) @[learnclass.scala 16:21]
    reg regs_1 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), regs_1) @[learnclass.scala 16:21]
    reg regs_2 : UInt<8>, clock with :
      reset => (UInt<1>("h0"), regs_2) @[learnclass.scala 16:21]
    node _muls_0_T = mul(io_in, io_consts_0) @[learnclass.scala 24:33]
    node _muls_1_T = mul(regs_0, io_consts_1) @[learnclass.scala 25:39]
    node _muls_2_T = mul(regs_1, io_consts_2) @[learnclass.scala 25:39]
    node _muls_3_T = mul(regs_2, io_consts_3) @[learnclass.scala 25:39]
    node muls_1 = bits(_muls_1_T, 7, 0) @[learnclass.scala 22:18 25:24]
    node muls_0 = bits(_muls_0_T, 7, 0) @[learnclass.scala 22:18 24:24]
    node scan_0 = muls_0 @[learnclass.scala 28:18 30:24]
    node _scan_1_T = add(muls_1, scan_0) @[learnclass.scala 31:29]
    node _scan_1_T_1 = tail(_scan_1_T, 1) @[learnclass.scala 31:29]
    node muls_2 = bits(_muls_2_T, 7, 0) @[learnclass.scala 22:18 25:24]
    node scan_1 = _scan_1_T_1 @[learnclass.scala 28:18 31:18]
    node _scan_2_T = add(muls_2, scan_1) @[learnclass.scala 31:29]
    node _scan_2_T_1 = tail(_scan_2_T, 1) @[learnclass.scala 31:29]
    node muls_3 = bits(_muls_3_T, 7, 0) @[learnclass.scala 22:18 25:24]
    node scan_2 = _scan_2_T_1 @[learnclass.scala 28:18 31:18]
    node _scan_3_T = add(muls_3, scan_2) @[learnclass.scala 31:29]
    node _scan_3_T_1 = tail(_scan_3_T, 1) @[learnclass.scala 31:29]
    node _regs_WIRE_0 = UInt<8>("h0") @[learnclass.scala 16:{29,29}]
    node _regs_WIRE_1 = UInt<8>("h0") @[learnclass.scala 16:{29,29}]
    node _regs_WIRE_2 = UInt<8>("h0") @[learnclass.scala 16:{29,29}]
    node scan_3 = _scan_3_T_1 @[learnclass.scala 28:18 31:18]
    io_out <= scan_3 @[learnclass.scala 34:10]
    regs_0 <= mux(reset, _regs_WIRE_0, io_in) @[learnclass.scala 16:{21,21} 18:24]
    regs_1 <= mux(reset, _regs_WIRE_1, regs_0) @[learnclass.scala 16:{21,21} 19:24]
    regs_2 <= mux(reset, _regs_WIRE_2, regs_1) @[learnclass.scala 16:{21,21} 19:24]
