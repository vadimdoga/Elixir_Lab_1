require Root

defmodule Fetch do
  def start_link(url) do
    {:ok, _pid} = EventsourceEx.new(url, stream_to: self())
    root_pid = spawn_link(Root, :recv, [])
    :ets.new(:buckets_registry, [:named_table])
    :ets.insert(:buckets_registry, {"root_pid", root_pid})
    recv()
  end

  def recv do
    receive do
      msg -> msg_operations(msg)
    end

    recv()
  end

  def msg_operations(msg) do
    [{_id, root}] = :ets.lookup(:buckets_registry, "root_pid")
    send(root, {:data, msg})
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
    }
  end
end
