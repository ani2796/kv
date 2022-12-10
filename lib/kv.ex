defmodule KV do
  use Application

  def create_buckets(count) do
    bucket_ids = Enum.to_list(1..count)
    bucket_ids = bucket_ids
      |> Enum.map(fn id -> ("bucket"<>to_string(id)) end)
      |> Enum.map(fn id -> (KV.Registry.create(KV.Registry, id)) end)
    bucket_ids
  end

  @impl true
  def start(_type, args) do
    {:ok, sup} = KV.Supervisor.start_link(name: KV.Supervisor)
    _ = KV.create_buckets(args[:count])
    {:ok, sup}
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
