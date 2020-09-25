package afifo

import chisel3._
import chisel3.experimental.chiselName
import chisel3.util._

class AsyncFIFOWriteIO[T <: Data](gen: T,
                                  hasWriteAck: Boolean,
                                  hasWriteOverflow: Boolean) extends Bundle {
  val data = Input(gen)
  val push = Input(Bool())
  val full = Output(Bool())
  val ack = if (hasWriteAck) Some(Output(Bool())) else None
  val overflow = if (hasWriteOverflow) Some(Output(Bool())) else None
}

class AsyncFIFOReadIO[T <: Data](gen: T,
                                 hasReadValid: Boolean,
                                 hasReadUnderflow: Boolean) extends Bundle {
  val data = Output(gen)
  val pop = Input(Bool())
  val empty = Output(Bool())
  val valid = if (hasReadValid) Some(Output(Bool())) else None
  val underflow = if (hasReadUnderflow) Some(Output(Bool())) else None
}

@chiselName
class AsyncFIFOMemory(dataWidth: Int, addrWidth: Int, depth: Int) extends RawModule {
  val wr = IO(new Bundle {
    val clock = Input(Clock())
    val en = Input(Bool())
    val addr = Input(UInt(addrWidth.W))
    val data = Input(UInt(dataWidth.W))
  })
  val rd = IO(new Bundle {
    val clock = Input(Clock())
    val en = Input(Bool())
    val addr = Input(UInt(addrWidth.W))
    val data = Output(UInt(dataWidth.W))
  })
  val mem = SyncReadMem(depth, UInt(dataWidth.W))
  withClock(wr.clock) {
    when(wr.en) {
      mem.write(wr.addr, wr.data)
    }
  }
  withClock(rd.clock) {
    rd.data := mem(rd.addr)
    //rd.data := RegEnable(mem(rd.addr), enable = rd.en)
  }
}

@chiselName
class AsyncFIFO[T <: Data](gen: T, suggestDepth: Int, syncClockCycle: Int = 3,
                           hasReadValid: Boolean = false,
                           hasReadUnderflow: Boolean = false,
                           hasWriteAck: Boolean = false,
                           hasWriteOverflow: Boolean = false
                          ) extends RawModule {
  val addrWidth = log2Ceil(suggestDepth)
  val depth = 1 << addrWidth
  if (suggestDepth != depth) {
    println(s"The depth should be a 2^m, got $depth, but saturated to $suggestDepth")
  }
  val wr_clock = IO(Input(Clock()))
  val wr_reset = IO(Input(AsyncReset()))
  val wr = IO(new AsyncFIFOWriteIO(gen, hasWriteAck, hasWriteOverflow))
  val rd_clock = IO(Input(Clock()))
  val rd_reset = IO(Input(AsyncReset()))
  val rd = IO(new AsyncFIFOReadIO(gen, hasReadValid, hasReadUnderflow))

  // The pointers are Gray-encoded, and can be transmitted across clock domains.
  val rdPtr = Wire(UInt((addrWidth + 1).W))
  val wrPtr = Wire(UInt((addrWidth + 1).W))

  // For ASIC, `mem` can replaced with SRAM cells.
  val dataWidth = gen.cloneType.getWidth
  val mem = Module(new AsyncFIFOMemory(dataWidth, addrWidth, depth))
  mem.wr.clock := wr_clock
  mem.rd.clock := rd_clock
  mem.wr.data := wr.data.asUInt()
  rd.data := mem.rd.data.asTypeOf(gen.cloneType)

  def bin2gray(x: UInt): UInt = (x >> 1).asUInt() ^ x

  withClockAndReset(wr_clock, wr_reset) { // write clock domain
    val rdPtrSync = ShiftRegister(rdPtr, syncClockCycle, resetData = 0.U, en = true.B)

    val wrNotFull = !wr.full
    val wrEn = wr.push & wrNotFull
    val wrAddrBinNext = Wire(UInt((addrWidth + 1).W))
    val wrAddrBin = RegNext(wrAddrBinNext, init = 0.U)
    wrAddrBinNext := wrAddrBin + wrEn

    val wrAddrGrayNext = Wire(UInt((addrWidth + 1).W))
    wrAddrGrayNext := bin2gray(wrAddrBinNext)
    val wrAddrGray = RegNext(wrAddrGrayNext, init = 0.U)

    val wrFull = RegNext(
      wrAddrGrayNext === (~rdPtrSync(addrWidth, addrWidth - 1) ## rdPtrSync(addrWidth - 2, 0)),
      init = false.B
    )

    wr.full := wrFull
    wrPtr := wrAddrGray

    mem.wr.en := wrEn
    mem.wr.addr := wrAddrBin(addrWidth - 1, 0)

    wr.ack match {
      case Some(b: Bool) =>
        val wrAck = RegNext(wrEn, init = false.B)
        b := wrAck
      case _ => require(!hasWriteAck)
    }
    wr.overflow match {
      case Some(b: Bool) =>
        val wrOverflow = RegNext(wr.push & wr.full, init = false.B)
        b := wrOverflow
      case _ => require(!hasWriteOverflow)
    }
  }

  withClockAndReset(rd_clock, rd_reset) { // read clock domain
    val wrPtrSync = ShiftRegister(wrPtr, syncClockCycle, resetData = 0.U, en = true.B)

    val rdNotEmpty = !rd.empty
    val rdEn = rd.pop & rdNotEmpty
    val rdAddrBinNext = Wire(UInt((addrWidth + 1).W))
    val rdAddrBin = RegNext(rdAddrBinNext, init = 0.U)
    rdAddrBinNext := rdAddrBin + rdEn

    val rdAddrGrayNext = Wire(UInt((addrWidth + 1).W))
    rdAddrGrayNext := bin2gray(rdAddrBinNext)
    val rdAddrGray = RegNext(rdAddrGrayNext, init = 0.U)

    val rdEmpty = RegNext(rdAddrGrayNext === wrPtrSync, init = true.B)

    rd.empty := rdEmpty
    rdPtr := rdAddrGray

    mem.rd.en := rdEn
    mem.rd.addr := rdAddrBin(addrWidth - 1, 0)

    rd.valid match {
      case Some(b: Bool) =>
        val rdValid = RegNext(rdEn, init = false.B)
        b := rdValid
      case _ => require(!hasReadValid)
    }
    rd.underflow match {
      case Some(b: Bool) =>
        val rdUnderflow = RegNext(rd.pop & rd.empty, init = false.B)
        b := rdUnderflow
      case _ => require(!hasReadUnderflow)
    }
  }
}


object AsyncFIFOMain extends App {
  Driver.execute(args, () => new AsyncFIFO(
    SInt(3.W),
    suggestDepth = 12,
    syncClockCycle = 3,
    hasReadValid = true,
    hasReadUnderflow = true,
    hasWriteAck = true,
    hasWriteOverflow = true
  ))
}
