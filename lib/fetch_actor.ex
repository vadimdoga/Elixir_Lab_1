defmodule Fetch do
  use GenServer

  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(url) do
    {:ok, _pid} = EventsourceEx.new(url, stream_to: self())
    #spawn router pid a single time and insert into kind of global state
    {:ok, router_pid} = GenServer.start_link(Router, [])
    {:ok, flow_pid} = GenServer.start_link(Flow, [])
    {:ok, aggregator_pid} = GenServer.start_link(Aggregator, [])

    :ets.new(:buckets_registry, [:named_table])
    :ets.insert(:buckets_registry, {"router_pid", router_pid})
    :ets.insert(:buckets_registry, {"flow_pid", flow_pid})
    :ets.insert(:buckets_registry, {"aggregator_pid", aggregator_pid})

    recv()
  end

  def recv do
    receive do
      msg -> msg_operations(msg)
    end

    recv()
  end

  def msg_operations(msg) do
    #use router pid form kind of global state
    [{_id, router_pid}] = :ets.lookup(:buckets_registry, "router_pid")
    [{_id, flow_pid}] = :ets.lookup(:buckets_registry, "flow_pid")
    GenServer.cast(flow_pid, :to_flow)
    GenServer.cast(router_pid, {:fetch_data, msg, flow_pid})
  end

end
