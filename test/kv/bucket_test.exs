defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link([])
    %{bucket: bucket}
  end

  test "store values by key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "milk") == :error

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == {:ok, 3}
  end

  test "delete values by key", %{bucket: bucket} do
    assert KV.Bucket.delete(bucket, "eggs") == nil

    KV.Bucket.put(bucket, "eggs", 5)
    assert KV.Bucket.get(bucket, "eggs") == {:ok, 5}
    assert KV.Bucket.delete(bucket, "eggs") == 5
    assert KV.Bucket.delete(bucket, "eggs") == nil
  end
end
