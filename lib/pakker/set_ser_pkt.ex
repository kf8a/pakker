defmodule Pakker.SetSerPkt do
  @moduledoc """
  SetSer Packet Structs and
  functions to serialize and deserialize to bits
  """
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
      << link_state_bits(pkt.link_state) :: size(4),
          pkt.dest_physical_address :: size(12),
          more_code_bits(pkt.expect_more) :: size(2),
          pkt.priority :: size(2),
          pkt.source_physical_address :: size(12) >>
    end

    defp link_state_bits(link_state) do
      link_state_map = %{
        :ring     => 0b1001,
        :off_line => 0b1000,
        :ready    => 0b1010,
        :finished => 0b1011,
        :pause    => 0b1100,
      }
      Map.get(link_state_map, link_state)
    end

    defp more_code_bits(expect_more) do
      more_code_map = %{
        :last    => 0b00,
        :more    => 0b01,
        :neutral => 0b10,
        :reverse => 0b11,
      }
      Map.get(more_code_map, expect_more)
    end
end
