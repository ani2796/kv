defmodule Kv.RegistryTest do
  use ExUnit.Case, async: true

  # start_supervised is the same as calling KV.Registry.start_link/1
  # except that it guarantees registry shutdown between tests
  setup do
    registry = start_supervised!(KV.Registry)
    %{registry: registry}
  end

  test "spawn buckets", %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error

    KV.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    KV.Bucket.put(bucket, "milk", 1)
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "remove bucket", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    Agent.stop(bucket, :normal)
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

end
