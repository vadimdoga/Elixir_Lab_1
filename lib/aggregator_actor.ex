defmodule Aggregator do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl true
  def handle_cast({:aggregator, flow_aggr_pid}, state) do
    frc = GenServer.call(flow_aggr_pid, :top_frc)
    if frc != nil do
      IO.inspect(frc)
    end
    {:noreply, state}
  end

end




