defmodule PakkerTest do
  use ExUnit.Case
  doctest Pakker

  setup do
    bits = << 0x10, 0xab, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0>>
    packet = Pakker.Packet.from_bits(bits)
    {:ok, packet: packet}
  end

  test "it reads the link state", meta do
    assert meta[:packet].link_state ==  0b001
  end

  test "it reads the destination physical address", meta do
    assert meta[:packet].dest_physical_address == 0xab
  end
end
