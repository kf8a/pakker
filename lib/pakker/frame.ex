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
    Enum.scan(bits, fn(x,acc) -> unquote_special_byte_sequence(x,acc) end )
    |> Enum.filter(fn(x) -> x != :quote end)
    |> Enum.into(<<>>)
  end

  defp unquote_special_byte_sequence(byte, []) do
    byte
  end

  defp unquote_special_byte_sequence(byte, _) do
    if (byte == << 0xbc >>) do
      :quote
    else
      case byte do 
      <<0xdc>> -> << 0xbc >>
      <<0xdd>> -> << 0xbd >>
      a -> a
      end
    end
  end

  defp remove_set_ser_bytes(bits) do
    case bits do
      << 0xbd, body :: bitstring >> -> remove_set_ser_bytes(body)
      << body :: bitstring >> -> body
    end
  end

end
