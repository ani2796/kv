defmodule KV.Supervisor do
  # Supervisor can start processes, deal with failure
  # and shut down processes
  use Supervisor

  @bucket_registry :bucket_registry

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      # {KV.Registry, name: KV.Registry},
      # Can use DynamicSupervisor functions to terminate children
      {KV.BucketSupervisor, strategy: :one_for_one},
      {Registry, [keys: :unique, name: @bucket_registry]}
    ]

    # Invokes child_spec/1 on each child (automatically created on `use Agent`, `use Registry` or `use Supervisor`)
    # name passed to opts of KV.Registry.start_link
    # `one_for_all` strategy means if any child terminates, all are restarted
    # `one_for_one` strategy means if one child terminates, it is solely restarted
    # `rest_for_one` strategy means if one child terminates, all children spawned after it will restart
    Supervisor.init(children, strategy: :one_for_all)
  end
end
