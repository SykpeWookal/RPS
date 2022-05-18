module Cache(
  input         clock,
  input         reset,
  input  [31:0] io_addr,
  input         io_r_req,
  input         io_w_req,
  input  [31:0] io_writedata,
  input  [3:0]  io_writeMask,
  output [31:0] io_outdata,
  output        io_miss,
  output [10:0] io_mem_addr,
  output        io_mem_rd_req,
  output        io_mem_wr_req,
  output [31:0] io_mem_wr_line_0,
  output [31:0] io_mem_wr_line_1,
  input  [31:0] io_mem_rd_line_0,
  input  [31:0] io_mem_rd_line_1,
  input         io_cacheAXI_gnt
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
  reg [31:0] _RAND_46;
  reg [31:0] _RAND_47;
  reg [31:0] _RAND_48;
  reg [31:0] _RAND_49;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] CacheMem_0_0_0; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_0_0_1; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_0_1_0; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_0_1_1; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_1_0_0; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_1_0_1; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_1_1_0; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_1_1_1; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_2_0_0; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_2_0_1; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_2_1_0; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_2_1_1; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_3_0_0; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_3_0_1; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_3_1_0; // @[Cache.scala 53:25]
  reg [31:0] CacheMem_3_1_1; // @[Cache.scala 53:25]
  reg [8:0] cache_tags_0_0; // @[Cache.scala 56:27]
  reg [8:0] cache_tags_0_1; // @[Cache.scala 56:27]
  reg [8:0] cache_tags_1_0; // @[Cache.scala 56:27]
  reg [8:0] cache_tags_1_1; // @[Cache.scala 56:27]
  reg [8:0] cache_tags_2_0; // @[Cache.scala 56:27]
  reg [8:0] cache_tags_2_1; // @[Cache.scala 56:27]
  reg [8:0] cache_tags_3_0; // @[Cache.scala 56:27]
  reg [8:0] cache_tags_3_1; // @[Cache.scala 56:27]
  reg  valid_0_0; // @[Cache.scala 57:22]
  reg  valid_0_1; // @[Cache.scala 57:22]
  reg  valid_1_0; // @[Cache.scala 57:22]
  reg  valid_1_1; // @[Cache.scala 57:22]
  reg  valid_2_0; // @[Cache.scala 57:22]
  reg  valid_2_1; // @[Cache.scala 57:22]
  reg  valid_3_0; // @[Cache.scala 57:22]
  reg  valid_3_1; // @[Cache.scala 57:22]
  reg  dirty_0_0; // @[Cache.scala 58:22]
  reg  dirty_0_1; // @[Cache.scala 58:22]
  reg  dirty_1_0; // @[Cache.scala 58:22]
  reg  dirty_1_1; // @[Cache.scala 58:22]
  reg  dirty_2_0; // @[Cache.scala 58:22]
  reg  dirty_2_1; // @[Cache.scala 58:22]
  reg  dirty_3_0; // @[Cache.scala 58:22]
  reg  dirty_3_1; // @[Cache.scala 58:22]
  wire  line_addr = io_addr[2]; // @[Cache.scala 64:26]
  wire [1:0] set_addr = io_addr[4:3]; // @[Cache.scala 65:25]
  wire [8:0] tag_addr = io_addr[13:5]; // @[Cache.scala 66:25]
  reg [1:0] mem_rd_set_addr; // @[Cache.scala 70:32]
  reg [8:0] mem_rd_tag_addr; // @[Cache.scala 71:32]
  wire [10:0] mem_rd_addr = {mem_rd_tag_addr,mem_rd_set_addr}; // @[Cat.scala 31:58]
  reg [10:0] mem_wr_addr; // @[Cache.scala 73:28]
  wire  _T = io_w_req | io_r_req; // @[Cache.scala 84:17]
  wire  _GEN_1 = 2'h1 == set_addr ? valid_1_0 : valid_0_0; // @[Cache.scala 88:{32,32}]
  wire  _GEN_2 = 2'h2 == set_addr ? valid_2_0 : _GEN_1; // @[Cache.scala 88:{32,32}]
  wire  _GEN_3 = 2'h3 == set_addr ? valid_3_0 : _GEN_2; // @[Cache.scala 88:{32,32}]
  wire [8:0] _GEN_5 = 2'h1 == set_addr ? cache_tags_1_0 : cache_tags_0_0; // @[Cache.scala 88:{70,70}]
  wire [8:0] _GEN_6 = 2'h2 == set_addr ? cache_tags_2_0 : _GEN_5; // @[Cache.scala 88:{70,70}]
  wire [8:0] _GEN_7 = 2'h3 == set_addr ? cache_tags_3_0 : _GEN_6; // @[Cache.scala 88:{70,70}]
  wire  _GEN_11 = 2'h1 == set_addr ? valid_1_1 : valid_0_1; // @[Cache.scala 88:{32,32}]
  wire  _GEN_12 = 2'h2 == set_addr ? valid_2_1 : _GEN_11; // @[Cache.scala 88:{32,32}]
  wire  _GEN_13 = 2'h3 == set_addr ? valid_3_1 : _GEN_12; // @[Cache.scala 88:{32,32}]
  wire [8:0] _GEN_15 = 2'h1 == set_addr ? cache_tags_1_1 : cache_tags_0_1; // @[Cache.scala 88:{70,70}]
  wire [8:0] _GEN_16 = 2'h2 == set_addr ? cache_tags_2_1 : _GEN_15; // @[Cache.scala 88:{70,70}]
  wire [8:0] _GEN_17 = 2'h3 == set_addr ? cache_tags_3_1 : _GEN_16; // @[Cache.scala 88:{70,70}]
  wire  _T_6 = _GEN_13 & _GEN_17 == tag_addr; // @[Cache.scala 88:42]
  wire  _GEN_18 = _GEN_13 & _GEN_17 == tag_addr | _GEN_3 & _GEN_7 == tag_addr; // @[Cache.scala 88:82 89:19]
  wire  cache_Hit = (io_w_req | io_r_req) & _GEN_18; // @[Cache.scala 84:28]
  wire  way_hit = (io_w_req | io_r_req) & _T_6; // @[Cache.scala 84:28]
  reg [1:0] cacheState; // @[Cache.scala 96:27]
  reg [31:0] FIFO_Choice_0; // @[Cache.scala 103:30]
  reg [31:0] FIFO_Choice_1; // @[Cache.scala 103:30]
  reg [31:0] FIFO_Choice_2; // @[Cache.scala 103:30]
  reg [31:0] FIFO_Choice_3; // @[Cache.scala 103:30]
  wire  _T_9 = 2'h3 == cacheState; // @[Cache.scala 104:23]
  wire [31:0] _GEN_23 = 2'h1 == set_addr ? FIFO_Choice_1 : FIFO_Choice_0; // @[Cache.scala 106:{57,57}]
  wire [31:0] _GEN_24 = 2'h2 == set_addr ? FIFO_Choice_2 : _GEN_23; // @[Cache.scala 106:{57,57}]
  wire [31:0] _GEN_25 = 2'h3 == set_addr ? FIFO_Choice_3 : _GEN_24; // @[Cache.scala 106:{57,57}]
  wire [31:0] _FIFO_Choice_T_1 = _GEN_25 + 32'h1; // @[Cache.scala 106:57]
  wire [31:0] _GEN_0 = _FIFO_Choice_T_1 % 32'h2; // @[Cache.scala 106:63]
  wire [31:0] _FIFO_Choice_set_addr_0 = {{30'd0}, _GEN_0[1:0]}; // @[Cache.scala 106:{31,31}]
  reg [31:0] mem_wr_line_0; // @[Cache.scala 122:28]
  reg [31:0] mem_wr_line_1; // @[Cache.scala 122:28]
  wire  _GEN_498 = 2'h0 == set_addr; // @[Cache.scala 129:{15,15}]
  wire  _GEN_500 = 2'h0 == set_addr & ~way_hit; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_35 = 2'h0 == set_addr & ~way_hit & line_addr ? CacheMem_0_0_1 : CacheMem_0_0_0; // @[Cache.scala 129:{15,15}]
  wire  _GEN_502 = 2'h0 == set_addr & way_hit; // @[Cache.scala 129:{15,15}]
  wire  _GEN_503 = ~line_addr; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_36 = 2'h0 == set_addr & way_hit & ~line_addr ? CacheMem_0_1_0 : _GEN_35; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_37 = 2'h0 == set_addr & way_hit & line_addr ? CacheMem_0_1_1 : _GEN_36; // @[Cache.scala 129:{15,15}]
  wire  _GEN_506 = 2'h1 == set_addr; // @[Cache.scala 129:{15,15}]
  wire  _GEN_508 = 2'h1 == set_addr & ~way_hit; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_38 = 2'h1 == set_addr & ~way_hit & ~line_addr ? CacheMem_1_0_0 : _GEN_37; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_39 = 2'h1 == set_addr & ~way_hit & line_addr ? CacheMem_1_0_1 : _GEN_38; // @[Cache.scala 129:{15,15}]
  wire  _GEN_514 = 2'h1 == set_addr & way_hit; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_40 = 2'h1 == set_addr & way_hit & ~line_addr ? CacheMem_1_1_0 : _GEN_39; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_41 = 2'h1 == set_addr & way_hit & line_addr ? CacheMem_1_1_1 : _GEN_40; // @[Cache.scala 129:{15,15}]
  wire  _GEN_518 = 2'h2 == set_addr; // @[Cache.scala 129:{15,15}]
  wire  _GEN_520 = 2'h2 == set_addr & ~way_hit; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_42 = 2'h2 == set_addr & ~way_hit & ~line_addr ? CacheMem_2_0_0 : _GEN_41; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_43 = 2'h2 == set_addr & ~way_hit & line_addr ? CacheMem_2_0_1 : _GEN_42; // @[Cache.scala 129:{15,15}]
  wire  _GEN_526 = 2'h2 == set_addr & way_hit; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_44 = 2'h2 == set_addr & way_hit & ~line_addr ? CacheMem_2_1_0 : _GEN_43; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_45 = 2'h2 == set_addr & way_hit & line_addr ? CacheMem_2_1_1 : _GEN_44; // @[Cache.scala 129:{15,15}]
  wire  _GEN_530 = 2'h3 == set_addr; // @[Cache.scala 129:{15,15}]
  wire  _GEN_532 = 2'h3 == set_addr & ~way_hit; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_46 = 2'h3 == set_addr & ~way_hit & ~line_addr ? CacheMem_3_0_0 : _GEN_45; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_47 = 2'h3 == set_addr & ~way_hit & line_addr ? CacheMem_3_0_1 : _GEN_46; // @[Cache.scala 129:{15,15}]
  wire  _GEN_538 = 2'h3 == set_addr & way_hit; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_48 = 2'h3 == set_addr & way_hit & ~line_addr ? CacheMem_3_1_0 : _GEN_47; // @[Cache.scala 129:{15,15}]
  wire [31:0] _GEN_49 = 2'h3 == set_addr & way_hit & line_addr ? CacheMem_3_1_1 : _GEN_48; // @[Cache.scala 129:{15,15}]
  wire [31:0] _CacheMem_T_1 = {24'h0,io_writedata[7:0]}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_50 = _GEN_500 & _GEN_503 ? _CacheMem_T_1 : CacheMem_0_0_0; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_51 = _GEN_500 & line_addr ? _CacheMem_T_1 : CacheMem_0_0_1; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_52 = _GEN_502 & _GEN_503 ? _CacheMem_T_1 : CacheMem_0_1_0; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_53 = _GEN_502 & line_addr ? _CacheMem_T_1 : CacheMem_0_1_1; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_54 = _GEN_508 & _GEN_503 ? _CacheMem_T_1 : CacheMem_1_0_0; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_55 = _GEN_508 & line_addr ? _CacheMem_T_1 : CacheMem_1_0_1; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_56 = _GEN_514 & _GEN_503 ? _CacheMem_T_1 : CacheMem_1_1_0; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_57 = _GEN_514 & line_addr ? _CacheMem_T_1 : CacheMem_1_1_1; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_58 = _GEN_520 & _GEN_503 ? _CacheMem_T_1 : CacheMem_2_0_0; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_59 = _GEN_520 & line_addr ? _CacheMem_T_1 : CacheMem_2_0_1; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_60 = _GEN_526 & _GEN_503 ? _CacheMem_T_1 : CacheMem_2_1_0; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_61 = _GEN_526 & line_addr ? _CacheMem_T_1 : CacheMem_2_1_1; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_62 = _GEN_532 & _GEN_503 ? _CacheMem_T_1 : CacheMem_3_0_0; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_63 = _GEN_532 & line_addr ? _CacheMem_T_1 : CacheMem_3_0_1; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_64 = _GEN_538 & _GEN_503 ? _CacheMem_T_1 : CacheMem_3_1_0; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _GEN_65 = _GEN_538 & line_addr ? _CacheMem_T_1 : CacheMem_3_1_1; // @[Cache.scala 133:{54,54} 53:25]
  wire [31:0] _CacheMem_T_3 = {16'h0,io_writedata[15:0]}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_66 = _GEN_500 & _GEN_503 ? _CacheMem_T_3 : CacheMem_0_0_0; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_67 = _GEN_500 & line_addr ? _CacheMem_T_3 : CacheMem_0_0_1; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_68 = _GEN_502 & _GEN_503 ? _CacheMem_T_3 : CacheMem_0_1_0; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_69 = _GEN_502 & line_addr ? _CacheMem_T_3 : CacheMem_0_1_1; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_70 = _GEN_508 & _GEN_503 ? _CacheMem_T_3 : CacheMem_1_0_0; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_71 = _GEN_508 & line_addr ? _CacheMem_T_3 : CacheMem_1_0_1; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_72 = _GEN_514 & _GEN_503 ? _CacheMem_T_3 : CacheMem_1_1_0; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_73 = _GEN_514 & line_addr ? _CacheMem_T_3 : CacheMem_1_1_1; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_74 = _GEN_520 & _GEN_503 ? _CacheMem_T_3 : CacheMem_2_0_0; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_75 = _GEN_520 & line_addr ? _CacheMem_T_3 : CacheMem_2_0_1; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_76 = _GEN_526 & _GEN_503 ? _CacheMem_T_3 : CacheMem_2_1_0; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_77 = _GEN_526 & line_addr ? _CacheMem_T_3 : CacheMem_2_1_1; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_78 = _GEN_532 & _GEN_503 ? _CacheMem_T_3 : CacheMem_3_0_0; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_79 = _GEN_532 & line_addr ? _CacheMem_T_3 : CacheMem_3_0_1; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_80 = _GEN_538 & _GEN_503 ? _CacheMem_T_3 : CacheMem_3_1_0; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_81 = _GEN_538 & line_addr ? _CacheMem_T_3 : CacheMem_3_1_1; // @[Cache.scala 136:{54,54} 53:25]
  wire [31:0] _GEN_82 = _GEN_500 & _GEN_503 ? io_writedata : CacheMem_0_0_0; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_83 = _GEN_500 & line_addr ? io_writedata : CacheMem_0_0_1; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_84 = _GEN_502 & _GEN_503 ? io_writedata : CacheMem_0_1_0; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_85 = _GEN_502 & line_addr ? io_writedata : CacheMem_0_1_1; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_86 = _GEN_508 & _GEN_503 ? io_writedata : CacheMem_1_0_0; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_87 = _GEN_508 & line_addr ? io_writedata : CacheMem_1_0_1; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_88 = _GEN_514 & _GEN_503 ? io_writedata : CacheMem_1_1_0; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_89 = _GEN_514 & line_addr ? io_writedata : CacheMem_1_1_1; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_90 = _GEN_520 & _GEN_503 ? io_writedata : CacheMem_2_0_0; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_91 = _GEN_520 & line_addr ? io_writedata : CacheMem_2_0_1; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_92 = _GEN_526 & _GEN_503 ? io_writedata : CacheMem_2_1_0; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_93 = _GEN_526 & line_addr ? io_writedata : CacheMem_2_1_1; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_94 = _GEN_532 & _GEN_503 ? io_writedata : CacheMem_3_0_0; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_95 = _GEN_532 & line_addr ? io_writedata : CacheMem_3_0_1; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_96 = _GEN_538 & _GEN_503 ? io_writedata : CacheMem_3_1_0; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_97 = _GEN_538 & line_addr ? io_writedata : CacheMem_3_1_1; // @[Cache.scala 139:{54,54} 53:25]
  wire [31:0] _GEN_98 = 4'hf == io_writeMask ? _GEN_82 : CacheMem_0_0_0; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_99 = 4'hf == io_writeMask ? _GEN_83 : CacheMem_0_0_1; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_100 = 4'hf == io_writeMask ? _GEN_84 : CacheMem_0_1_0; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_101 = 4'hf == io_writeMask ? _GEN_85 : CacheMem_0_1_1; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_102 = 4'hf == io_writeMask ? _GEN_86 : CacheMem_1_0_0; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_103 = 4'hf == io_writeMask ? _GEN_87 : CacheMem_1_0_1; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_104 = 4'hf == io_writeMask ? _GEN_88 : CacheMem_1_1_0; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_105 = 4'hf == io_writeMask ? _GEN_89 : CacheMem_1_1_1; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_106 = 4'hf == io_writeMask ? _GEN_90 : CacheMem_2_0_0; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_107 = 4'hf == io_writeMask ? _GEN_91 : CacheMem_2_0_1; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_108 = 4'hf == io_writeMask ? _GEN_92 : CacheMem_2_1_0; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_109 = 4'hf == io_writeMask ? _GEN_93 : CacheMem_2_1_1; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_110 = 4'hf == io_writeMask ? _GEN_94 : CacheMem_3_0_0; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_111 = 4'hf == io_writeMask ? _GEN_95 : CacheMem_3_0_1; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_112 = 4'hf == io_writeMask ? _GEN_96 : CacheMem_3_1_0; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_113 = 4'hf == io_writeMask ? _GEN_97 : CacheMem_3_1_1; // @[Cache.scala 131:31 53:25]
  wire [31:0] _GEN_114 = 4'h3 == io_writeMask ? _GEN_66 : _GEN_98; // @[Cache.scala 131:31]
  wire [31:0] _GEN_115 = 4'h3 == io_writeMask ? _GEN_67 : _GEN_99; // @[Cache.scala 131:31]
  wire [31:0] _GEN_116 = 4'h3 == io_writeMask ? _GEN_68 : _GEN_100; // @[Cache.scala 131:31]
  wire [31:0] _GEN_117 = 4'h3 == io_writeMask ? _GEN_69 : _GEN_101; // @[Cache.scala 131:31]
  wire [31:0] _GEN_118 = 4'h3 == io_writeMask ? _GEN_70 : _GEN_102; // @[Cache.scala 131:31]
  wire [31:0] _GEN_119 = 4'h3 == io_writeMask ? _GEN_71 : _GEN_103; // @[Cache.scala 131:31]
  wire [31:0] _GEN_120 = 4'h3 == io_writeMask ? _GEN_72 : _GEN_104; // @[Cache.scala 131:31]
  wire [31:0] _GEN_121 = 4'h3 == io_writeMask ? _GEN_73 : _GEN_105; // @[Cache.scala 131:31]
  wire [31:0] _GEN_122 = 4'h3 == io_writeMask ? _GEN_74 : _GEN_106; // @[Cache.scala 131:31]
  wire [31:0] _GEN_123 = 4'h3 == io_writeMask ? _GEN_75 : _GEN_107; // @[Cache.scala 131:31]
  wire [31:0] _GEN_124 = 4'h3 == io_writeMask ? _GEN_76 : _GEN_108; // @[Cache.scala 131:31]
  wire [31:0] _GEN_125 = 4'h3 == io_writeMask ? _GEN_77 : _GEN_109; // @[Cache.scala 131:31]
  wire [31:0] _GEN_126 = 4'h3 == io_writeMask ? _GEN_78 : _GEN_110; // @[Cache.scala 131:31]
  wire [31:0] _GEN_127 = 4'h3 == io_writeMask ? _GEN_79 : _GEN_111; // @[Cache.scala 131:31]
  wire [31:0] _GEN_128 = 4'h3 == io_writeMask ? _GEN_80 : _GEN_112; // @[Cache.scala 131:31]
  wire [31:0] _GEN_129 = 4'h3 == io_writeMask ? _GEN_81 : _GEN_113; // @[Cache.scala 131:31]
  wire [31:0] _GEN_130 = 4'h1 == io_writeMask ? _GEN_50 : _GEN_114; // @[Cache.scala 131:31]
  wire [31:0] _GEN_131 = 4'h1 == io_writeMask ? _GEN_51 : _GEN_115; // @[Cache.scala 131:31]
  wire [31:0] _GEN_132 = 4'h1 == io_writeMask ? _GEN_52 : _GEN_116; // @[Cache.scala 131:31]
  wire [31:0] _GEN_133 = 4'h1 == io_writeMask ? _GEN_53 : _GEN_117; // @[Cache.scala 131:31]
  wire [31:0] _GEN_134 = 4'h1 == io_writeMask ? _GEN_54 : _GEN_118; // @[Cache.scala 131:31]
  wire [31:0] _GEN_135 = 4'h1 == io_writeMask ? _GEN_55 : _GEN_119; // @[Cache.scala 131:31]
  wire [31:0] _GEN_136 = 4'h1 == io_writeMask ? _GEN_56 : _GEN_120; // @[Cache.scala 131:31]
  wire [31:0] _GEN_137 = 4'h1 == io_writeMask ? _GEN_57 : _GEN_121; // @[Cache.scala 131:31]
  wire [31:0] _GEN_138 = 4'h1 == io_writeMask ? _GEN_58 : _GEN_122; // @[Cache.scala 131:31]
  wire [31:0] _GEN_139 = 4'h1 == io_writeMask ? _GEN_59 : _GEN_123; // @[Cache.scala 131:31]
  wire [31:0] _GEN_140 = 4'h1 == io_writeMask ? _GEN_60 : _GEN_124; // @[Cache.scala 131:31]
  wire [31:0] _GEN_141 = 4'h1 == io_writeMask ? _GEN_61 : _GEN_125; // @[Cache.scala 131:31]
  wire [31:0] _GEN_142 = 4'h1 == io_writeMask ? _GEN_62 : _GEN_126; // @[Cache.scala 131:31]
  wire [31:0] _GEN_143 = 4'h1 == io_writeMask ? _GEN_63 : _GEN_127; // @[Cache.scala 131:31]
  wire [31:0] _GEN_144 = 4'h1 == io_writeMask ? _GEN_64 : _GEN_128; // @[Cache.scala 131:31]
  wire [31:0] _GEN_145 = 4'h1 == io_writeMask ? _GEN_65 : _GEN_129; // @[Cache.scala 131:31]
  wire  _GEN_146 = _GEN_500 | dirty_0_0; // @[Cache.scala 142:{36,36} 58:22]
  wire  _GEN_147 = _GEN_502 | dirty_0_1; // @[Cache.scala 142:{36,36} 58:22]
  wire  _GEN_148 = _GEN_508 | dirty_1_0; // @[Cache.scala 142:{36,36} 58:22]
  wire  _GEN_149 = _GEN_514 | dirty_1_1; // @[Cache.scala 142:{36,36} 58:22]
  wire  _GEN_150 = _GEN_520 | dirty_2_0; // @[Cache.scala 142:{36,36} 58:22]
  wire  _GEN_151 = _GEN_526 | dirty_2_1; // @[Cache.scala 142:{36,36} 58:22]
  wire  _GEN_152 = _GEN_532 | dirty_3_0; // @[Cache.scala 142:{36,36} 58:22]
  wire  _GEN_153 = _GEN_538 | dirty_3_1; // @[Cache.scala 142:{36,36} 58:22]
  wire [31:0] _GEN_154 = io_w_req ? _GEN_130 : CacheMem_0_0_0; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_155 = io_w_req ? _GEN_131 : CacheMem_0_0_1; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_156 = io_w_req ? _GEN_132 : CacheMem_0_1_0; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_157 = io_w_req ? _GEN_133 : CacheMem_0_1_1; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_158 = io_w_req ? _GEN_134 : CacheMem_1_0_0; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_159 = io_w_req ? _GEN_135 : CacheMem_1_0_1; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_160 = io_w_req ? _GEN_136 : CacheMem_1_1_0; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_161 = io_w_req ? _GEN_137 : CacheMem_1_1_1; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_162 = io_w_req ? _GEN_138 : CacheMem_2_0_0; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_163 = io_w_req ? _GEN_139 : CacheMem_2_0_1; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_164 = io_w_req ? _GEN_140 : CacheMem_2_1_0; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_165 = io_w_req ? _GEN_141 : CacheMem_2_1_1; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_166 = io_w_req ? _GEN_142 : CacheMem_3_0_0; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_167 = io_w_req ? _GEN_143 : CacheMem_3_0_1; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_168 = io_w_req ? _GEN_144 : CacheMem_3_1_0; // @[Cache.scala 130:40 53:25]
  wire [31:0] _GEN_169 = io_w_req ? _GEN_145 : CacheMem_3_1_1; // @[Cache.scala 130:40 53:25]
  wire  _GEN_170 = io_w_req ? _GEN_146 : dirty_0_0; // @[Cache.scala 130:40 58:22]
  wire  _GEN_171 = io_w_req ? _GEN_147 : dirty_0_1; // @[Cache.scala 130:40 58:22]
  wire  _GEN_172 = io_w_req ? _GEN_148 : dirty_1_0; // @[Cache.scala 130:40 58:22]
  wire  _GEN_173 = io_w_req ? _GEN_149 : dirty_1_1; // @[Cache.scala 130:40 58:22]
  wire  _GEN_174 = io_w_req ? _GEN_150 : dirty_2_0; // @[Cache.scala 130:40 58:22]
  wire  _GEN_175 = io_w_req ? _GEN_151 : dirty_2_1; // @[Cache.scala 130:40 58:22]
  wire  _GEN_176 = io_w_req ? _GEN_152 : dirty_3_0; // @[Cache.scala 130:40 58:22]
  wire  _GEN_177 = io_w_req ? _GEN_153 : dirty_3_1; // @[Cache.scala 130:40 58:22]
  wire [1:0] _GEN_178 = io_w_req ? cacheState : 2'h0; // @[Cache.scala 130:40 144:22 96:27]
  wire [31:0] _GEN_179 = io_r_req ? _GEN_49 : 32'h0; // @[Cache.scala 127:34 129:15]
  wire  wayout_choice = _GEN_25[0];
  wire  _GEN_206 = _GEN_498 & wayout_choice ? valid_0_1 : valid_0_0; // @[Cache.scala 148:{47,47}]
  wire  _GEN_708 = ~wayout_choice; // @[Cache.scala 148:{47,47}]
  wire  _GEN_207 = _GEN_506 & ~wayout_choice ? valid_1_0 : _GEN_206; // @[Cache.scala 148:{47,47}]
  wire  _GEN_208 = _GEN_506 & wayout_choice ? valid_1_1 : _GEN_207; // @[Cache.scala 148:{47,47}]
  wire  _GEN_209 = _GEN_518 & ~wayout_choice ? valid_2_0 : _GEN_208; // @[Cache.scala 148:{47,47}]
  wire  _GEN_210 = _GEN_518 & wayout_choice ? valid_2_1 : _GEN_209; // @[Cache.scala 148:{47,47}]
  wire  _GEN_211 = _GEN_530 & ~wayout_choice ? valid_3_0 : _GEN_210; // @[Cache.scala 148:{47,47}]
  wire  _GEN_212 = _GEN_530 & wayout_choice ? valid_3_1 : _GEN_211; // @[Cache.scala 148:{47,47}]
  wire  _GEN_214 = _GEN_498 & wayout_choice ? dirty_0_1 : dirty_0_0; // @[Cache.scala 148:{92,92}]
  wire  _GEN_215 = _GEN_506 & ~wayout_choice ? dirty_1_0 : _GEN_214; // @[Cache.scala 148:{92,92}]
  wire  _GEN_216 = _GEN_506 & wayout_choice ? dirty_1_1 : _GEN_215; // @[Cache.scala 148:{92,92}]
  wire  _GEN_217 = _GEN_518 & ~wayout_choice ? dirty_2_0 : _GEN_216; // @[Cache.scala 148:{92,92}]
  wire  _GEN_218 = _GEN_518 & wayout_choice ? dirty_2_1 : _GEN_217; // @[Cache.scala 148:{92,92}]
  wire  _GEN_219 = _GEN_530 & ~wayout_choice ? dirty_3_0 : _GEN_218; // @[Cache.scala 148:{92,92}]
  wire  _GEN_220 = _GEN_530 & wayout_choice ? dirty_3_1 : _GEN_219; // @[Cache.scala 148:{92,92}]
  wire [8:0] _GEN_222 = _GEN_498 & wayout_choice ? cache_tags_0_1 : cache_tags_0_0; // @[Cat.scala 31:{58,58}]
  wire [8:0] _GEN_223 = _GEN_506 & _GEN_708 ? cache_tags_1_0 : _GEN_222; // @[Cat.scala 31:{58,58}]
  wire [8:0] _GEN_224 = _GEN_506 & wayout_choice ? cache_tags_1_1 : _GEN_223; // @[Cat.scala 31:{58,58}]
  wire [8:0] _GEN_225 = _GEN_518 & _GEN_708 ? cache_tags_2_0 : _GEN_224; // @[Cat.scala 31:{58,58}]
  wire [8:0] _GEN_226 = _GEN_518 & wayout_choice ? cache_tags_2_1 : _GEN_225; // @[Cat.scala 31:{58,58}]
  wire [8:0] _GEN_227 = _GEN_530 & _GEN_708 ? cache_tags_3_0 : _GEN_226; // @[Cat.scala 31:{58,58}]
  wire [8:0] _GEN_228 = _GEN_530 & wayout_choice ? cache_tags_3_1 : _GEN_227; // @[Cat.scala 31:{58,58}]
  wire [10:0] _mem_wr_addr_T = {_GEN_228,set_addr}; // @[Cat.scala 31:58]
  wire [31:0] _GEN_230 = _GEN_498 & wayout_choice ? CacheMem_0_1_0 : CacheMem_0_0_0; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_231 = _GEN_506 & _GEN_708 ? CacheMem_1_0_0 : _GEN_230; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_232 = _GEN_506 & wayout_choice ? CacheMem_1_1_0 : _GEN_231; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_233 = _GEN_518 & _GEN_708 ? CacheMem_2_0_0 : _GEN_232; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_234 = _GEN_518 & wayout_choice ? CacheMem_2_1_0 : _GEN_233; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_235 = _GEN_530 & _GEN_708 ? CacheMem_3_0_0 : _GEN_234; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_236 = _GEN_530 & wayout_choice ? CacheMem_3_1_0 : _GEN_235; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_238 = _GEN_498 & wayout_choice ? CacheMem_0_1_1 : CacheMem_0_0_1; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_239 = _GEN_506 & _GEN_708 ? CacheMem_1_0_1 : _GEN_238; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_240 = _GEN_506 & wayout_choice ? CacheMem_1_1_1 : _GEN_239; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_241 = _GEN_518 & _GEN_708 ? CacheMem_2_0_1 : _GEN_240; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_242 = _GEN_518 & wayout_choice ? CacheMem_2_1_1 : _GEN_241; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_243 = _GEN_530 & _GEN_708 ? CacheMem_3_0_1 : _GEN_242; // @[Cache.scala 151:{25,25}]
  wire [31:0] _GEN_244 = _GEN_530 & wayout_choice ? CacheMem_3_1_1 : _GEN_243; // @[Cache.scala 151:{25,25}]
  wire [1:0] _GEN_245 = _GEN_212 & _GEN_220 ? 2'h1 : 2'h2; // @[Cache.scala 148:103 149:24 153:24]
  wire [10:0] _GEN_246 = _GEN_212 & _GEN_220 ? _mem_wr_addr_T : mem_wr_addr; // @[Cache.scala 148:103 150:25 73:28]
  wire [31:0] _GEN_247 = _GEN_212 & _GEN_220 ? _GEN_236 : mem_wr_line_0; // @[Cache.scala 148:103 151:25 122:28]
  wire [31:0] _GEN_248 = _GEN_212 & _GEN_220 ? _GEN_244 : mem_wr_line_1; // @[Cache.scala 148:103 151:25 122:28]
  wire [31:0] _GEN_255 = cache_Hit ? _GEN_179 : 32'h0; // @[Cache.scala 126:22]
  wire [1:0] _GEN_287 = io_cacheAXI_gnt ? 2'h3 : cacheState; // @[Cache.scala 166:39 167:20 96:27]
  wire  _GEN_756 = 2'h0 == mem_rd_set_addr; // @[Cache.scala 172:{50,50} 56:27]
  wire [8:0] _GEN_288 = 2'h0 == mem_rd_set_addr & _GEN_708 ? mem_rd_tag_addr : cache_tags_0_0; // @[Cache.scala 172:{50,50} 56:27]
  wire [8:0] _GEN_289 = 2'h0 == mem_rd_set_addr & wayout_choice ? mem_rd_tag_addr : cache_tags_0_1; // @[Cache.scala 172:{50,50} 56:27]
  wire  _GEN_759 = 2'h1 == mem_rd_set_addr; // @[Cache.scala 172:{50,50} 56:27]
  wire [8:0] _GEN_290 = 2'h1 == mem_rd_set_addr & _GEN_708 ? mem_rd_tag_addr : cache_tags_1_0; // @[Cache.scala 172:{50,50} 56:27]
  wire [8:0] _GEN_291 = 2'h1 == mem_rd_set_addr & wayout_choice ? mem_rd_tag_addr : cache_tags_1_1; // @[Cache.scala 172:{50,50} 56:27]
  wire  _GEN_762 = 2'h2 == mem_rd_set_addr; // @[Cache.scala 172:{50,50} 56:27]
  wire [8:0] _GEN_292 = 2'h2 == mem_rd_set_addr & _GEN_708 ? mem_rd_tag_addr : cache_tags_2_0; // @[Cache.scala 172:{50,50} 56:27]
  wire [8:0] _GEN_293 = 2'h2 == mem_rd_set_addr & wayout_choice ? mem_rd_tag_addr : cache_tags_2_1; // @[Cache.scala 172:{50,50} 56:27]
  wire  _GEN_765 = 2'h3 == mem_rd_set_addr; // @[Cache.scala 172:{50,50} 56:27]
  wire [8:0] _GEN_294 = 2'h3 == mem_rd_set_addr & _GEN_708 ? mem_rd_tag_addr : cache_tags_3_0; // @[Cache.scala 172:{50,50} 56:27]
  wire [8:0] _GEN_295 = 2'h3 == mem_rd_set_addr & wayout_choice ? mem_rd_tag_addr : cache_tags_3_1; // @[Cache.scala 172:{50,50} 56:27]
  wire  _GEN_296 = _GEN_756 & _GEN_708 | valid_0_0; // @[Cache.scala 173:{45,45} 57:22]
  wire  _GEN_297 = _GEN_756 & wayout_choice | valid_0_1; // @[Cache.scala 173:{45,45} 57:22]
  wire  _GEN_298 = _GEN_759 & _GEN_708 | valid_1_0; // @[Cache.scala 173:{45,45} 57:22]
  wire  _GEN_299 = _GEN_759 & wayout_choice | valid_1_1; // @[Cache.scala 173:{45,45} 57:22]
  wire  _GEN_300 = _GEN_762 & _GEN_708 | valid_2_0; // @[Cache.scala 173:{45,45} 57:22]
  wire  _GEN_301 = _GEN_762 & wayout_choice | valid_2_1; // @[Cache.scala 173:{45,45} 57:22]
  wire  _GEN_302 = _GEN_765 & _GEN_708 | valid_3_0; // @[Cache.scala 173:{45,45} 57:22]
  wire  _GEN_303 = _GEN_765 & wayout_choice | valid_3_1; // @[Cache.scala 173:{45,45} 57:22]
  wire  _GEN_304 = _GEN_756 & _GEN_708 ? 1'h0 : dirty_0_0; // @[Cache.scala 174:{45,45} 58:22]
  wire  _GEN_305 = _GEN_756 & wayout_choice ? 1'h0 : dirty_0_1; // @[Cache.scala 174:{45,45} 58:22]
  wire  _GEN_306 = _GEN_759 & _GEN_708 ? 1'h0 : dirty_1_0; // @[Cache.scala 174:{45,45} 58:22]
  wire  _GEN_307 = _GEN_759 & wayout_choice ? 1'h0 : dirty_1_1; // @[Cache.scala 174:{45,45} 58:22]
  wire  _GEN_308 = _GEN_762 & _GEN_708 ? 1'h0 : dirty_2_0; // @[Cache.scala 174:{45,45} 58:22]
  wire  _GEN_309 = _GEN_762 & wayout_choice ? 1'h0 : dirty_2_1; // @[Cache.scala 174:{45,45} 58:22]
  wire  _GEN_310 = _GEN_765 & _GEN_708 ? 1'h0 : dirty_3_0; // @[Cache.scala 174:{45,45} 58:22]
  wire  _GEN_311 = _GEN_765 & wayout_choice ? 1'h0 : dirty_3_1; // @[Cache.scala 174:{45,45} 58:22]
  wire [31:0] _GEN_312 = _GEN_756 & _GEN_708 ? io_mem_rd_line_0 : CacheMem_0_0_0; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_313 = _GEN_756 & wayout_choice ? io_mem_rd_line_0 : CacheMem_0_1_0; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_314 = _GEN_759 & _GEN_708 ? io_mem_rd_line_0 : CacheMem_1_0_0; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_315 = _GEN_759 & wayout_choice ? io_mem_rd_line_0 : CacheMem_1_1_0; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_316 = _GEN_762 & _GEN_708 ? io_mem_rd_line_0 : CacheMem_2_0_0; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_317 = _GEN_762 & wayout_choice ? io_mem_rd_line_0 : CacheMem_2_1_0; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_318 = _GEN_765 & _GEN_708 ? io_mem_rd_line_0 : CacheMem_3_0_0; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_319 = _GEN_765 & wayout_choice ? io_mem_rd_line_0 : CacheMem_3_1_0; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_320 = _GEN_756 & _GEN_708 ? io_mem_rd_line_1 : CacheMem_0_0_1; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_321 = _GEN_756 & wayout_choice ? io_mem_rd_line_1 : CacheMem_0_1_1; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_322 = _GEN_759 & _GEN_708 ? io_mem_rd_line_1 : CacheMem_1_0_1; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_323 = _GEN_759 & wayout_choice ? io_mem_rd_line_1 : CacheMem_1_1_1; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_324 = _GEN_762 & _GEN_708 ? io_mem_rd_line_1 : CacheMem_2_0_1; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_325 = _GEN_762 & wayout_choice ? io_mem_rd_line_1 : CacheMem_2_1_1; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_326 = _GEN_765 & _GEN_708 ? io_mem_rd_line_1 : CacheMem_3_0_1; // @[Cache.scala 176:{55,55} 53:25]
  wire [31:0] _GEN_327 = _GEN_765 & wayout_choice ? io_mem_rd_line_1 : CacheMem_3_1_1; // @[Cache.scala 176:{55,55} 53:25]
  wire [1:0] _GEN_328 = _T_9 ? 2'h0 : cacheState; // @[Cache.scala 124:21 171:18 96:27]
  wire [8:0] _GEN_329 = _T_9 ? _GEN_288 : cache_tags_0_0; // @[Cache.scala 124:21 56:27]
  wire [8:0] _GEN_330 = _T_9 ? _GEN_289 : cache_tags_0_1; // @[Cache.scala 124:21 56:27]
  wire [8:0] _GEN_331 = _T_9 ? _GEN_290 : cache_tags_1_0; // @[Cache.scala 124:21 56:27]
  wire [8:0] _GEN_332 = _T_9 ? _GEN_291 : cache_tags_1_1; // @[Cache.scala 124:21 56:27]
  wire [8:0] _GEN_333 = _T_9 ? _GEN_292 : cache_tags_2_0; // @[Cache.scala 124:21 56:27]
  wire [8:0] _GEN_334 = _T_9 ? _GEN_293 : cache_tags_2_1; // @[Cache.scala 124:21 56:27]
  wire [8:0] _GEN_335 = _T_9 ? _GEN_294 : cache_tags_3_0; // @[Cache.scala 124:21 56:27]
  wire [8:0] _GEN_336 = _T_9 ? _GEN_295 : cache_tags_3_1; // @[Cache.scala 124:21 56:27]
  wire  _GEN_337 = _T_9 ? _GEN_296 : valid_0_0; // @[Cache.scala 124:21 57:22]
  wire  _GEN_338 = _T_9 ? _GEN_297 : valid_0_1; // @[Cache.scala 124:21 57:22]
  wire  _GEN_339 = _T_9 ? _GEN_298 : valid_1_0; // @[Cache.scala 124:21 57:22]
  wire  _GEN_340 = _T_9 ? _GEN_299 : valid_1_1; // @[Cache.scala 124:21 57:22]
  wire  _GEN_341 = _T_9 ? _GEN_300 : valid_2_0; // @[Cache.scala 124:21 57:22]
  wire  _GEN_342 = _T_9 ? _GEN_301 : valid_2_1; // @[Cache.scala 124:21 57:22]
  wire  _GEN_343 = _T_9 ? _GEN_302 : valid_3_0; // @[Cache.scala 124:21 57:22]
  wire  _GEN_344 = _T_9 ? _GEN_303 : valid_3_1; // @[Cache.scala 124:21 57:22]
  wire  _GEN_345 = _T_9 ? _GEN_304 : dirty_0_0; // @[Cache.scala 124:21 58:22]
  wire  _GEN_346 = _T_9 ? _GEN_305 : dirty_0_1; // @[Cache.scala 124:21 58:22]
  wire  _GEN_347 = _T_9 ? _GEN_306 : dirty_1_0; // @[Cache.scala 124:21 58:22]
  wire  _GEN_348 = _T_9 ? _GEN_307 : dirty_1_1; // @[Cache.scala 124:21 58:22]
  wire  _GEN_349 = _T_9 ? _GEN_308 : dirty_2_0; // @[Cache.scala 124:21 58:22]
  wire  _GEN_350 = _T_9 ? _GEN_309 : dirty_2_1; // @[Cache.scala 124:21 58:22]
  wire  _GEN_351 = _T_9 ? _GEN_310 : dirty_3_0; // @[Cache.scala 124:21 58:22]
  wire  _GEN_352 = _T_9 ? _GEN_311 : dirty_3_1; // @[Cache.scala 124:21 58:22]
  wire [31:0] _GEN_353 = _T_9 ? _GEN_312 : CacheMem_0_0_0; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_354 = _T_9 ? _GEN_313 : CacheMem_0_1_0; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_355 = _T_9 ? _GEN_314 : CacheMem_1_0_0; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_356 = _T_9 ? _GEN_315 : CacheMem_1_1_0; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_357 = _T_9 ? _GEN_316 : CacheMem_2_0_0; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_358 = _T_9 ? _GEN_317 : CacheMem_2_1_0; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_359 = _T_9 ? _GEN_318 : CacheMem_3_0_0; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_360 = _T_9 ? _GEN_319 : CacheMem_3_1_0; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_361 = _T_9 ? _GEN_320 : CacheMem_0_0_1; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_362 = _T_9 ? _GEN_321 : CacheMem_0_1_1; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_363 = _T_9 ? _GEN_322 : CacheMem_1_0_1; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_364 = _T_9 ? _GEN_323 : CacheMem_1_1_1; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_365 = _T_9 ? _GEN_324 : CacheMem_2_0_1; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_366 = _T_9 ? _GEN_325 : CacheMem_2_1_1; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_367 = _T_9 ? _GEN_326 : CacheMem_3_0_1; // @[Cache.scala 124:21 53:25]
  wire [31:0] _GEN_368 = _T_9 ? _GEN_327 : CacheMem_3_1_1; // @[Cache.scala 124:21 53:25]
  wire [10:0] _io_mem_addr_T_1 = io_mem_wr_req ? mem_wr_addr : 11'h0; // @[Cache.scala 189:64]
  assign io_outdata = 2'h0 == cacheState ? _GEN_255 : 32'h0; // @[Cache.scala 124:21]
  assign io_miss = (io_r_req | io_w_req) & ~(cache_Hit & cacheState == 2'h0); // @[Cache.scala 194:36]
  assign io_mem_addr = io_mem_rd_req ? mem_rd_addr : _io_mem_addr_T_1; // @[Cache.scala 189:21]
  assign io_mem_rd_req = cacheState == 2'h2; // @[Cache.scala 185:35]
  assign io_mem_wr_req = cacheState == 2'h1; // @[Cache.scala 186:35]
  assign io_mem_wr_line_0 = mem_wr_line_0; // @[Cache.scala 193:18]
  assign io_mem_wr_line_1 = mem_wr_line_1; // @[Cache.scala 193:18]
  always @(posedge clock) begin
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_0_0_0 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_0_0_0 <= _GEN_154;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_0_0_0 <= _GEN_353;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_0_0_1 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_0_0_1 <= _GEN_155;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_0_0_1 <= _GEN_361;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_0_1_0 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_0_1_0 <= _GEN_156;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_0_1_0 <= _GEN_354;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_0_1_1 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_0_1_1 <= _GEN_157;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_0_1_1 <= _GEN_362;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_1_0_0 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_1_0_0 <= _GEN_158;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_1_0_0 <= _GEN_355;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_1_0_1 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_1_0_1 <= _GEN_159;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_1_0_1 <= _GEN_363;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_1_1_0 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_1_1_0 <= _GEN_160;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_1_1_0 <= _GEN_356;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_1_1_1 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_1_1_1 <= _GEN_161;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_1_1_1 <= _GEN_364;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_2_0_0 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_2_0_0 <= _GEN_162;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_2_0_0 <= _GEN_357;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_2_0_1 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_2_0_1 <= _GEN_163;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_2_0_1 <= _GEN_365;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_2_1_0 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_2_1_0 <= _GEN_164;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_2_1_0 <= _GEN_358;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_2_1_1 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_2_1_1 <= _GEN_165;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_2_1_1 <= _GEN_366;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_3_0_0 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_3_0_0 <= _GEN_166;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_3_0_0 <= _GEN_359;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_3_0_1 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_3_0_1 <= _GEN_167;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_3_0_1 <= _GEN_367;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_3_1_0 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_3_1_0 <= _GEN_168;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_3_1_0 <= _GEN_360;
      end
    end
    if (reset) begin // @[Cache.scala 53:25]
      CacheMem_3_1_1 <= 32'h0; // @[Cache.scala 53:25]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          CacheMem_3_1_1 <= _GEN_169;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        CacheMem_3_1_1 <= _GEN_368;
      end
    end
    if (reset) begin // @[Cache.scala 56:27]
      cache_tags_0_0 <= 9'h0; // @[Cache.scala 56:27]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          cache_tags_0_0 <= _GEN_329;
        end
      end
    end
    if (reset) begin // @[Cache.scala 56:27]
      cache_tags_0_1 <= 9'h0; // @[Cache.scala 56:27]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          cache_tags_0_1 <= _GEN_330;
        end
      end
    end
    if (reset) begin // @[Cache.scala 56:27]
      cache_tags_1_0 <= 9'h0; // @[Cache.scala 56:27]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          cache_tags_1_0 <= _GEN_331;
        end
      end
    end
    if (reset) begin // @[Cache.scala 56:27]
      cache_tags_1_1 <= 9'h0; // @[Cache.scala 56:27]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          cache_tags_1_1 <= _GEN_332;
        end
      end
    end
    if (reset) begin // @[Cache.scala 56:27]
      cache_tags_2_0 <= 9'h0; // @[Cache.scala 56:27]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          cache_tags_2_0 <= _GEN_333;
        end
      end
    end
    if (reset) begin // @[Cache.scala 56:27]
      cache_tags_2_1 <= 9'h0; // @[Cache.scala 56:27]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          cache_tags_2_1 <= _GEN_334;
        end
      end
    end
    if (reset) begin // @[Cache.scala 56:27]
      cache_tags_3_0 <= 9'h0; // @[Cache.scala 56:27]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          cache_tags_3_0 <= _GEN_335;
        end
      end
    end
    if (reset) begin // @[Cache.scala 56:27]
      cache_tags_3_1 <= 9'h0; // @[Cache.scala 56:27]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          cache_tags_3_1 <= _GEN_336;
        end
      end
    end
    if (reset) begin // @[Cache.scala 57:22]
      valid_0_0 <= 1'h0; // @[Cache.scala 57:22]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          valid_0_0 <= _GEN_337;
        end
      end
    end
    if (reset) begin // @[Cache.scala 57:22]
      valid_0_1 <= 1'h0; // @[Cache.scala 57:22]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          valid_0_1 <= _GEN_338;
        end
      end
    end
    if (reset) begin // @[Cache.scala 57:22]
      valid_1_0 <= 1'h0; // @[Cache.scala 57:22]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          valid_1_0 <= _GEN_339;
        end
      end
    end
    if (reset) begin // @[Cache.scala 57:22]
      valid_1_1 <= 1'h0; // @[Cache.scala 57:22]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          valid_1_1 <= _GEN_340;
        end
      end
    end
    if (reset) begin // @[Cache.scala 57:22]
      valid_2_0 <= 1'h0; // @[Cache.scala 57:22]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          valid_2_0 <= _GEN_341;
        end
      end
    end
    if (reset) begin // @[Cache.scala 57:22]
      valid_2_1 <= 1'h0; // @[Cache.scala 57:22]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          valid_2_1 <= _GEN_342;
        end
      end
    end
    if (reset) begin // @[Cache.scala 57:22]
      valid_3_0 <= 1'h0; // @[Cache.scala 57:22]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          valid_3_0 <= _GEN_343;
        end
      end
    end
    if (reset) begin // @[Cache.scala 57:22]
      valid_3_1 <= 1'h0; // @[Cache.scala 57:22]
    end else if (!(2'h0 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
        if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
          valid_3_1 <= _GEN_344;
        end
      end
    end
    if (reset) begin // @[Cache.scala 58:22]
      dirty_0_0 <= 1'h0; // @[Cache.scala 58:22]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          dirty_0_0 <= _GEN_170;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        dirty_0_0 <= _GEN_345;
      end
    end
    if (reset) begin // @[Cache.scala 58:22]
      dirty_0_1 <= 1'h0; // @[Cache.scala 58:22]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          dirty_0_1 <= _GEN_171;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        dirty_0_1 <= _GEN_346;
      end
    end
    if (reset) begin // @[Cache.scala 58:22]
      dirty_1_0 <= 1'h0; // @[Cache.scala 58:22]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          dirty_1_0 <= _GEN_172;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        dirty_1_0 <= _GEN_347;
      end
    end
    if (reset) begin // @[Cache.scala 58:22]
      dirty_1_1 <= 1'h0; // @[Cache.scala 58:22]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          dirty_1_1 <= _GEN_173;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        dirty_1_1 <= _GEN_348;
      end
    end
    if (reset) begin // @[Cache.scala 58:22]
      dirty_2_0 <= 1'h0; // @[Cache.scala 58:22]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          dirty_2_0 <= _GEN_174;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        dirty_2_0 <= _GEN_349;
      end
    end
    if (reset) begin // @[Cache.scala 58:22]
      dirty_2_1 <= 1'h0; // @[Cache.scala 58:22]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          dirty_2_1 <= _GEN_175;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        dirty_2_1 <= _GEN_350;
      end
    end
    if (reset) begin // @[Cache.scala 58:22]
      dirty_3_0 <= 1'h0; // @[Cache.scala 58:22]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          dirty_3_0 <= _GEN_176;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        dirty_3_0 <= _GEN_351;
      end
    end
    if (reset) begin // @[Cache.scala 58:22]
      dirty_3_1 <= 1'h0; // @[Cache.scala 58:22]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          dirty_3_1 <= _GEN_177;
        end
      end
    end else if (!(2'h1 == cacheState)) begin // @[Cache.scala 124:21]
      if (!(2'h2 == cacheState)) begin // @[Cache.scala 124:21]
        dirty_3_1 <= _GEN_352;
      end
    end
    if (reset) begin // @[Cache.scala 70:32]
      mem_rd_set_addr <= 2'h0; // @[Cache.scala 70:32]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (!(cache_Hit)) begin // @[Cache.scala 126:22]
        if (_T) begin // @[Cache.scala 147:34]
          mem_rd_set_addr <= set_addr; // @[Cache.scala 156:27]
        end
      end
    end
    if (reset) begin // @[Cache.scala 71:32]
      mem_rd_tag_addr <= 9'h0; // @[Cache.scala 71:32]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (!(cache_Hit)) begin // @[Cache.scala 126:22]
        if (_T) begin // @[Cache.scala 147:34]
          mem_rd_tag_addr <= tag_addr; // @[Cache.scala 155:27]
        end
      end
    end
    if (reset) begin // @[Cache.scala 73:28]
      mem_wr_addr <= 11'h0; // @[Cache.scala 73:28]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (!(cache_Hit)) begin // @[Cache.scala 126:22]
        if (_T) begin // @[Cache.scala 147:34]
          mem_wr_addr <= _GEN_246;
        end
      end
    end
    if (reset) begin // @[Cache.scala 96:27]
      cacheState <= 2'h0; // @[Cache.scala 96:27]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (cache_Hit) begin // @[Cache.scala 126:22]
        if (!(io_r_req)) begin // @[Cache.scala 127:34]
          cacheState <= _GEN_178;
        end
      end else if (_T) begin // @[Cache.scala 147:34]
        cacheState <= _GEN_245;
      end
    end else if (2'h1 == cacheState) begin // @[Cache.scala 124:21]
      if (io_cacheAXI_gnt) begin // @[Cache.scala 161:39]
        cacheState <= 2'h2; // @[Cache.scala 162:20]
      end
    end else if (2'h2 == cacheState) begin // @[Cache.scala 124:21]
      cacheState <= _GEN_287;
    end else begin
      cacheState <= _GEN_328;
    end
    if (reset) begin // @[Cache.scala 103:30]
      FIFO_Choice_0 <= 32'h0; // @[Cache.scala 103:30]
    end else if (2'h3 == cacheState) begin // @[Cache.scala 104:23]
      if (2'h0 == set_addr) begin // @[Cache.scala 106:31]
        FIFO_Choice_0 <= _FIFO_Choice_set_addr_0; // @[Cache.scala 106:31]
      end
    end
    if (reset) begin // @[Cache.scala 103:30]
      FIFO_Choice_1 <= 32'h0; // @[Cache.scala 103:30]
    end else if (2'h3 == cacheState) begin // @[Cache.scala 104:23]
      if (2'h1 == set_addr) begin // @[Cache.scala 106:31]
        FIFO_Choice_1 <= _FIFO_Choice_set_addr_0; // @[Cache.scala 106:31]
      end
    end
    if (reset) begin // @[Cache.scala 103:30]
      FIFO_Choice_2 <= 32'h0; // @[Cache.scala 103:30]
    end else if (2'h3 == cacheState) begin // @[Cache.scala 104:23]
      if (2'h2 == set_addr) begin // @[Cache.scala 106:31]
        FIFO_Choice_2 <= _FIFO_Choice_set_addr_0; // @[Cache.scala 106:31]
      end
    end
    if (reset) begin // @[Cache.scala 103:30]
      FIFO_Choice_3 <= 32'h0; // @[Cache.scala 103:30]
    end else if (2'h3 == cacheState) begin // @[Cache.scala 104:23]
      if (2'h3 == set_addr) begin // @[Cache.scala 106:31]
        FIFO_Choice_3 <= _FIFO_Choice_set_addr_0; // @[Cache.scala 106:31]
      end
    end
    if (reset) begin // @[Cache.scala 122:28]
      mem_wr_line_0 <= 32'h0; // @[Cache.scala 122:28]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (!(cache_Hit)) begin // @[Cache.scala 126:22]
        if (_T) begin // @[Cache.scala 147:34]
          mem_wr_line_0 <= _GEN_247;
        end
      end
    end
    if (reset) begin // @[Cache.scala 122:28]
      mem_wr_line_1 <= 32'h0; // @[Cache.scala 122:28]
    end else if (2'h0 == cacheState) begin // @[Cache.scala 124:21]
      if (!(cache_Hit)) begin // @[Cache.scala 126:22]
        if (_T) begin // @[Cache.scala 147:34]
          mem_wr_line_1 <= _GEN_248;
        end
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  CacheMem_0_0_0 = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  CacheMem_0_0_1 = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  CacheMem_0_1_0 = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  CacheMem_0_1_1 = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  CacheMem_1_0_0 = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  CacheMem_1_0_1 = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  CacheMem_1_1_0 = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  CacheMem_1_1_1 = _RAND_7[31:0];
  _RAND_8 = {1{`RANDOM}};
  CacheMem_2_0_0 = _RAND_8[31:0];
  _RAND_9 = {1{`RANDOM}};
  CacheMem_2_0_1 = _RAND_9[31:0];
  _RAND_10 = {1{`RANDOM}};
  CacheMem_2_1_0 = _RAND_10[31:0];
  _RAND_11 = {1{`RANDOM}};
  CacheMem_2_1_1 = _RAND_11[31:0];
  _RAND_12 = {1{`RANDOM}};
  CacheMem_3_0_0 = _RAND_12[31:0];
  _RAND_13 = {1{`RANDOM}};
  CacheMem_3_0_1 = _RAND_13[31:0];
  _RAND_14 = {1{`RANDOM}};
  CacheMem_3_1_0 = _RAND_14[31:0];
  _RAND_15 = {1{`RANDOM}};
  CacheMem_3_1_1 = _RAND_15[31:0];
  _RAND_16 = {1{`RANDOM}};
  cache_tags_0_0 = _RAND_16[8:0];
  _RAND_17 = {1{`RANDOM}};
  cache_tags_0_1 = _RAND_17[8:0];
  _RAND_18 = {1{`RANDOM}};
  cache_tags_1_0 = _RAND_18[8:0];
  _RAND_19 = {1{`RANDOM}};
  cache_tags_1_1 = _RAND_19[8:0];
  _RAND_20 = {1{`RANDOM}};
  cache_tags_2_0 = _RAND_20[8:0];
  _RAND_21 = {1{`RANDOM}};
  cache_tags_2_1 = _RAND_21[8:0];
  _RAND_22 = {1{`RANDOM}};
  cache_tags_3_0 = _RAND_22[8:0];
  _RAND_23 = {1{`RANDOM}};
  cache_tags_3_1 = _RAND_23[8:0];
  _RAND_24 = {1{`RANDOM}};
  valid_0_0 = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  valid_0_1 = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  valid_1_0 = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  valid_1_1 = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  valid_2_0 = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  valid_2_1 = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  valid_3_0 = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  valid_3_1 = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  dirty_0_0 = _RAND_32[0:0];
  _RAND_33 = {1{`RANDOM}};
  dirty_0_1 = _RAND_33[0:0];
  _RAND_34 = {1{`RANDOM}};
  dirty_1_0 = _RAND_34[0:0];
  _RAND_35 = {1{`RANDOM}};
  dirty_1_1 = _RAND_35[0:0];
  _RAND_36 = {1{`RANDOM}};
  dirty_2_0 = _RAND_36[0:0];
  _RAND_37 = {1{`RANDOM}};
  dirty_2_1 = _RAND_37[0:0];
  _RAND_38 = {1{`RANDOM}};
  dirty_3_0 = _RAND_38[0:0];
  _RAND_39 = {1{`RANDOM}};
  dirty_3_1 = _RAND_39[0:0];
  _RAND_40 = {1{`RANDOM}};
  mem_rd_set_addr = _RAND_40[1:0];
  _RAND_41 = {1{`RANDOM}};
  mem_rd_tag_addr = _RAND_41[8:0];
  _RAND_42 = {1{`RANDOM}};
  mem_wr_addr = _RAND_42[10:0];
  _RAND_43 = {1{`RANDOM}};
  cacheState = _RAND_43[1:0];
  _RAND_44 = {1{`RANDOM}};
  FIFO_Choice_0 = _RAND_44[31:0];
  _RAND_45 = {1{`RANDOM}};
  FIFO_Choice_1 = _RAND_45[31:0];
  _RAND_46 = {1{`RANDOM}};
  FIFO_Choice_2 = _RAND_46[31:0];
  _RAND_47 = {1{`RANDOM}};
  FIFO_Choice_3 = _RAND_47[31:0];
  _RAND_48 = {1{`RANDOM}};
  mem_wr_line_0 = _RAND_48[31:0];
  _RAND_49 = {1{`RANDOM}};
  mem_wr_line_1 = _RAND_49[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module CacheAXI(
  input         clock,
  input         reset,
  input  [10:0] io_mem_addr,
  input         io_mem_rd_req,
  input         io_mem_wr_req,
  input  [31:0] io_mem_wr_line_0,
  input  [31:0] io_mem_wr_line_1,
  output [31:0] io_mem_rd_line_0,
  output [31:0] io_mem_rd_line_1,
  output        io_cacheAXI_gnt,
  output        io_TVALID,
  output        io_TLAST,
  input         io_TREADY,
  input  [31:0] io_TDATAR,
  output [31:0] io_TDATAW,
  output [1:0]  io_TUSER
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] transferCounter; // @[CacheAXI.scala 45:32]
  reg [1:0] cacheAXIState; // @[CacheAXI.scala 47:30]
  reg [31:0] rdLine_0; // @[CacheAXI.scala 55:23]
  reg [31:0] rdLine_1; // @[CacheAXI.scala 55:23]
  wire [1:0] _GEN_0 = io_TREADY ? 2'h1 : cacheAXIState; // @[CacheAXI.scala 64:35 65:25 47:30]
  wire [1:0] _GEN_1 = io_mem_rd_req ? _GEN_0 : cacheAXIState; // @[CacheAXI.scala 47:30 63:37]
  wire  _T_11 = transferCounter <= 32'h2; // @[CacheAXI.scala 78:30]
  wire  _T_12 = transferCounter == 32'h0; // @[CacheAXI.scala 80:32]
  wire [31:0] _TDATAW_T = {18'h0,io_mem_addr,3'h0}; // @[Cat.scala 31:58]
  wire [31:0] _T_14 = transferCounter - 32'h1; // @[CacheAXI.scala 83:35]
  wire [31:0] _GEN_4 = ~_T_14[0] ? io_TDATAR : rdLine_0; // @[CacheAXI.scala 55:23 83:{41,41}]
  wire [31:0] _GEN_5 = _T_14[0] ? io_TDATAR : rdLine_1; // @[CacheAXI.scala 55:23 83:{41,41}]
  wire [31:0] _GEN_6 = transferCounter == 32'h0 ? _TDATAW_T : 32'h0; // @[CacheAXI.scala 80:40 81:20]
  wire [31:0] _GEN_7 = transferCounter == 32'h0 ? rdLine_0 : _GEN_4; // @[CacheAXI.scala 55:23 80:40]
  wire [31:0] _GEN_8 = transferCounter == 32'h0 ? rdLine_1 : _GEN_5; // @[CacheAXI.scala 55:23 80:40]
  wire [31:0] _transferCounter_T_1 = transferCounter + 32'h1; // @[CacheAXI.scala 85:46]
  wire [31:0] _GEN_10 = transferCounter <= 32'h2 ? _GEN_6 : 32'h0; // @[CacheAXI.scala 78:55]
  wire [31:0] _GEN_11 = transferCounter <= 32'h2 ? _GEN_7 : rdLine_0; // @[CacheAXI.scala 55:23 78:55]
  wire [31:0] _GEN_12 = transferCounter <= 32'h2 ? _GEN_8 : rdLine_1; // @[CacheAXI.scala 55:23 78:55]
  wire [31:0] _GEN_13 = transferCounter <= 32'h2 ? _transferCounter_T_1 : transferCounter; // @[CacheAXI.scala 78:55 85:27 45:32]
  wire  _GEN_14 = transferCounter <= 32'h2 ? 1'h0 : 1'h1; // @[CacheAXI.scala 78:55 88:17]
  wire [1:0] _GEN_15 = transferCounter <= 32'h2 ? cacheAXIState : 2'h3; // @[CacheAXI.scala 47:30 78:55 89:25]
  wire  _GEN_16 = io_TREADY & _T_11; // @[CacheAXI.scala 77:33]
  wire [31:0] _GEN_17 = io_TREADY ? _GEN_10 : 32'h0; // @[CacheAXI.scala 77:33]
  wire [31:0] _GEN_20 = io_TREADY ? _GEN_13 : transferCounter; // @[CacheAXI.scala 45:32 77:33]
  wire  _GEN_21 = io_TREADY & _GEN_14; // @[CacheAXI.scala 77:33]
  wire [1:0] _GEN_22 = io_TREADY ? _GEN_15 : cacheAXIState; // @[CacheAXI.scala 47:30 77:33]
  wire [31:0] _GEN_24 = _T_14[0] ? io_mem_wr_line_1 : io_mem_wr_line_0; // @[CacheAXI.scala 103:{20,20}]
  wire [31:0] _GEN_25 = _T_12 ? _TDATAW_T : _GEN_24; // @[CacheAXI.scala 100:40 101:20 103:20]
  wire [31:0] _GEN_27 = _T_11 ? _GEN_25 : 32'h0; // @[CacheAXI.scala 98:54]
  wire [31:0] _GEN_32 = io_TREADY ? _GEN_27 : 32'h0; // @[CacheAXI.scala 97:33]
  wire [1:0] _GEN_37 = 2'h3 == cacheAXIState ? 2'h0 : cacheAXIState; // @[CacheAXI.scala 116:21 57:24 47:30]
  wire [1:0] _GEN_38 = 2'h2 == cacheAXIState ? 2'h2 : 2'h0; // @[CacheAXI.scala 57:24 96:13]
  wire [31:0] _GEN_40 = 2'h2 == cacheAXIState ? _GEN_32 : 32'h0; // @[CacheAXI.scala 57:24]
  wire [1:0] _GEN_44 = 2'h1 == cacheAXIState ? 2'h1 : _GEN_38; // @[CacheAXI.scala 57:24 76:13]
  wire  _GEN_45 = 2'h1 == cacheAXIState ? _GEN_16 : 2'h2 == cacheAXIState & _GEN_16; // @[CacheAXI.scala 57:24]
  wire [31:0] _GEN_46 = 2'h1 == cacheAXIState ? _GEN_17 : _GEN_40; // @[CacheAXI.scala 57:24]
  wire  _GEN_50 = 2'h1 == cacheAXIState ? _GEN_21 : 2'h2 == cacheAXIState & _GEN_21; // @[CacheAXI.scala 57:24]
  assign io_mem_rd_line_0 = rdLine_0; // @[CacheAXI.scala 124:18]
  assign io_mem_rd_line_1 = rdLine_1; // @[CacheAXI.scala 124:18]
  assign io_cacheAXI_gnt = cacheAXIState == 2'h3; // @[CacheAXI.scala 125:40]
  assign io_TVALID = 2'h0 == cacheAXIState ? 1'h0 : _GEN_45; // @[CacheAXI.scala 57:24 59:14]
  assign io_TLAST = 2'h0 == cacheAXIState ? 1'h0 : _GEN_50; // @[CacheAXI.scala 57:24 60:13]
  assign io_TDATAW = 2'h0 == cacheAXIState ? 32'h0 : _GEN_46; // @[CacheAXI.scala 57:24]
  assign io_TUSER = 2'h0 == cacheAXIState ? 2'h0 : _GEN_44; // @[CacheAXI.scala 57:24 62:13]
  always @(posedge clock) begin
    if (reset) begin // @[CacheAXI.scala 45:32]
      transferCounter <= 32'h0; // @[CacheAXI.scala 45:32]
    end else if (2'h0 == cacheAXIState) begin // @[CacheAXI.scala 57:24]
      transferCounter <= 32'h0; // @[CacheAXI.scala 61:23]
    end else if (2'h1 == cacheAXIState) begin // @[CacheAXI.scala 57:24]
      transferCounter <= _GEN_20;
    end else if (2'h2 == cacheAXIState) begin // @[CacheAXI.scala 57:24]
      transferCounter <= _GEN_20;
    end
    if (reset) begin // @[CacheAXI.scala 47:30]
      cacheAXIState <= 2'h0; // @[CacheAXI.scala 47:30]
    end else if (2'h0 == cacheAXIState) begin // @[CacheAXI.scala 57:24]
      if (io_mem_wr_req) begin // @[CacheAXI.scala 68:37]
        if (io_TREADY) begin // @[CacheAXI.scala 69:35]
          cacheAXIState <= 2'h2; // @[CacheAXI.scala 70:25]
        end else begin
          cacheAXIState <= _GEN_1;
        end
      end else begin
        cacheAXIState <= _GEN_1;
      end
    end else if (2'h1 == cacheAXIState) begin // @[CacheAXI.scala 57:24]
      cacheAXIState <= _GEN_22;
    end else if (2'h2 == cacheAXIState) begin // @[CacheAXI.scala 57:24]
      cacheAXIState <= _GEN_22;
    end else begin
      cacheAXIState <= _GEN_37;
    end
    if (reset) begin // @[CacheAXI.scala 55:23]
      rdLine_0 <= 32'h0; // @[CacheAXI.scala 55:23]
    end else if (!(2'h0 == cacheAXIState)) begin // @[CacheAXI.scala 57:24]
      if (2'h1 == cacheAXIState) begin // @[CacheAXI.scala 57:24]
        if (io_TREADY) begin // @[CacheAXI.scala 77:33]
          rdLine_0 <= _GEN_11;
        end
      end
    end
    if (reset) begin // @[CacheAXI.scala 55:23]
      rdLine_1 <= 32'h0; // @[CacheAXI.scala 55:23]
    end else if (!(2'h0 == cacheAXIState)) begin // @[CacheAXI.scala 57:24]
      if (2'h1 == cacheAXIState) begin // @[CacheAXI.scala 57:24]
        if (io_TREADY) begin // @[CacheAXI.scala 77:33]
          rdLine_1 <= _GEN_12;
        end
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  transferCounter = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  cacheAXIState = _RAND_1[1:0];
  _RAND_2 = {1{`RANDOM}};
  rdLine_0 = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  rdLine_1 = _RAND_3[31:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SinglePortRAM(
  input         clock,
  input  [9:0]  io_addr,
  input  [31:0] io_dataIn,
  input         io_we,
  output [31:0] io_dataOut
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  reg [31:0] syncRAM [0:8191]; // @[Memory.scala 23:28]
  wire  syncRAM_io_dataOut_MPORT_en; // @[Memory.scala 23:28]
  wire [12:0] syncRAM_io_dataOut_MPORT_addr; // @[Memory.scala 23:28]
  wire [31:0] syncRAM_io_dataOut_MPORT_data; // @[Memory.scala 23:28]
  wire [31:0] syncRAM_MPORT_data; // @[Memory.scala 23:28]
  wire [12:0] syncRAM_MPORT_addr; // @[Memory.scala 23:28]
  wire  syncRAM_MPORT_mask; // @[Memory.scala 23:28]
  wire  syncRAM_MPORT_en; // @[Memory.scala 23:28]
  reg  syncRAM_io_dataOut_MPORT_en_pipe_0;
  reg [12:0] syncRAM_io_dataOut_MPORT_addr_pipe_0;
  assign syncRAM_io_dataOut_MPORT_en = syncRAM_io_dataOut_MPORT_en_pipe_0;
  assign syncRAM_io_dataOut_MPORT_addr = syncRAM_io_dataOut_MPORT_addr_pipe_0;
  assign syncRAM_io_dataOut_MPORT_data = syncRAM[syncRAM_io_dataOut_MPORT_addr]; // @[Memory.scala 23:28]
  assign syncRAM_MPORT_data = io_dataIn;
  assign syncRAM_MPORT_addr = {{3'd0}, io_addr};
  assign syncRAM_MPORT_mask = 1'h1;
  assign syncRAM_MPORT_en = io_we;
  assign io_dataOut = syncRAM_io_dataOut_MPORT_data; // @[Memory.scala 25:17 29:18]
  always @(posedge clock) begin
    if (syncRAM_MPORT_en & syncRAM_MPORT_mask) begin
      syncRAM[syncRAM_MPORT_addr] <= syncRAM_MPORT_data; // @[Memory.scala 23:28]
    end
    if (io_we) begin
      syncRAM_io_dataOut_MPORT_en_pipe_0 <= 1'h0;
    end else begin
      syncRAM_io_dataOut_MPORT_en_pipe_0 <= 1'h1;
    end
    if (io_we ? 1'h0 : 1'h1) begin
      syncRAM_io_dataOut_MPORT_addr_pipe_0 <= {{3'd0}, io_addr};
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 8192; initvar = initvar+1)
    syncRAM[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  syncRAM_io_dataOut_MPORT_en_pipe_0 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  syncRAM_io_dataOut_MPORT_addr_pipe_0 = _RAND_2[12:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module Memory(
  input         clock,
  input         reset,
  input         io_TVALID,
  input  [31:0] io_TDATAW,
  output [31:0] io_TDATAR,
  input         io_TLAST,
  input  [1:0]  io_TUSER
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  wire  syncMem_clock; // @[Memory.scala 61:23]
  wire [9:0] syncMem_io_addr; // @[Memory.scala 61:23]
  wire [31:0] syncMem_io_dataIn; // @[Memory.scala 61:23]
  wire  syncMem_io_we; // @[Memory.scala 61:23]
  wire [31:0] syncMem_io_dataOut; // @[Memory.scala 61:23]
  reg [1:0] memState; // @[Memory.scala 67:25]
  reg [29:0] rwmemAddr; // @[Memory.scala 72:26]
  wire [1:0] _GEN_0 = io_TUSER == 2'h2 ? 2'h2 : memState; // @[Memory.scala 90:54 91:20 67:25]
  wire  _T_9 = ~io_TLAST; // @[Memory.scala 97:21]
  wire [29:0] _rwmemAddr_T_2 = rwmemAddr + 30'h1; // @[Memory.scala 102:32]
  wire [29:0] _GEN_4 = ~io_TLAST ? rwmemAddr : 30'h0; // @[Memory.scala 77:19 97:34 99:27]
  wire [31:0] _GEN_5 = ~io_TLAST ? syncMem_io_dataOut : 32'h0; // @[Memory.scala 100:18 97:34]
  wire [29:0] _GEN_6 = ~io_TLAST ? _rwmemAddr_T_2 : rwmemAddr; // @[Memory.scala 102:19 72:26 97:34]
  wire [1:0] _GEN_8 = ~io_TLAST ? memState : 2'h0; // @[Memory.scala 105:18 67:25 97:34]
  wire [31:0] _GEN_10 = _T_9 ? io_TDATAW : 32'h0; // @[Memory.scala 110:34 114:29 75:21]
  wire [29:0] _GEN_15 = 2'h2 == memState ? _GEN_4 : 30'h0; // @[Memory.scala 77:19 78:19]
  wire [31:0] _GEN_16 = 2'h2 == memState ? _GEN_10 : 32'h0; // @[Memory.scala 78:19 75:21]
  wire [29:0] _GEN_21 = 2'h1 == memState ? _GEN_4 : _GEN_15; // @[Memory.scala 78:19]
  wire [31:0] _GEN_22 = 2'h1 == memState ? _GEN_5 : 32'h0; // @[Memory.scala 78:19]
  wire [31:0] _GEN_26 = 2'h1 == memState ? 32'h0 : _GEN_16; // @[Memory.scala 78:19 75:21]
  wire  _GEN_27 = 2'h1 == memState ? 1'h0 : 2'h2 == memState & _T_9; // @[Memory.scala 76:17 78:19]
  wire [29:0] _GEN_30 = 2'h0 == memState ? 30'h0 : _GEN_21; // @[Memory.scala 78:19 83:23]
  SinglePortRAM syncMem ( // @[Memory.scala 61:23]
    .clock(syncMem_clock),
    .io_addr(syncMem_io_addr),
    .io_dataIn(syncMem_io_dataIn),
    .io_we(syncMem_io_we),
    .io_dataOut(syncMem_io_dataOut)
  );
  assign io_TDATAR = 2'h0 == memState ? 32'h0 : _GEN_22; // @[Memory.scala 78:19]
  assign syncMem_clock = clock;
  assign syncMem_io_addr = _GEN_30[9:0];
  assign syncMem_io_dataIn = 2'h0 == memState ? 32'h0 : _GEN_26; // @[Memory.scala 78:19 81:25]
  assign syncMem_io_we = 2'h0 == memState ? 1'h0 : _GEN_27; // @[Memory.scala 78:19 82:21]
  always @(posedge clock) begin
    if (reset) begin // @[Memory.scala 67:25]
      memState <= 2'h0; // @[Memory.scala 67:25]
    end else if (2'h0 == memState) begin // @[Memory.scala 78:19]
      if (io_TVALID) begin // @[Memory.scala 86:33]
        if (io_TUSER == 2'h1) begin // @[Memory.scala 88:47]
          memState <= 2'h1; // @[Memory.scala 89:20]
        end else begin
          memState <= _GEN_0;
        end
      end
    end else if (2'h1 == memState) begin // @[Memory.scala 78:19]
      memState <= _GEN_8;
    end else if (2'h2 == memState) begin // @[Memory.scala 78:19]
      memState <= _GEN_8;
    end
    if (reset) begin // @[Memory.scala 72:26]
      rwmemAddr <= 30'h0; // @[Memory.scala 72:26]
    end else if (2'h0 == memState) begin // @[Memory.scala 78:19]
      if (io_TVALID) begin // @[Memory.scala 86:33]
        rwmemAddr <= io_TDATAW[31:2]; // @[Memory.scala 87:19]
      end
    end else if (2'h1 == memState) begin // @[Memory.scala 78:19]
      rwmemAddr <= _GEN_6;
    end else if (2'h2 == memState) begin // @[Memory.scala 78:19]
      rwmemAddr <= _GEN_6;
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  memState = _RAND_0[1:0];
  _RAND_1 = {1{`RANDOM}};
  rwmemAddr = _RAND_1[29:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module RPSWithOutCore(
  input         clock,
  input         reset,
  input  [31:0] io_instr_addr,
  output [31:0] io_instr_data,
  output        io_IMiss,
  output        io_DMiss,
  input  [3:0]  io_data_be,
  input         io_data_we,
  input  [31:0] io_data_addr,
  input  [31:0] io_data_wdata,
  output [31:0] io_data_rdata,
  input         io_IRreq,
  input         io_DRreq
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_REG_INIT
  wire  Icache_clock; // @[RPSWithOutCore.scala 47:22]
  wire  Icache_reset; // @[RPSWithOutCore.scala 47:22]
  wire [31:0] Icache_io_addr; // @[RPSWithOutCore.scala 47:22]
  wire  Icache_io_r_req; // @[RPSWithOutCore.scala 47:22]
  wire  Icache_io_w_req; // @[RPSWithOutCore.scala 47:22]
  wire [31:0] Icache_io_writedata; // @[RPSWithOutCore.scala 47:22]
  wire [3:0] Icache_io_writeMask; // @[RPSWithOutCore.scala 47:22]
  wire [31:0] Icache_io_outdata; // @[RPSWithOutCore.scala 47:22]
  wire  Icache_io_miss; // @[RPSWithOutCore.scala 47:22]
  wire [10:0] Icache_io_mem_addr; // @[RPSWithOutCore.scala 47:22]
  wire  Icache_io_mem_rd_req; // @[RPSWithOutCore.scala 47:22]
  wire  Icache_io_mem_wr_req; // @[RPSWithOutCore.scala 47:22]
  wire [31:0] Icache_io_mem_wr_line_0; // @[RPSWithOutCore.scala 47:22]
  wire [31:0] Icache_io_mem_wr_line_1; // @[RPSWithOutCore.scala 47:22]
  wire [31:0] Icache_io_mem_rd_line_0; // @[RPSWithOutCore.scala 47:22]
  wire [31:0] Icache_io_mem_rd_line_1; // @[RPSWithOutCore.scala 47:22]
  wire  Icache_io_cacheAXI_gnt; // @[RPSWithOutCore.scala 47:22]
  wire  Dcache_clock; // @[RPSWithOutCore.scala 48:22]
  wire  Dcache_reset; // @[RPSWithOutCore.scala 48:22]
  wire [31:0] Dcache_io_addr; // @[RPSWithOutCore.scala 48:22]
  wire  Dcache_io_r_req; // @[RPSWithOutCore.scala 48:22]
  wire  Dcache_io_w_req; // @[RPSWithOutCore.scala 48:22]
  wire [31:0] Dcache_io_writedata; // @[RPSWithOutCore.scala 48:22]
  wire [3:0] Dcache_io_writeMask; // @[RPSWithOutCore.scala 48:22]
  wire [31:0] Dcache_io_outdata; // @[RPSWithOutCore.scala 48:22]
  wire  Dcache_io_miss; // @[RPSWithOutCore.scala 48:22]
  wire [10:0] Dcache_io_mem_addr; // @[RPSWithOutCore.scala 48:22]
  wire  Dcache_io_mem_rd_req; // @[RPSWithOutCore.scala 48:22]
  wire  Dcache_io_mem_wr_req; // @[RPSWithOutCore.scala 48:22]
  wire [31:0] Dcache_io_mem_wr_line_0; // @[RPSWithOutCore.scala 48:22]
  wire [31:0] Dcache_io_mem_wr_line_1; // @[RPSWithOutCore.scala 48:22]
  wire [31:0] Dcache_io_mem_rd_line_0; // @[RPSWithOutCore.scala 48:22]
  wire [31:0] Dcache_io_mem_rd_line_1; // @[RPSWithOutCore.scala 48:22]
  wire  Dcache_io_cacheAXI_gnt; // @[RPSWithOutCore.scala 48:22]
  wire  IcacheAXI_clock; // @[RPSWithOutCore.scala 49:25]
  wire  IcacheAXI_reset; // @[RPSWithOutCore.scala 49:25]
  wire [10:0] IcacheAXI_io_mem_addr; // @[RPSWithOutCore.scala 49:25]
  wire  IcacheAXI_io_mem_rd_req; // @[RPSWithOutCore.scala 49:25]
  wire  IcacheAXI_io_mem_wr_req; // @[RPSWithOutCore.scala 49:25]
  wire [31:0] IcacheAXI_io_mem_wr_line_0; // @[RPSWithOutCore.scala 49:25]
  wire [31:0] IcacheAXI_io_mem_wr_line_1; // @[RPSWithOutCore.scala 49:25]
  wire [31:0] IcacheAXI_io_mem_rd_line_0; // @[RPSWithOutCore.scala 49:25]
  wire [31:0] IcacheAXI_io_mem_rd_line_1; // @[RPSWithOutCore.scala 49:25]
  wire  IcacheAXI_io_cacheAXI_gnt; // @[RPSWithOutCore.scala 49:25]
  wire  IcacheAXI_io_TVALID; // @[RPSWithOutCore.scala 49:25]
  wire  IcacheAXI_io_TLAST; // @[RPSWithOutCore.scala 49:25]
  wire  IcacheAXI_io_TREADY; // @[RPSWithOutCore.scala 49:25]
  wire [31:0] IcacheAXI_io_TDATAR; // @[RPSWithOutCore.scala 49:25]
  wire [31:0] IcacheAXI_io_TDATAW; // @[RPSWithOutCore.scala 49:25]
  wire [1:0] IcacheAXI_io_TUSER; // @[RPSWithOutCore.scala 49:25]
  wire  DcacheAXI_clock; // @[RPSWithOutCore.scala 50:25]
  wire  DcacheAXI_reset; // @[RPSWithOutCore.scala 50:25]
  wire [10:0] DcacheAXI_io_mem_addr; // @[RPSWithOutCore.scala 50:25]
  wire  DcacheAXI_io_mem_rd_req; // @[RPSWithOutCore.scala 50:25]
  wire  DcacheAXI_io_mem_wr_req; // @[RPSWithOutCore.scala 50:25]
  wire [31:0] DcacheAXI_io_mem_wr_line_0; // @[RPSWithOutCore.scala 50:25]
  wire [31:0] DcacheAXI_io_mem_wr_line_1; // @[RPSWithOutCore.scala 50:25]
  wire [31:0] DcacheAXI_io_mem_rd_line_0; // @[RPSWithOutCore.scala 50:25]
  wire [31:0] DcacheAXI_io_mem_rd_line_1; // @[RPSWithOutCore.scala 50:25]
  wire  DcacheAXI_io_cacheAXI_gnt; // @[RPSWithOutCore.scala 50:25]
  wire  DcacheAXI_io_TVALID; // @[RPSWithOutCore.scala 50:25]
  wire  DcacheAXI_io_TLAST; // @[RPSWithOutCore.scala 50:25]
  wire  DcacheAXI_io_TREADY; // @[RPSWithOutCore.scala 50:25]
  wire [31:0] DcacheAXI_io_TDATAR; // @[RPSWithOutCore.scala 50:25]
  wire [31:0] DcacheAXI_io_TDATAW; // @[RPSWithOutCore.scala 50:25]
  wire [1:0] DcacheAXI_io_TUSER; // @[RPSWithOutCore.scala 50:25]
  wire  mem_clock; // @[RPSWithOutCore.scala 51:19]
  wire  mem_reset; // @[RPSWithOutCore.scala 51:19]
  wire  mem_io_TVALID; // @[RPSWithOutCore.scala 51:19]
  wire [31:0] mem_io_TDATAW; // @[RPSWithOutCore.scala 51:19]
  wire [31:0] mem_io_TDATAR; // @[RPSWithOutCore.scala 51:19]
  wire  mem_io_TLAST; // @[RPSWithOutCore.scala 51:19]
  wire [1:0] mem_io_TUSER; // @[RPSWithOutCore.scala 51:19]
  reg  cid; // @[RPSWithOutCore.scala 95:20]
  wire  _T = ~cid; // @[RPSWithOutCore.scala 106:12]
  wire [31:0] _GEN_0 = cid ? DcacheAXI_io_TDATAW : 32'h0; // @[RPSWithOutCore.scala 115:45 116:19 125:19]
  wire [1:0] _GEN_1 = cid ? DcacheAXI_io_TUSER : 2'h0; // @[RPSWithOutCore.scala 115:45 117:18 126:18]
  wire  _GEN_2 = cid & DcacheAXI_io_TVALID; // @[RPSWithOutCore.scala 115:45 118:19 127:19]
  wire  _GEN_3 = cid & DcacheAXI_io_TLAST; // @[RPSWithOutCore.scala 115:45 119:18 128:18]
  wire [31:0] _GEN_5 = cid ? mem_io_TDATAR : 32'h0; // @[RPSWithOutCore.scala 115:45 121:25 130:25]
  wire  _GEN_15 = IcacheAXI_io_TUSER == 2'h0 | cid; // @[RPSWithOutCore.scala 138:50 139:11 95:20]
  wire  _GEN_16 = DcacheAXI_io_TUSER == 2'h0 ? 1'h0 : cid; // @[RPSWithOutCore.scala 142:50 143:11 95:20]
  wire  _GEN_17 = cid ? _GEN_16 : cid; // @[RPSWithOutCore.scala 141:45 95:20]
  wire  _GEN_18 = _T ? _GEN_15 : _GEN_17; // @[RPSWithOutCore.scala 137:39]
  Cache Icache ( // @[RPSWithOutCore.scala 47:22]
    .clock(Icache_clock),
    .reset(Icache_reset),
    .io_addr(Icache_io_addr),
    .io_r_req(Icache_io_r_req),
    .io_w_req(Icache_io_w_req),
    .io_writedata(Icache_io_writedata),
    .io_writeMask(Icache_io_writeMask),
    .io_outdata(Icache_io_outdata),
    .io_miss(Icache_io_miss),
    .io_mem_addr(Icache_io_mem_addr),
    .io_mem_rd_req(Icache_io_mem_rd_req),
    .io_mem_wr_req(Icache_io_mem_wr_req),
    .io_mem_wr_line_0(Icache_io_mem_wr_line_0),
    .io_mem_wr_line_1(Icache_io_mem_wr_line_1),
    .io_mem_rd_line_0(Icache_io_mem_rd_line_0),
    .io_mem_rd_line_1(Icache_io_mem_rd_line_1),
    .io_cacheAXI_gnt(Icache_io_cacheAXI_gnt)
  );
  Cache Dcache ( // @[RPSWithOutCore.scala 48:22]
    .clock(Dcache_clock),
    .reset(Dcache_reset),
    .io_addr(Dcache_io_addr),
    .io_r_req(Dcache_io_r_req),
    .io_w_req(Dcache_io_w_req),
    .io_writedata(Dcache_io_writedata),
    .io_writeMask(Dcache_io_writeMask),
    .io_outdata(Dcache_io_outdata),
    .io_miss(Dcache_io_miss),
    .io_mem_addr(Dcache_io_mem_addr),
    .io_mem_rd_req(Dcache_io_mem_rd_req),
    .io_mem_wr_req(Dcache_io_mem_wr_req),
    .io_mem_wr_line_0(Dcache_io_mem_wr_line_0),
    .io_mem_wr_line_1(Dcache_io_mem_wr_line_1),
    .io_mem_rd_line_0(Dcache_io_mem_rd_line_0),
    .io_mem_rd_line_1(Dcache_io_mem_rd_line_1),
    .io_cacheAXI_gnt(Dcache_io_cacheAXI_gnt)
  );
  CacheAXI IcacheAXI ( // @[RPSWithOutCore.scala 49:25]
    .clock(IcacheAXI_clock),
    .reset(IcacheAXI_reset),
    .io_mem_addr(IcacheAXI_io_mem_addr),
    .io_mem_rd_req(IcacheAXI_io_mem_rd_req),
    .io_mem_wr_req(IcacheAXI_io_mem_wr_req),
    .io_mem_wr_line_0(IcacheAXI_io_mem_wr_line_0),
    .io_mem_wr_line_1(IcacheAXI_io_mem_wr_line_1),
    .io_mem_rd_line_0(IcacheAXI_io_mem_rd_line_0),
    .io_mem_rd_line_1(IcacheAXI_io_mem_rd_line_1),
    .io_cacheAXI_gnt(IcacheAXI_io_cacheAXI_gnt),
    .io_TVALID(IcacheAXI_io_TVALID),
    .io_TLAST(IcacheAXI_io_TLAST),
    .io_TREADY(IcacheAXI_io_TREADY),
    .io_TDATAR(IcacheAXI_io_TDATAR),
    .io_TDATAW(IcacheAXI_io_TDATAW),
    .io_TUSER(IcacheAXI_io_TUSER)
  );
  CacheAXI DcacheAXI ( // @[RPSWithOutCore.scala 50:25]
    .clock(DcacheAXI_clock),
    .reset(DcacheAXI_reset),
    .io_mem_addr(DcacheAXI_io_mem_addr),
    .io_mem_rd_req(DcacheAXI_io_mem_rd_req),
    .io_mem_wr_req(DcacheAXI_io_mem_wr_req),
    .io_mem_wr_line_0(DcacheAXI_io_mem_wr_line_0),
    .io_mem_wr_line_1(DcacheAXI_io_mem_wr_line_1),
    .io_mem_rd_line_0(DcacheAXI_io_mem_rd_line_0),
    .io_mem_rd_line_1(DcacheAXI_io_mem_rd_line_1),
    .io_cacheAXI_gnt(DcacheAXI_io_cacheAXI_gnt),
    .io_TVALID(DcacheAXI_io_TVALID),
    .io_TLAST(DcacheAXI_io_TLAST),
    .io_TREADY(DcacheAXI_io_TREADY),
    .io_TDATAR(DcacheAXI_io_TDATAR),
    .io_TDATAW(DcacheAXI_io_TDATAW),
    .io_TUSER(DcacheAXI_io_TUSER)
  );
  Memory mem ( // @[RPSWithOutCore.scala 51:19]
    .clock(mem_clock),
    .reset(mem_reset),
    .io_TVALID(mem_io_TVALID),
    .io_TDATAW(mem_io_TDATAW),
    .io_TDATAR(mem_io_TDATAR),
    .io_TLAST(mem_io_TLAST),
    .io_TUSER(mem_io_TUSER)
  );
  assign io_instr_data = Icache_io_outdata; // @[RPSWithOutCore.scala 63:17]
  assign io_IMiss = Icache_io_miss; // @[RPSWithOutCore.scala 61:12]
  assign io_DMiss = Dcache_io_miss; // @[RPSWithOutCore.scala 62:12]
  assign io_data_rdata = Dcache_io_outdata; // @[RPSWithOutCore.scala 64:17]
  assign Icache_clock = clock;
  assign Icache_reset = reset;
  assign Icache_io_addr = io_instr_addr; // @[RPSWithOutCore.scala 67:18]
  assign Icache_io_r_req = io_IRreq; // @[RPSWithOutCore.scala 76:19]
  assign Icache_io_w_req = 1'h0; // @[RPSWithOutCore.scala 69:19]
  assign Icache_io_writedata = 32'h0; // @[RPSWithOutCore.scala 70:23]
  assign Icache_io_writeMask = 4'h0; // @[RPSWithOutCore.scala 68:23]
  assign Icache_io_mem_rd_line_0 = IcacheAXI_io_mem_rd_line_0; // @[RPSWithOutCore.scala 80:25]
  assign Icache_io_mem_rd_line_1 = IcacheAXI_io_mem_rd_line_1; // @[RPSWithOutCore.scala 80:25]
  assign Icache_io_cacheAXI_gnt = IcacheAXI_io_cacheAXI_gnt; // @[RPSWithOutCore.scala 81:26]
  assign Dcache_clock = clock;
  assign Dcache_reset = reset;
  assign Dcache_io_addr = io_data_addr; // @[RPSWithOutCore.scala 71:18]
  assign Dcache_io_r_req = io_DRreq; // @[RPSWithOutCore.scala 77:19]
  assign Dcache_io_w_req = io_data_we; // @[RPSWithOutCore.scala 73:19]
  assign Dcache_io_writedata = io_data_wdata; // @[RPSWithOutCore.scala 74:23]
  assign Dcache_io_writeMask = io_data_be; // @[RPSWithOutCore.scala 72:23]
  assign Dcache_io_mem_rd_line_0 = DcacheAXI_io_mem_rd_line_0; // @[RPSWithOutCore.scala 82:25]
  assign Dcache_io_mem_rd_line_1 = DcacheAXI_io_mem_rd_line_1; // @[RPSWithOutCore.scala 82:25]
  assign Dcache_io_cacheAXI_gnt = DcacheAXI_io_cacheAXI_gnt; // @[RPSWithOutCore.scala 83:26]
  assign IcacheAXI_clock = clock;
  assign IcacheAXI_reset = reset;
  assign IcacheAXI_io_mem_addr = Icache_io_mem_addr; // @[RPSWithOutCore.scala 86:25]
  assign IcacheAXI_io_mem_rd_req = Icache_io_mem_rd_req; // @[RPSWithOutCore.scala 87:27]
  assign IcacheAXI_io_mem_wr_req = Icache_io_mem_wr_req; // @[RPSWithOutCore.scala 88:27]
  assign IcacheAXI_io_mem_wr_line_0 = Icache_io_mem_wr_line_0; // @[RPSWithOutCore.scala 89:28]
  assign IcacheAXI_io_mem_wr_line_1 = Icache_io_mem_wr_line_1; // @[RPSWithOutCore.scala 89:28]
  assign IcacheAXI_io_TREADY = ~cid; // @[RPSWithOutCore.scala 106:12]
  assign IcacheAXI_io_TDATAR = ~cid ? mem_io_TDATAR : 32'h0; // @[RPSWithOutCore.scala 106:39 112:25]
  assign DcacheAXI_clock = clock;
  assign DcacheAXI_reset = reset;
  assign DcacheAXI_io_mem_addr = Dcache_io_mem_addr; // @[RPSWithOutCore.scala 90:25]
  assign DcacheAXI_io_mem_rd_req = Dcache_io_mem_rd_req; // @[RPSWithOutCore.scala 91:27]
  assign DcacheAXI_io_mem_wr_req = Dcache_io_mem_wr_req; // @[RPSWithOutCore.scala 92:27]
  assign DcacheAXI_io_mem_wr_line_0 = Dcache_io_mem_wr_line_0; // @[RPSWithOutCore.scala 93:28]
  assign DcacheAXI_io_mem_wr_line_1 = Dcache_io_mem_wr_line_1; // @[RPSWithOutCore.scala 93:28]
  assign DcacheAXI_io_TREADY = ~cid ? 1'h0 : cid; // @[RPSWithOutCore.scala 106:39 113:25]
  assign DcacheAXI_io_TDATAR = ~cid ? 32'h0 : _GEN_5; // @[RPSWithOutCore.scala 106:39 114:25]
  assign mem_clock = clock;
  assign mem_reset = reset;
  assign mem_io_TVALID = ~cid ? IcacheAXI_io_TVALID : _GEN_2; // @[RPSWithOutCore.scala 106:39 109:19]
  assign mem_io_TDATAW = ~cid ? IcacheAXI_io_TDATAW : _GEN_0; // @[RPSWithOutCore.scala 106:39 107:19]
  assign mem_io_TLAST = ~cid ? IcacheAXI_io_TLAST : _GEN_3; // @[RPSWithOutCore.scala 106:39 110:18]
  assign mem_io_TUSER = ~cid ? IcacheAXI_io_TUSER : _GEN_1; // @[RPSWithOutCore.scala 106:39 108:18]
  always @(posedge clock) begin
    cid <= reset | _GEN_18; // @[RPSWithOutCore.scala 95:{20,20}]
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  cid = _RAND_0[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
