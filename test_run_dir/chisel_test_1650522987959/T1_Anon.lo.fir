circuit T1_Anon :
  module Queue :
    input clock : Clock
    input reset : UInt<1>
    output io_enq_ready : UInt<1>
    input io_enq_valid : UInt<1>
    input io_enq_bits : UInt<8>
    input io_deq_ready : UInt<1>
    output io_deq_valid : UInt<1>
    output io_deq_bits : UInt<8>
    output io_count : UInt<2>

    mem ram : @[Decoupled.scala 259:95]
      data-type => UInt<8>
      depth => 2
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    reg value : UInt<1>, clock with :
      reset => (UInt<1>("h0"), value) @[Counter.scala 62:40]
    reg value_1 : UInt<1>, clock with :
      reset => (UInt<1>("h0"), value_1) @[Counter.scala 62:40]
    reg maybe_full : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maybe_full) @[Decoupled.scala 262:27]
    node ptr_match = eq(value, value_1) @[Decoupled.scala 263:33]
    node _empty_T = eq(maybe_full, UInt<1>("h0")) @[Decoupled.scala 264:28]
    node empty = and(ptr_match, _empty_T) @[Decoupled.scala 264:25]
    node full = and(ptr_match, maybe_full) @[Decoupled.scala 265:24]
    node _do_enq_T = and(io_enq_ready, io_enq_valid) @[Decoupled.scala 50:35]
    node _do_deq_T = and(io_deq_ready, io_deq_valid) @[Decoupled.scala 50:35]
    node wrap = eq(value, UInt<1>("h1")) @[Counter.scala 74:24]
    node _value_T = add(value, UInt<1>("h1")) @[Counter.scala 78:24]
    node _value_T_1 = tail(_value_T, 1) @[Counter.scala 78:24]
    node do_enq = _do_enq_T
    node _GEN_0 = validif(do_enq, value) @[Decoupled.scala 272:16 273:8]
    node _GEN_1 = validif(do_enq, clock) @[Decoupled.scala 272:16 273:8]
    node _GEN_2 = mux(do_enq, UInt<1>("h1"), UInt<1>("h0")) @[Decoupled.scala 272:16 273:8 259:95]
    node _GEN_3 = validif(do_enq, UInt<1>("h1")) @[Decoupled.scala 272:16 273:24]
    node _GEN_4 = validif(do_enq, io_enq_bits) @[Decoupled.scala 272:16 273:24]
    node _GEN_5 = mux(do_enq, _value_T_1, value) @[Decoupled.scala 272:16 Counter.scala 78:15 62:40]
    node wrap_1 = eq(value_1, UInt<1>("h1")) @[Counter.scala 74:24]
    node _value_T_2 = add(value_1, UInt<1>("h1")) @[Counter.scala 78:24]
    node _value_T_3 = tail(_value_T_2, 1) @[Counter.scala 78:24]
    node do_deq = _do_deq_T
    node _GEN_6 = mux(do_deq, _value_T_3, value_1) @[Decoupled.scala 276:16 Counter.scala 78:15 62:40]
    node _T = neq(do_enq, do_deq) @[Decoupled.scala 279:15]
    node _GEN_7 = mux(_T, do_enq, maybe_full) @[Decoupled.scala 279:27 280:16 262:27]
    node _GEN_8 = mux(UInt<1>("h0"), UInt<1>("h0"), _GEN_5) @[Decoupled.scala 282:15 Counter.scala 99:11]
    node _GEN_9 = mux(UInt<1>("h0"), UInt<1>("h0"), _GEN_6) @[Decoupled.scala 282:15 Counter.scala 99:11]
    node _GEN_10 = mux(UInt<1>("h0"), UInt<1>("h0"), _GEN_7) @[Decoupled.scala 282:15 285:16]
    node _io_deq_valid_T = eq(empty, UInt<1>("h0")) @[Decoupled.scala 288:19]
    node _io_enq_ready_T = eq(full, UInt<1>("h0")) @[Decoupled.scala 289:19]
    node _ptr_diff_T = sub(value, value_1) @[Decoupled.scala 312:32]
    node ptr_diff = tail(_ptr_diff_T, 1) @[Decoupled.scala 312:32]
    node _io_count_T = and(maybe_full, ptr_match) @[Decoupled.scala 315:32]
    node _io_count_T_1 = mux(_io_count_T, UInt<2>("h2"), UInt<1>("h0")) @[Decoupled.scala 315:20]
    node _io_count_T_2 = or(_io_count_T_1, ptr_diff) @[Decoupled.scala 315:62]
    io_enq_ready <= _io_enq_ready_T @[Decoupled.scala 289:16]
    io_deq_valid <= _io_deq_valid_T @[Decoupled.scala 288:16]
    io_deq_bits <= ram.io_deq_bits_MPORT.data @[Decoupled.scala 296:17]
    io_count <= _io_count_T_2 @[Decoupled.scala 315:14]
    ram.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 296:23]
    ram.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 296:23]
    ram.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 296:23]
    ram.MPORT.addr <= _GEN_0
    ram.MPORT.en <= _GEN_2
    ram.MPORT.clk <= _GEN_1
    ram.MPORT.data <= _GEN_4
    ram.MPORT.mask <= _GEN_3
    value <= mux(reset, UInt<1>("h0"), _GEN_8) @[Counter.scala 62:{40,40}]
    value_1 <= mux(reset, UInt<1>("h0"), _GEN_9) @[Counter.scala 62:{40,40}]
    maybe_full <= mux(reset, UInt<1>("h0"), _GEN_10) @[Decoupled.scala 262:{27,27}]

  module T1_Anon :
    input clock : Clock
    input reset : UInt<1>
    output io_in_ready : UInt<1>
    input io_in_valid : UInt<1>
    input io_in_bits : UInt<8>
    input io_out_ready : UInt<1>
    output io_out_valid : UInt<1>
    output io_out_bits : UInt<8>

    inst queue of Queue @[Decoupled.scala 361:21]
    io_in_ready <= queue.io_enq_ready @[Decoupled.scala 365:17]
    io_out_valid <= queue.io_deq_valid @[learnclass.scala 28:12]
    io_out_bits <= queue.io_deq_bits @[learnclass.scala 28:12]
    queue.clock <= clock
    queue.reset <= reset
    queue.io_enq_valid <= io_in_valid @[Decoupled.scala 363:22]
    queue.io_enq_bits <= io_in_bits @[Decoupled.scala 364:21]
    queue.io_deq_ready <= io_out_ready @[learnclass.scala 28:12]
