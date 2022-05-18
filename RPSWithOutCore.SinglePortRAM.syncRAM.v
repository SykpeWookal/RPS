module BindsTo_0_SinglePortRAM(
  input         clock,
  input  [9:0]  io_addr,
  input  [31:0] io_dataIn,
  input         io_we,
  output [31:0] io_dataOut
);

initial begin
  $readmemh("src/test/memory.txt", SinglePortRAM.syncRAM);
end
                      endmodule

bind SinglePortRAM BindsTo_0_SinglePortRAM BindsTo_0_SinglePortRAM_Inst(.*);