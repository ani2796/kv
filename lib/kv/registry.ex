defmodule KV.Registry do
  use GenServer

  # initialize
  @impl true
  def init(:ok) do
    names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end

  # CLIENT FNS

  # Starts GenServer, callbacks in current module, pass options
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  # Client lookup call to particular registry server
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  # Client create call to particular registry server
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  # SERVER FNS

  # Calls are synchronous, client waits for return result
  # Lookup bucket `name` in registry
  @impl true
  def handle_call({:lookup, name}, _from, state) do
    {names, _} = state
    {:reply, Map.fetch(names, name), state}
  end

  # Casts are asynchronous, :ok returned immediately, caller returns to execution
  # If not exists, create new bucket mapped to `name` in registry
  @impl true
  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      # DANGEROUS to link registry to buckets like this
      # Crashed bucket will cause registry to crash
      # SOLUTION: Use dynamic supervisors, specifying action on failure
      {:ok, bucket} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
      ref = Process.monitor(bucket)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, bucket)
      {:noreply, {names, refs}}
    end
  end

  # Handle a DOWN msg from a failed bucket - pop from refs, delete from names
  @impl true
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  # Log unexpected msgs sent to registry
  @impl true
  def handle_info(msg, state) do
    require Logger
    Logger.debug("Unexpected message #{inspect(msg)} received at KV.Registry")
    {:noreply, state}
  end

end
