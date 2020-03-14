defmodule Router do
  #//get data from fetch
  #*control data flow, based on that ask for more or less actors from dyn_supervisor
  #//send data to actors
  def recv(list_msg, list_pid) do
    receive do
      {:data, msg} -> msg_operations(msg, list_msg, list_pid)
      _ -> IO.puts("No match!")
    end
  end

  def msg_operations(msg, list_msg, list_pid) do
    list_msg = list_msg++[msg]
    list_msg_size = Enum.count(list_msg)
    list_pid_size = Enum.count(list_pid)
    IO.inspect(list_msg_size)

    if list_msg_size > 5 && list_msg_size < 15 do
      {:ok, pid} = DynSupervisor.add_slave(List.first(list_msg))
      list_msg = List.delete_at(list_msg, 0)
      list_pid = list_pid++[pid]
      recv(list_msg, list_pid)
    end

    if list_msg_size > 0 && list_msg_size < 5 do
      try do
        DynSupervisor.rm_slave(List.first(list_pid))
        list_pid = List.delete_at(list_pid, 0)
        recv(list_msg, list_pid)
        rescue
          FunctionClauseError -> "Empty"
      end
    end

    recv(list_msg, list_pid)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :recv, [opts]},
      type: :worker,
      restart: :permanent,
    }
  end
end
