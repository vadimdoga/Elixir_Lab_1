defmodule Aggregator do
  def start_link do
    recv()
  end
  def recv do
    receive do
      {:frc, msg} -> msg_operations(msg)
      _ -> IO.puts("No match!")
    end
  end
  def msg_operations(msg) do
    # IO.inspect(msg)
    # Process.sleep(5000)
    recv()
  end
end




