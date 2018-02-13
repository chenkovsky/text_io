require "./text_io/*"

class TextIO < IO
  @real_io : IO
  BYTES_MAPPING         = Array(UInt8).new(256, 0_u8)
  BYTES_REVERSE_MAPPING = Array(UInt8).new(16, 0_u8)

  ('A'..'F').each do |x|
    BYTES_MAPPING[x.ord] = (x.ord - 'A'.ord).to_u8
    BYTES_REVERSE_MAPPING[x.ord - 'A'.ord + 10] = x.ord.to_u8
  end
  ('a'..'f').each do |x|
    BYTES_MAPPING[x.ord] = (x.ord - 'a'.ord + 10).to_u8
  end

  ('0'..'9').each_with_index do |x, i|
    BYTES_MAPPING[x.ord] = (x.ord - '0'.ord).to_u8
    BYTES_REVERSE_MAPPING[i] = x.ord.to_u8
  end

  def initialize(@real_io)
  end

  def read(slice : Bytes)
    bytes_slice = Bytes.new(slice.size << 1, 0_u8)
    num = @real_io.read bytes_slice
    raise "num should %2 == 0" if num % 2 != 0
    num = num >> 1
    num.times { |i| slice[i] = BYTES_MAPPING[bytes_slice[i << 1]] * 16 + BYTES_MAPPING[bytes_slice[(i << 1) + 1]] }
    num
  end

  def write(slice : Bytes)
    # slice.size.times { |i| @slice[i] = slice[i] }
    # @slice += slice.size
    bytes_slice = Bytes.new(slice.size << 1, 0_u8)
    slice.each_with_index do |byte, i|
      bytes_slice[i << 1] = BYTES_REVERSE_MAPPING[byte >> 4]
      bytes_slice[(i << 1) + 1] = BYTES_REVERSE_MAPPING[byte & 15]
    end
    @real_io.write slice
    nil
  end
end
