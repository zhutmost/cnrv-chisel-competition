# Chisel3 Asynchronous AsyncFIFO Generator

This project was originally an entry for [CNRV Chisel Competition CH002](https://mp.weixin.qq.com/s/7g_FsgsEPXpC39ZBC59YOQ).
It implements a parameterized AsyncFIFO generator in Chisel3.

此项目是 CNRV Chisel 挑战赛 CH002 的一个参赛作品，实现了一个参数化的异步 FIFO。

## RTL Generation

Run sbt command `runMain afifo.AsyncFIFOMain -td ./builds`, it will generate a full-featured FIFO as an example. The example `.v` RTL files can be found in `./builds`.

You can also change these parameters to customize an FIFO.
```scala
object AsyncFIFOMain extends App {
  Driver.execute(args, () => new AsyncFIFO(
    SInt(3.W),               // data type, T <: Data
    suggestDepth = 12,       // FIFO depth, automatically expand to a 2^m
    syncClockCycle = 3,      // number of stages of the synchronizers
    hasReadValid = true,     // have a rd_valid port
    hasReadUnderflow = true, // have a rd_underflow port
    hasWriteAck = true,      // have a wr_ack port
    hasWriteOverflow = true  // have a wr_overflow port
  ))
}
```

## Simulation

A SystemVerilog testbench is included in [src/test/sverilog](src/test/sverilog). With it, you can easily compare the output signals of the generated FIFO with a Xilinx Vivado built-in FIFO.

A Xilinx Vivado FIFO IP description file `xilinx_bram_fifo.xci` is also included, which can used to generate the FIFO IP in Vivado.

## Technical Features

This project features most of functions of the Xilinx FIFO. You can read the [Xilinx PG057 document](https://www.xilinx.com/support/documentation/ip_documentation/fifo_generator/v13_2/pg057-fifo-generator.pdf) for detailed port definitions.

- The FIFO memory is wrapped up in a `SyncReadMem` module, so that you can easily replace it with a SRAM cell in the ASIC flow.
- The input data will be automatically packed as a `UInt` and then pushed into the FIFO memory. In the read side, the output `UInt` data poped from the FIFO memory are also converted to the original data type automatically. Therefore, for the data type of `Bundle` including several member signals, the FIFO memory module will be generated as a "wide" memory instead of mutilple small memories.
- The `wr_ack`, `wr_overflow`, `rd_valid` and `rd_overflow` signals are asserted one cycle after a valid `wr_push` or `rd_pop`.
- By default, the number of stages of synchronizers is 3, which is the same as the Vivado built-in FIFO. You can change this parameter, but it should be no less than 2.

## License

Thie project is published under [MIT license](./LICENSE).
