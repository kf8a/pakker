# This really is a stream module
# that sits on the byte stream comming in and parses out the
# frames
defmodule Pakker.Frame do
  # convert bits to frames
  def from_bits(bits) do
    bits
    |> remove_set_ser_bytes()
    |> Enum.reverse()
    |> Enum.into(<<>>)
    |> remove_set_ser_bytes()
    |> Enum.reverse()
    |> Enum.into(<<>>)
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
