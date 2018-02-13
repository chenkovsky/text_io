require "./spec_helper"

class SimpleSliceIO < IO
  def initialize(@slice : Bytes)
  end

  def read(slice : Bytes)
    slice.size.times { |i| slice[i] = @slice[i] }
    slice.size
  end

  def write(slice : Bytes)
    slice.size.times { |i| @slice[i] = slice[i] }
    @slice += slice.size
    nil
  end
end

describe TextIO do
  # TODO: Write tests

  it "works" do
    slice = Slice(UInt8).new(4) { |i| ('a'.ord + i).to_u8 }
    STDERR.puts slice
    simple_io = SimpleSliceIO.new slice
    text_io = TextIO.new simple_io
    text_io.read_byte.should eq(10 * 16 + 11)
  end
end
