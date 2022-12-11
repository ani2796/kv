defmodule KV.RingTest do
  use ExUnit.Case
  require Logger

  setup do
    ring_server = start_supervised!({KV.Ring, name: :pref_list_test})
    Logger.info("Setup ring server for test: #{inspect(ring_server)}")
    %{ring_server: ring_server}
  end

  test "start an empty ring", %{ring_server: ring_server} do
    ring = KV.Ring.get_ring(ring_server)
    {:ok, node_list} = ExHashRing.Ring.get_nodes(ring)
    assert length(node_list) == 0
  end

  test "add node to ring", %{ring_server: ring_server} do
    ring = KV.Ring.get_ring(ring_server)
    {:ok, node_list} = ExHashRing.Ring.get_nodes(ring)

    new_node_list = KV.Ring.add_to_ring(ring_server, "bucket1")
    assert (length(new_node_list) - length(node_list)) == 1
  end

  
end
