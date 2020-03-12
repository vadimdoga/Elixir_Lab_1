require Root

defmodule Fetch do
  use GenServer

  def start_link(_url) do
    # IO.inspect("starting", label: "Counter.One")
    GenServer.start_link(__MODULE__, "http://localhost:4000/iot")
    # IO.inspect("started", label: "Counter.One")
  end

  def init(url) do
    {:ok, _pid} = EventsourceEx.new(url, stream_to: self())
    root_pid = spawn_link(Root, :recv, [])
    :ets.new(:buckets_registry, [:named_table])
    :ets.insert(:buckets_registry, {"root_pid", root_pid})

    recv()
    {:ok, url}
  end

  def recv do
    receive do
      msg -> msg_operations(msg)
    end

    recv()
  end

  def msg_operations(msg) do
    data = json_parse(msg)
    [{_id, root}] = :ets.lookup(:buckets_registry, "root_pid")
    send(root, {:data, data})
  end

  def json_parse(msg) do
    try do
      msg_data = Jason.decode!(msg.data)
      msg_data["message"]
    rescue
      Jason.DecodeError -> raise "panic_msg"
    end
  end
end
