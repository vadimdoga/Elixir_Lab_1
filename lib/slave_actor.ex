defmodule Slave do
  def json_parse(msg) do
    msg_data = Jason.decode!(msg.data)
    msg_data["message"]
    # try do
    # rescue
    #   Jason.DecodeError -> :panic_msg
    # end
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

# cond do
#   data == :panic_msg -> recv()
#   true -> [{_id, root}] = :ets.lookup(:buckets_registry, "root_pid")
#   send(root, {:data, data})
# end
