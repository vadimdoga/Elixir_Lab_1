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
  def handle_cast({:aggregator, _list}, state) do
    # IO.inspect(list)

    {:noreply, state}
  end

end




