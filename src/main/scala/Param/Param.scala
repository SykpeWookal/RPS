package Param

class Param(val XLEN: Int,
            val ThreadNumber: Int,
            val Embedded: Boolean,
            val Atomic: Boolean,
            val Multiplication: Boolean,
            val Compressed: Boolean,
            val SingleFloatingPoint: Boolean,
            val DoubleFloatingPoint: Boolean){

  require(XLEN == 32 || XLEN == 64, "XLEN can only be 32 or 64")
  private val rveRegisterCount = 16
  private val rviRegisterCount = 32
  private val insnW = 32
  private val csrCnt = 4096
  private val exceptionW = XLEN
  private val tvalW = XLEN

  def registerCount: Int = if(Embedded) rveRegisterCount else rviRegisterCount
  def instructionWidth: Int = insnW
  def csrCount: Int = csrCnt
  def exceptionWidth: Int = XLEN
  def tvalWidth: Int = XLEN

  // instruction fields

  def opcodeRange: (Int, Int) = Tuple2(6, 0)
  def rdRange: (Int, Int) = Tuple2(11, 7)
  def funct3Range: (Int, Int) = Tuple2(14, 12)
  def rs1Range: (Int, Int) = Tuple2(19, 15)
  def rs2Range: (Int, Int) = Tuple2(24, 20)
  def funct5Range: (Int, Int) = Tuple2(31, 27)
  def funct7Range: (Int, Int) = Tuple2(31, 25)

  // I-type
  def imm12Ranges: List[(Int, Int)] = List((31, 20))
  // S-type
  def simm12Ranges: List[(Int, Int)] = List((31, 25), (11, 8), (7, 7))
  // B-type
  def bimm12Ranges: List[(Int, Int)] = List((31, 31), (7, 7), (30, 25), (11, 8))
  // U-type
  def imm20Ranges: List[(Int, Int)] = List((31, 31), (30, 20), (19, 12))
  // J-type
  def jimm20Ranges: List[(Int, Int)] = List((31, 31), (19, 12), (20, 20), (30, 25), (24, 21))

  //Cache Param
  def LINE_ADDR_LEN:Int = 3  //line内地址长度，决定了每个line具有2^3个word
  def SET_ADDR_LEN:Int = 3   // 组地址长度，决定了一共有2^3=8组
  def TAG_ADDR_LEN:Int = 6   // tag长度
  def WAY_CNT:Int = 3        // 组相连度，决定了每组中有多少路line.  直接映射型cache该参数没用到
  ////////////////////////////
  def MEM_ADDR_LEN    = TAG_ADDR_LEN + SET_ADDR_LEN ; // 计算主存地址长度 MEM_ADDR_LEN，主存大小=2^MEM_ADDR_LEN个line
  def UNUSED_ADDR_LEN = 32 - TAG_ADDR_LEN - SET_ADDR_LEN - LINE_ADDR_LEN - 2 ; // 计算未使用的地址的长度
  def LINE_SIZE       = 1 << LINE_ADDR_LEN  ;         // 计算 line 中 word 的数量，即 2^LINE_ADDR_LEN 个word 每 line
  def SET_SIZE        = 1 << SET_ADDR_LEN   ;         // 计算一共有多少组，即 2^SET_ADDR_LEN 个组
  def WAY_SIZE        = 1 << WAY_CNT   ;



    //////////替换策略//////////
  def replacement = 0  //////0-FIFO,  1-LRU

}
