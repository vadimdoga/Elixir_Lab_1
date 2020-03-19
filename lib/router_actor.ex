defmodule Router do
  def recv(list_msg) do
    receive do
      {:data, msg} -> msg_operations(msg, list_msg)
      _ -> IO.puts("No match!")
    end
  end

  def msg_operations(msg, list_msg) do

    name =
      ?a..?z
      |> Enum.take_random(6)
      |> List.to_string()

    pid = DynSupervisor.add_slave(name, msg)
    IO.inspect(pid)
    IO.inspect(DynSupervisor.count_children())

    # list_msg = list_msg++[msg]
    # list_msg_size = Enum.count(list_msg)
    # pid = DynSupervisor.add_slave(Slave, :start_link, [msg])


    # IO.inspect(DynSupervisor.count_children())

    # if list_msg_size < 15 do
    #   # IO.inspect(1)
    #   # IO.inspect(pid)
    #   list_msg = List.delete_at(list_msg, 0)
    #   recv(list_msg)
    # end

    recv(list_msg)
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
