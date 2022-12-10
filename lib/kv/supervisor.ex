defmodule KV.Supervisor do
  # Supervisor can start processes, deal with failure
  # and shut down processes
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      {KV.Registry, name: KV.Registry},
      # Can use DynamicSupervisor functions to terminate children
      {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one}
    ]

    # Invokes child_spec/1 on each child (automatically created on `use Agent`, `use Registry` or `use Supervisor`)
    # name passed to opts of KV.Registry.start_link
    Supervisor.init(children, strategy: :one_for_one)
  end
end
