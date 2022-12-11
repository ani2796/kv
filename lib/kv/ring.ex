
defmodule KV.Ring do
  use GenServer
  require ExHashRing
  require Logger

  # TDD for HashRing
  # Check that the initial HashRing exists and is empty
  # Check that you are able to add a process to the HashRing

  def start_link(opts) do
    pref_list = Keyword.fetch!(opts, :name)
    GenServer.start_link(__MODULE__, pref_list, opts)
  end

  def get_ring(ring_server) do
    GenServer.call(ring_server, {:ring})
  end

  def add_to_ring(ring_server, node) do
    Logger.info("Adding node: #{node} to ring")
    GenServer.call(ring_server, {:insert_node, node})
  end

  # SERVER FUNCTIONS

  @impl true
  def init(pref_list_table) do
    pref_list = :ets.new(pref_list_table, [:named_table, read_concurrency: true])
    {:ok, ring} = ExHashRing.Ring.start_link()

    Logger.info("Starting HashRing: #{inspect(ring)}, preference list table: #{inspect(pref_list)}")

    {:ok, {ring, pref_list}}
  end

  @impl true
  def handle_call({:ring}, _from, {ring, pref_list}) do
    {:reply, ring, {ring, pref_list}}
  end

  @impl true
  def handle_call({:insert_node, node}, _from, {ring, pref_list}) do
    {:ok, items} = ExHashRing.Ring.add_node(ring, node, 1)
    {:reply, items, {ring, pref_list}}
  end


end
