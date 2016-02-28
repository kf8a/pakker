# SetSer Link SubProtocol
defmodule Pakker.SetSerPkt do
  use Bitwise

  defstruct link_state: nil,
            dest_physical_address: nil,
            expect_more: nil,
            priority: nil,
            source_physical_address: nil,
            body: nil

    def from_bits(bits) do
      << link_state :: size(4),
         dest_physical_address :: size(12),
         expect_more :: size(2),
         priority :: size(2),
         source_physical_address :: size(12),
         body :: bitstring >> = bits

      %Pakker.SetSerPkt{
        link_state: link_state,
        dest_physical_address: dest_physical_address,
        expect_more: expect_more,
        priority: priority,
        source_physical_address: source_physical_address,
        body: body
      }
    end

    def to_bits(pkt) do
      result = <<>>
      result = result <<< pkt.link_state
    end
end
