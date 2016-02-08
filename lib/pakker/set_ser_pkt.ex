defmodule Pakker.SetSerPkt do
  defstruct link_state: nil,
            dest_physical_address: nil,
            expect_more: nil,
            priority: nil,
            source_physical_address: nil

    def from_bits(bits) do
      << link_state :: size(4),
         dest_physical_address :: size(12),
         expect_more :: size(2),
         priority :: size(2),
         source_physical_address :: size(12) >> = bits

     # TODO separate out the signature nullifier and check for validity

      %Pakker.SetSerPkt{
        link_state: link_state,
        dest_physical_address: dest_physical_address,
        expect_more: expect_more,
        priority: priority,
        source_physical_address: source_physical_address,
      }
    end
end
