module AsyncFIFOMemory(
  input        wr_clock,
  input        wr_en,
  input  [3:0] wr_addr,
  input  [2:0] wr_data,
  input        rd_clock,
  input  [3:0] rd_addr,
  output [2:0] rd_data
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_1;
`endif // RANDOMIZE_REG_INIT
  reg [2:0] mem [0:15]; // @[AsyncFIFO.scala 41:24]
  wire [2:0] mem__T_1_data; // @[AsyncFIFO.scala 41:24]
  wire [3:0] mem__T_1_addr; // @[AsyncFIFO.scala 41:24]
  wire [2:0] mem__T_data; // @[AsyncFIFO.scala 41:24]
  wire [3:0] mem__T_addr; // @[AsyncFIFO.scala 41:24]
  wire  mem__T_mask; // @[AsyncFIFO.scala 41:24]
  wire  mem__T_en; // @[AsyncFIFO.scala 41:24]
  reg [3:0] mem__T_1_addr_pipe_0;
  assign mem__T_1_addr = mem__T_1_addr_pipe_0;
  assign mem__T_1_data = mem[mem__T_1_addr]; // @[AsyncFIFO.scala 41:24]
  assign mem__T_data = wr_data;
  assign mem__T_addr = wr_addr;
  assign mem__T_mask = 1'h1;
  assign mem__T_en = wr_en;
  assign rd_data = mem__T_1_data; // @[AsyncFIFO.scala 48:13]
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
  for (initvar = 0; initvar < 16; initvar = initvar+1)
    mem[initvar] = _RAND_0[2:0];
`endif // RANDOMIZE_MEM_INIT
`ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  mem__T_1_addr_pipe_0 = _RAND_1[3:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge wr_clock) begin
    if(mem__T_en & mem__T_mask) begin
      mem[mem__T_addr] <= mem__T_data; // @[AsyncFIFO.scala 41:24]
    end
  end
  always @(posedge rd_clock) begin
    mem__T_1_addr_pipe_0 <= rd_addr;
  end
endmodule
module AsyncFIFO(
  input        wr_clock,
  input        wr_reset,
  input  [2:0] wr_data,
  input        wr_push,
  output       wr_full,
  output       wr_ack,
  output       wr_overflow,
  input        rd_clock,
  input        rd_reset,
  output [2:0] rd_data,
  input        rd_pop,
  output       rd_empty,
  output       rd_valid,
  output       rd_underflow
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
`endif // RANDOMIZE_REG_INIT
  wire  mem_wr_clock; // @[AsyncFIFO.scala 78:19]
  wire  mem_wr_en; // @[AsyncFIFO.scala 78:19]
  wire [3:0] mem_wr_addr; // @[AsyncFIFO.scala 78:19]
  wire [2:0] mem_wr_data; // @[AsyncFIFO.scala 78:19]
  wire  mem_rd_clock; // @[AsyncFIFO.scala 78:19]
  wire [3:0] mem_rd_addr; // @[AsyncFIFO.scala 78:19]
  wire [2:0] mem_rd_data; // @[AsyncFIFO.scala 78:19]
  reg [4:0] _T_3; // @[Reg.scala 27:20]
  reg [4:0] rdAddrGray; // @[AsyncFIFO.scala 135:29]
  reg [4:0] _T_4; // @[Reg.scala 27:20]
  reg [4:0] rdPtrSync; // @[Reg.scala 27:20]
  wire  wrNotFull = ~wr_full; // @[AsyncFIFO.scala 89:21]
  wire  wrEn = wr_push & wrNotFull; // @[AsyncFIFO.scala 90:24]
  reg [4:0] wrAddrBin; // @[AsyncFIFO.scala 92:28]
  wire [4:0] _GEN_6 = {{4'd0}, wrEn}; // @[AsyncFIFO.scala 93:32]
  wire [4:0] wrAddrBinNext = wrAddrBin + _GEN_6; // @[AsyncFIFO.scala 93:32]
  wire [4:0] _GEN_7 = {{1'd0}, wrAddrBinNext[4:1]}; // @[AsyncFIFO.scala 84:51]
  wire [4:0] wrAddrGrayNext = _GEN_7 ^ wrAddrBinNext; // @[AsyncFIFO.scala 84:51]
  reg [4:0] wrAddrGray; // @[AsyncFIFO.scala 97:29]
  wire [1:0] _T_10 = ~rdPtrSync[4:3]; // @[AsyncFIFO.scala 100:27]
  wire [4:0] _T_12 = {_T_10,rdPtrSync[2:0]}; // @[AsyncFIFO.scala 100:64]
  reg  wrFull; // @[AsyncFIFO.scala 99:25]
  reg  wrAck; // @[AsyncFIFO.scala 112:28]
  reg  wrOverflow; // @[AsyncFIFO.scala 118:33]
  reg [4:0] _T_16; // @[Reg.scala 27:20]
  reg [4:0] _T_17; // @[Reg.scala 27:20]
  reg [4:0] wrPtrSync; // @[Reg.scala 27:20]
  wire  rdNotEmpty = ~rd_empty; // @[AsyncFIFO.scala 127:22]
  wire  rdEn = rd_pop & rdNotEmpty; // @[AsyncFIFO.scala 128:23]
  reg [4:0] rdAddrBin; // @[AsyncFIFO.scala 130:28]
  wire [4:0] _GEN_8 = {{4'd0}, rdEn}; // @[AsyncFIFO.scala 131:32]
  wire [4:0] rdAddrBinNext = rdAddrBin + _GEN_8; // @[AsyncFIFO.scala 131:32]
  wire [4:0] _GEN_9 = {{1'd0}, rdAddrBinNext[4:1]}; // @[AsyncFIFO.scala 84:51]
  wire [4:0] rdAddrGrayNext = _GEN_9 ^ rdAddrBinNext; // @[AsyncFIFO.scala 84:51]
  reg  rdEmpty; // @[AsyncFIFO.scala 137:26]
  reg  rdValid; // @[AsyncFIFO.scala 147:30]
  reg  rdUnderflow; // @[AsyncFIFO.scala 153:34]
  AsyncFIFOMemory mem ( // @[AsyncFIFO.scala 78:19]
    .wr_clock(mem_wr_clock),
    .wr_en(mem_wr_en),
    .wr_addr(mem_wr_addr),
    .wr_data(mem_wr_data),
    .rd_clock(mem_rd_clock),
    .rd_addr(mem_rd_addr),
    .rd_data(mem_rd_data)
  );
  assign wr_full = wrFull; // @[AsyncFIFO.scala 104:13]
  assign wr_ack = wrAck; // @[AsyncFIFO.scala 113:11]
  assign wr_overflow = wrOverflow; // @[AsyncFIFO.scala 119:11]
  assign rd_data = mem_rd_data; // @[AsyncFIFO.scala 82:11]
  assign rd_empty = rdEmpty; // @[AsyncFIFO.scala 139:14]
  assign rd_valid = rdValid; // @[AsyncFIFO.scala 148:11]
  assign rd_underflow = rdUnderflow; // @[AsyncFIFO.scala 154:11]
  assign mem_wr_clock = wr_clock; // @[AsyncFIFO.scala 79:16]
  assign mem_wr_en = wr_push & wrNotFull; // @[AsyncFIFO.scala 107:15]
  assign mem_wr_addr = wrAddrBin[3:0]; // @[AsyncFIFO.scala 108:17]
  assign mem_wr_data = wr_data; // @[AsyncFIFO.scala 81:15]
  assign mem_rd_clock = rd_clock; // @[AsyncFIFO.scala 80:16]
  assign mem_rd_addr = rdAddrBin[3:0]; // @[AsyncFIFO.scala 143:17]
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
  _T_3 = _RAND_0[4:0];
  _RAND_1 = {1{`RANDOM}};
  rdAddrGray = _RAND_1[4:0];
  _RAND_2 = {1{`RANDOM}};
  _T_4 = _RAND_2[4:0];
  _RAND_3 = {1{`RANDOM}};
  rdPtrSync = _RAND_3[4:0];
  _RAND_4 = {1{`RANDOM}};
  wrAddrBin = _RAND_4[4:0];
  _RAND_5 = {1{`RANDOM}};
  wrAddrGray = _RAND_5[4:0];
  _RAND_6 = {1{`RANDOM}};
  wrFull = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  wrAck = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  wrOverflow = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  _T_16 = _RAND_9[4:0];
  _RAND_10 = {1{`RANDOM}};
  _T_17 = _RAND_10[4:0];
  _RAND_11 = {1{`RANDOM}};
  wrPtrSync = _RAND_11[4:0];
  _RAND_12 = {1{`RANDOM}};
  rdAddrBin = _RAND_12[4:0];
  _RAND_13 = {1{`RANDOM}};
  rdEmpty = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  rdValid = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  rdUnderflow = _RAND_15[0:0];
`endif // RANDOMIZE_REG_INIT
  if (wr_reset) begin
    _T_3 = 5'h0;
  end
  if (rd_reset) begin
    rdAddrGray = 5'h0;
  end
  if (wr_reset) begin
    _T_4 = 5'h0;
  end
  if (wr_reset) begin
    rdPtrSync = 5'h0;
  end
  if (wr_reset) begin
    wrAddrBin = 5'h0;
  end
  if (wr_reset) begin
    wrAddrGray = 5'h0;
  end
  if (wr_reset) begin
    wrFull = 1'h0;
  end
  if (wr_reset) begin
    wrAck = 1'h0;
  end
  if (wr_reset) begin
    wrOverflow = 1'h0;
  end
  if (rd_reset) begin
    _T_16 = 5'h0;
  end
  if (rd_reset) begin
    _T_17 = 5'h0;
  end
  if (rd_reset) begin
    wrPtrSync = 5'h0;
  end
  if (rd_reset) begin
    rdAddrBin = 5'h0;
  end
  if (rd_reset) begin
    rdEmpty = 1'h1;
  end
  if (rd_reset) begin
    rdValid = 1'h0;
  end
  if (rd_reset) begin
    rdUnderflow = 1'h0;
  end
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge wr_clock or posedge wr_reset) begin
    if (wr_reset) begin
      _T_3 <= 5'h0;
    end else begin
      _T_3 <= rdAddrGray;
    end
  end
  always @(posedge rd_clock or posedge rd_reset) begin
    if (rd_reset) begin
      rdAddrGray <= 5'h0;
    end else begin
      rdAddrGray <= _GEN_9 ^ rdAddrBinNext;
    end
  end
  always @(posedge wr_clock or posedge wr_reset) begin
    if (wr_reset) begin
      _T_4 <= 5'h0;
    end else begin
      _T_4 <= _T_3;
    end
  end
  always @(posedge wr_clock or posedge wr_reset) begin
    if (wr_reset) begin
      rdPtrSync <= 5'h0;
    end else begin
      rdPtrSync <= _T_4;
    end
  end
  always @(posedge wr_clock or posedge wr_reset) begin
    if (wr_reset) begin
      wrAddrBin <= 5'h0;
    end else begin
      wrAddrBin <= wrAddrBin + _GEN_6;
    end
  end
  always @(posedge wr_clock or posedge wr_reset) begin
    if (wr_reset) begin
      wrAddrGray <= 5'h0;
    end else begin
      wrAddrGray <= _GEN_7 ^ wrAddrBinNext;
    end
  end
  always @(posedge wr_clock or posedge wr_reset) begin
    if (wr_reset) begin
      wrFull <= 1'h0;
    end else begin
      wrFull <= wrAddrGrayNext == _T_12;
    end
  end
  always @(posedge wr_clock or posedge wr_reset) begin
    if (wr_reset) begin
      wrAck <= 1'h0;
    end else begin
      wrAck <= wr_push & wrNotFull;
    end
  end
  always @(posedge wr_clock or posedge wr_reset) begin
    if (wr_reset) begin
      wrOverflow <= 1'h0;
    end else begin
      wrOverflow <= wr_push & wr_full;
    end
  end
  always @(posedge rd_clock or posedge rd_reset) begin
    if (rd_reset) begin
      _T_16 <= 5'h0;
    end else begin
      _T_16 <= wrAddrGray;
    end
  end
  always @(posedge rd_clock or posedge rd_reset) begin
    if (rd_reset) begin
      _T_17 <= 5'h0;
    end else begin
      _T_17 <= _T_16;
    end
  end
  always @(posedge rd_clock or posedge rd_reset) begin
    if (rd_reset) begin
      wrPtrSync <= 5'h0;
    end else begin
      wrPtrSync <= _T_17;
    end
  end
  always @(posedge rd_clock or posedge rd_reset) begin
    if (rd_reset) begin
      rdAddrBin <= 5'h0;
    end else begin
      rdAddrBin <= rdAddrBin + _GEN_8;
    end
  end
  always @(posedge rd_clock or posedge rd_reset) begin
    if (rd_reset) begin
      rdEmpty <= 1'h1;
    end else begin
      rdEmpty <= rdAddrGrayNext == wrPtrSync;
    end
  end
  always @(posedge rd_clock or posedge rd_reset) begin
    if (rd_reset) begin
      rdValid <= 1'h0;
    end else begin
      rdValid <= rd_pop & rdNotEmpty;
    end
  end
  always @(posedge rd_clock or posedge rd_reset) begin
    if (rd_reset) begin
      rdUnderflow <= 1'h0;
    end else begin
      rdUnderflow <= rd_pop & rd_empty;
    end
  end
endmodule
