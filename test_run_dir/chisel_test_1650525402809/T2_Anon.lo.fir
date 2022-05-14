circuit T2_Anon :
  module Arbiter :
    input clock : Clock
    input reset : UInt<1>
    output io_in_0_ready : UInt<1>
    input io_in_0_valid : UInt<1>
    input io_in_0_bits : UInt<8>
    output io_in_1_ready : UInt<1>
    input io_in_1_valid : UInt<1>
    input io_in_1_bits : UInt<8>
    input io_out_ready : UInt<1>
    output io_out_valid : UInt<1>
    output io_out_bits : UInt<8>
    output io_chosen : UInt<1>

    node _GEN_0 = mux(io_in_0_valid, UInt<1>("h0"), UInt<1>("h1")) @[Arbiter.scala 138:13 141:26 142:17]
    node _GEN_1 = mux(io_in_0_valid, io_in_0_bits, io_in_1_bits) @[Arbiter.scala 139:15 141:26 143:19]
    node grant_1 = eq(io_in_0_valid, UInt<1>("h0")) @[Arbiter.scala 46:78]
    node _io_in_0_ready_T = and(UInt<1>("h1"), io_out_ready) @[Arbiter.scala 149:19]
    node _io_in_1_ready_T = and(grant_1, io_out_ready) @[Arbiter.scala 149:19]
    node _io_out_valid_T = eq(grant_1, UInt<1>("h0")) @[Arbiter.scala 150:19]
    node _io_out_valid_T_1 = or(_io_out_valid_T, io_in_1_valid) @[Arbiter.scala 150:31]
    io_in_0_ready <= _io_in_0_ready_T @[Arbiter.scala 149:14]
    io_in_1_ready <= _io_in_1_ready_T @[Arbiter.scala 149:14]
    io_out_valid <= _io_out_valid_T_1 @[Arbiter.scala 150:16]
    io_out_bits <= _GEN_1
    io_chosen <= _GEN_0

  module T2_Anon :
    input clock : Clock
    input reset : UInt<1>
    output io_in_0_ready : UInt<1>
    input io_in_0_valid : UInt<1>
    input io_in_0_bits : UInt<8>
    output io_in_1_ready : UInt<1>
    input io_in_1_valid : UInt<1>
    input io_in_1_bits : UInt<8>
    input io_out_ready : UInt<1>
    output io_out_valid : UInt<1>
    output io_out_bits : UInt<8>

    inst arbiter of Arbiter @[learnclass.scala 79:25]
    io_in_0_ready <= arbiter.io_in_0_ready @[learnclass.scala 80:19]
    io_in_1_ready <= arbiter.io_in_1_ready @[learnclass.scala 80:19]
    io_out_valid <= arbiter.io_out_valid @[learnclass.scala 81:12]
    io_out_bits <= arbiter.io_out_bits @[learnclass.scala 81:12]
    arbiter.clock <= clock
    arbiter.reset <= reset
    arbiter.io_in_0_valid <= io_in_0_valid @[learnclass.scala 80:19]
    arbiter.io_in_0_bits <= io_in_0_bits @[learnclass.scala 80:19]
    arbiter.io_in_1_valid <= io_in_1_valid @[learnclass.scala 80:19]
    arbiter.io_in_1_bits <= io_in_1_bits @[learnclass.scala 80:19]
    arbiter.io_out_ready <= io_out_ready @[learnclass.scala 81:12]
