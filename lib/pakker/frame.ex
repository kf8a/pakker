# This really is a stream module
# that sits on the byte stream comming in and parses out the
# frames
defmodule Pakker.Frame do
  # convert bits to frames
  def from_bits(bits) do
    front = remove_set_ser_bytes(bits)
    back = remove_set_ser_bytes(String.reverse(front))
    String.reverse(back)
    #unquote
  end

  def remove_set_ser_bytes(bits) do
    case bits do
      << 0xbd, body :: bitstring >> -> remove_set_ser_bytes(body)
      << body :: bitstring >> -> body
    end
  end

  def to_bits() do
  end

end
