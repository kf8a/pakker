defmodule Pakker.Packet do
  defstruct link_state: nil,
            dest_physical_address: nil,
            expect_more: nil,
            priority: nil,
            source_physical_address: nil,
            hi_proto_code: nil,
            dest_node_id: nil,
            hop_count: nil,
            source_node_id: nil,
            body: nil

    def from_bits(bits) do
      << link_state :: size(4),
         dest_physical_address :: size(12),
         expect_more :: size(2),
         priority :: size(2),
         source_physical_address :: size(12),
         hi_proto_code :: size(4),
         dest_node_id :: size(12),
         hop_count :: size(4),
         source_node_id :: size(12),
         body:: bitstring >> = bits

     # TODO separate out the signature nullifier and check for validity

      %Pakker.Packet{
        link_state: link_state,
        dest_physical_address: dest_physical_address,
        expect_more: expect_more,
        priority: priority,
        source_physical_address: source_physical_address,
        hi_proto_code: hi_proto_code,
        dest_node_id: dest_node_id,
        hop_count: hop_count,
        source_node_id: source_node_id,
        body: body
      }
    end
end
