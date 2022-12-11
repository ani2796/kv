defmodule KV.BucketSupervisor do
  use DynamicSupervisor

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def start_child(name) do
    child_spec =  {KV.Bucket, name}
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @impl true
  def init(args) do
    DynamicSupervisor.init(args)
  end
end
