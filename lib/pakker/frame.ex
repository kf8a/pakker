# This really is a stream module
# that sits on the byte stream comming in and parses out the
# frames
defmodule Pakker.Frame do
  @ moduledoc """
    A module of functions to read bits and return frames
  """

  @doc """
  turns a squence of bits into a frame
  """
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

  @doc """
  turn a message into a sequence of bits to be sent out
  """
  def to_bits(message) do
    [<<0xbd >>, message, <<  0xbd>>]
    |> flatten |> Enum.into(<<>>)
  end

  def quote_message(message) do
    Enum.scan(message, fn(x, acc) -> quote_special_byte_sequence(x, acc) end )
    |> flatten
    |> Enum.into(<<>>)
  end

  defp flatten([]) do [] end
  defp flatten([head | tail]) do flatten(head) ++ flatten(tail) end
  defp flatten(head) do [head] end

  defp quote_special_byte_sequence(byte, _) do
    case byte do
      <<0xbd>> -> [<<0xbc>>, <<0xdd>>]
      <<0xbc>> -> [<<0xbc>>, <<0xdc>>]
      a -> a
    end
  end

  def unquote_message(bits) do
    Enum.scan(bits, fn(x, acc) -> unquote_special_byte_sequence(x, acc) end )
    |> Enum.filter(fn(x) -> x != :quote end)
    |> Enum.into(<<>>)
  end

  defp unquote_special_byte_sequence(byte, []) do
    byte
  end

  defp unquote_special_byte_sequence(byte, _) do
    if byte == << 0xbc >> do
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
