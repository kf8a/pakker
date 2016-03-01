defmodule Pakker.Command do
  def ring(from, to) do
      pkt = %Pakker.SetSerPkt{
        link_state: :ring,
        dest_physical_address: to,
        expect_more: :last,
        priority: 0,
        source_physical_address: from}

   Pakker.SetSerPkt.to_bits(pkt) 
  end
end

defmodule CommandTest do
  use ExUnit.Case

  test "it sends a hello string from address 4094 to 1" do
    result = Pakker.Command.ring(4094,1)
    #assert result == << 0xbd, 0x90, 0x01, 0x0f, 0xfe, 0x71, 0xd2, 0xbd >>
    assert result == << 0x90, 0x01, 0x0f, 0xfe >>
  end
end
