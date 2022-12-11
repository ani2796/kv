defmodule KV do
  use Application
  require Logger

  @hash_ring :hash_ring

  defp start_buckets(count) do
    buckets = (Enum.to_list(1..count))
      |> Enum.map(fn bucket -> ("bucket" <> to_string(bucket)) end)
      |> Enum.map(fn bucket -> (
        KV.BucketSupervisor.start_child(bucket);
        KV.Ring.add_to_ring(@hash_ring, bucket);
        bucket)
      end)

    Logger.info("Created buckets: #{inspect(buckets)}")
  end

  @impl true
  def start(_type, args) do
    sup = KV.Supervisor.start_link(name: KV.Supervisor)
    start_buckets(args[:count])
    sup
  end

  @moduledoc """
  Documentation for `KV`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> KV.hello()
      :world

  """
  def hello do
    :world
  end
end
