defmodule Router do
  #recv data from Fetch module
  def recv(list_pid) do
    receive do
      {:data, msg} -> msg_operations(msg, list_pid)
      _ -> IO.puts("No match!")
    end
  end
  #work with msg
  def msg_operations(msg, list_pid) do
    list_pid_size = Enum.count(list_pid)
    #generate a random name
    name = generate_name()
    #if list_pid is less then 20 add a new actor
    compare_add(list_pid, list_pid_size, name, msg)
    #if list_pid is more then 20 it will go through pid_list and remove each pid using supervisor
    compare_remove(list_pid, list_pid_size)
  end

  defp compare_add(list_pid, list_pid_size, name, msg) do
    if list_pid_size < 20 do
      {state, pid} = DynSupervisor.add_slave(name, msg)
      if state == :error do
        recv(list_pid)
      end
      list_pid = list_pid ++ [pid]
      # IO.inspect(pid)
      # IO.inspect(DynSupervisor.count_children())
      recv(list_pid)
    end
  end

  defp compare_remove(list_pid, list_pid_size) do
    if list_pid_size >= 20 do
      Enum.map(0..19, fn x ->
        pid = Enum.at(list_pid, x)
        # IO.inspect(pid)
        _pid = DynSupervisor.rm_slave(pid)
        # IO.inspect(pid)
      end)
      list_pid = []
      recv(list_pid)
    end
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
