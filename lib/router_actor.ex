defmodule Router do
  #*get data from fetch
  #*control data flow and based on that can ask for more or less actors from dyn_supervisor
  #*send data to actors
  def recv do
    receive do
      {:data, msg} -> msg_operations(msg)
      _ -> IO.puts("No match!")
    end
  end

  def msg_operations(msg) do
    IO.inspect(msg)
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
