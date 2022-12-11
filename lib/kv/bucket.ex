defmodule KV.Bucket do
  use GenServer
  require Logger

  @bucket_registry :bucket_registry

  # CLIENT FUNCTIONS

  def start_link(id) do
    GenServer.start_link(__MODULE__, id, [name: via_tuple(id)])
  end

  defp via_tuple(id) do
    {:via, Registry, {@bucket_registry, id}}
  end

  def get(bucket, key) do
    GenServer.call(bucket, {:lookup, key})
  end

  def put(bucket, key, value) do
    GenServer.cast(bucket, {:insert, key, value})
  end

  def delete(bucket, key) do
    GenServer.call(bucket, {:remove, key})
  end

  # SERVER FUNCTIONS

  @impl true
  def init(id) do
    Logger.info("Started bucket with id: #{inspect(id)}")
    {:ok, %{}}
  end

  @impl true
  def handle_call({:lookup, key}, _from, store) do
    {:reply, Map.fetch(store, key), store}
  end

  @impl true
  def handle_call({:remove, key}, _from, store) do
    {del, new_store} = Map.pop(store, key)
    {:reply, del, new_store}
  end

  @impl true
  def handle_cast({:insert, key, value}, store) do
    {:noreply, Map.put(store, key, value)}
  end


end
