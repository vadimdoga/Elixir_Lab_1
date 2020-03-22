defmodule Router do
  def start_link do
    list_pid = []
    list_msg = []
    index = 0
    counter = 0
    aggregator_pid = spawn_link(Aggregator, :start_link, [])
    :ets.new(:buckets_registry1, [:named_table])
    :ets.insert(:buckets_registry1, {"aggregator_pid", aggregator_pid})
    recv(list_msg, list_pid, index, counter)
  end
  #recv data from Fetch module
  def recv(list_msg, list_pid, index, counter) do
    receive do
      {:flow} -> IO.puts("yes")
      {:data, msg} -> msg_operations(msg, list_msg, list_pid, index, counter)
      _ -> IO.puts("No match!")
    end
  end

  #work with msg
  def msg_operations(msg, list_msg, list_pid, index, counter) do
    index = index + 1
    list_msg = [msg | list_msg]

    if index < 3 do
      {list_pid, list_msg} = add_slave(list_msg, list_pid, index, counter)
      recv(list_msg, list_pid, index, counter)
    end

    # IO.inspect(Enum.count(list_pid), label: "pids")

    # IO.inspect(Enum.count(list_msg), label: "Before")
    {list_pid, list_msg, counter} = reutilise_slave(list_pid, list_msg, counter)
    # IO.inspect(DynSupervisor.count_children())
    # IO.inspect(Enum.count(list_pid), label: "After")
    recv(list_msg, list_pid, index, counter)
  end

  def add_slave(list_msg, list_pid, index, counter) do
    #generate a random name
    name = generate_name()
    msg = List.last(list_msg)
    # IO.inspect(msg)
    {state, pid} = DynSupervisor.add_slave(name, msg)
    # IO.inspect(pid)
    list_pid = [pid | list_pid]
    list_msg = List.delete_at(list_msg, -1)
    if state == :error do
      recv(list_msg, list_pid, index, counter)
    end
    {list_pid, list_msg}
  end

  def rm_slave(list_pid) do
    pid = List.last(list_pid)
    DynSupervisor.rm_slave(pid)
    list_pid = List.delete_at(list_pid, -1)
    list_pid
  end

  def reutilise_slave(list_pid, list_msg, counter) do
    list_pid_size = Enum.count(list_pid)

    counter = if counter > list_pid_size do
      0
    else
      counter
    end

    pid = Enum.at(list_pid, counter)
    msg = List.last(list_msg)
    list_msg = List.delete_at(list_msg, -1)
    GenServer.cast(pid, {:rtl, msg})

    counter = counter + 1
    {list_pid, list_msg, counter}
  end

  defp generate_name do
    ?a..?z|> Enum.take_random(6)|> List.to_string()
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :recv, [opts]},
      type: :worker,
      restart: :permanent
    }
  end
end
