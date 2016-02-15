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

  def to_bits() do
  end

  def unquote_message(bits) do
    # Enum.flat_map_reduce(bits, [], fn(x, acc) -> unquote_special_byte_sequence(x, acc) end )
  end

  # defp unquote_special_byte_sequence(byte, []) do
  #   byte
  # end

  # defp unquote_special_byte_sequence(byte, acc) do
  #   case [Enum.fetch!(acc, -1), byte] do 
  #   [<< 0xbc>>, <<0xdd>>] -> [acc , << 0xbd >>]
  #   [ <<0xbc>>,  <<0xdc>> ] -> [acc , << 0xbc >>]
  #   [ a, b] -> [acc , b]
  #   end
  # end

  defp remove_set_ser_bytes(bits) do
    case bits do
      << 0xbd, body :: bitstring >> -> remove_set_ser_bytes(body)
      << body :: bitstring >> -> body
    end
  end

  def cons([], count), do: []
  def cons([_ | tail] = list, count), do: [Enum.take(list, count) | cons(tail, count)]



end
