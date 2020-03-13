defmodule Router do
  #*get data from fetch
  #*control data flow, based on that ask for more or less actors from dyn_supervisor
  #*send data to actors
  def recv do
    receive do
      {:data, msg} -> msg_operations(msg)
      _ -> IO.puts("No match!")
    end
  end

  def msg_operations(msg) do
    DynSupervisor.add_slave(msg)
    recv()
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
