circuit RegisterFileGroup :
  module RegisterFileGroup :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip TID_Change_En : UInt<1>, flip TID_Changed_ID : UInt<1>, flip Raddr1 : UInt<5>, flip Raddr2 : UInt<5>, flip Raddr3 : UInt<5>, Rdata1 : UInt<32>, Rdata2 : UInt<32>, Rdata3 : UInt<32>, flip Write_En : UInt<1>, flip Waddr : UInt<5>, flip Wdata : UInt<32>}

    reg TID : UInt<1>, clock with :
      reset => (UInt<1>("h0"), TID) @[RegisterFileGroup.scala 28:16]
    wire _RegFileGroup_WIRE : UInt<32>[64] @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[0] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[1] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[2] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[3] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[4] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[5] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[6] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[7] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[8] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[9] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[10] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[11] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[12] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[13] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[14] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[15] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[16] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[17] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[18] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[19] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[20] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[21] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[22] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[23] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[24] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[25] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[26] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[27] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[28] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[29] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[30] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[31] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[32] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[33] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[34] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[35] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[36] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[37] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[38] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[39] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[40] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[41] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[42] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[43] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[44] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[45] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[46] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[47] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[48] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[49] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[50] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[51] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[52] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[53] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[54] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[55] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[56] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[57] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[58] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[59] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[60] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[61] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[62] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    _RegFileGroup_WIRE[63] <= UInt<32>("h0") @[RegisterFileGroup.scala 30:37]
    reg RegFileGroup : UInt<32>[64], clock with :
      reset => (reset, _RegFileGroup_WIRE) @[RegisterFileGroup.scala 30:29]
    node _T = lt(io.TID_Changed_ID, UInt<2>("h2")) @[RegisterFileGroup.scala 33:47]
    node _T_1 = and(io.TID_Change_En, _T) @[RegisterFileGroup.scala 33:25]
    when _T_1 : @[RegisterFileGroup.scala 33:75]
      TID <= io.TID_Changed_ID @[RegisterFileGroup.scala 34:9]
    else :
      node _T_2 = neq(io.Waddr, UInt<1>("h0")) @[RegisterFileGroup.scala 35:39]
      node _T_3 = and(io.Write_En, _T_2) @[RegisterFileGroup.scala 35:27]
      when _T_3 : @[RegisterFileGroup.scala 35:48]
        node _T_4 = cat(TID, io.Waddr) @[Cat.scala 31:58]
        RegFileGroup[_T_4] <= io.Wdata @[RegisterFileGroup.scala 36:38]
    node _io_Rdata1_T = cat(TID, io.Raddr1) @[Cat.scala 31:58]
    io.Rdata1 <= RegFileGroup[_io_Rdata1_T] @[RegisterFileGroup.scala 39:13]
    node _io_Rdata2_T = cat(TID, io.Raddr2) @[Cat.scala 31:58]
    io.Rdata2 <= RegFileGroup[_io_Rdata2_T] @[RegisterFileGroup.scala 40:13]
    node _io_Rdata3_T = cat(TID, io.Raddr3) @[Cat.scala 31:58]
    io.Rdata3 <= RegFileGroup[_io_Rdata3_T] @[RegisterFileGroup.scala 41:13]

