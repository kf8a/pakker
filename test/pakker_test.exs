defmodule PakkerTest do
  use ExUnit.Case
  doctest Pakker

  setup do
    bits = << 0x10, 0xab, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0 >>
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

defmodule PakkerMessageTest do
  use ExUnit.Case

  setup do
    bits = << 0x81, 0x01 >>
    message = Pakker.Message.from_bits(bits)
    {:ok, message: message}
  end

  test "it parses the message header",meta do
    assert meta[:message].message_type == 0x81
  end

  test "it finds the message type atom",meta do
    assert Pakker.Message.pakctrl(meta[:message]) == :delivery_message
  end
end

defmodule PakkerSetSerTest do
  use ExUnit.Case

  setup do
    # ring packet from 4094 to pakbus address 1 "BD 90 01 0F FE 71 D2 BD"
    bits = << 0x90, 0x01, 0x0f, 0xfe >>
    packet = Pakker.SetSerPkt.from_bits(bits)
    {:ok, packet: packet}
  end

  test "it reads the link state as ring", meta do
    assert meta[:packet].link_state ==  0b1001
  end

  test "it reads the destination physical address as 1", meta do
    assert meta[:packet].dest_physical_address == 0b1
  end

  test "it reads the source physical address as 4094", meta do
    assert meta[:packet].source_physical_address == 4094
  end

end

defmodule PakkerFrame do
  use ExUnit.Case

  setup do
    # ring packet from 4094 to pakbus address 1 "BD 90 01 0F FE 71 D2 BD"
    bits = << 0xbd, 0xbd, 0xbd, 0xbd, 0x90, 0x01, 0x0f, 0xfe, 0x71, 0xd2, 0xbd >>
    packet = Pakker.Frame.from_bits(bits)
    {:ok, packet: packet}
  end

  test "it removes SerSync bytes", meta do
    assert meta[:packet] == << 0x90, 0x01, 0x0f, 0xfe, 0x71, 0xd2 >>
  end

end

defmodule PakkerFrameQuote do
  use ExUnit.Case

  setup do
    bits = << 0x90,  0xbc, 0xdd, 0x01, 0x0f, 0xfe, 0x71, 0xbc, 0xdc, 0xd2 >>
    packet = Pakker.Frame.unquote_message(bits)
    {:ok, packet: packet}
  end

  test "it unquotes SerSync and quote bytes", meta do
    assert meta[:packet] == << 0x90, 0xbd, 0x01, 0x0f, 0xfe, 0x71, 0xbc, 0xd2 >>
  end
end
