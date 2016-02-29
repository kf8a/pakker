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
      link_state_bits = case pkt.link_state do
        :ring     -> 0b1010
        :off_line -> 0b1000
        :ready    -> 0b1010
        :finished -> 0b1011
        :pause    -> 0b1100
      end
      more_code_bits = case pkt.expect_more do
        :last    -> 0b00
        :more    -> 0b01
        :neutral -> 0b10
        :reverse -> 0b11
      end
      link_state_bits + 0b000 + pkt.dest_physical_address #+ more_code_bits <<< 6
    end
end
