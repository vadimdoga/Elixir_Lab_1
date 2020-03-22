defmodule FlowAggr do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @impl true
  def init(_state) do
    start_time = Time.utc_now()
    index = 0
    frc_list = []
    state = %{:start_time => start_time, :index => index, :frc_list => frc_list}
    {:ok, state}
  end

  @impl true
  def handle_cast({:flow_aggr, list_weather}, state) do
    frc = List.first(list_weather)
    start_time = state[:start_time]
    index = state[:index]
    frc_list = state[:frc_list]

    frc_list = frc_list ++ [frc]
    time = Time.utc_now()
    diff_time = Time.diff(time, start_time, :millisecond)

    if diff_time < 5000 do
      index = index + 1
      state = %{:start_time => start_time, :index => index, :frc_list => frc_list}
      {:noreply, state}
    else
      frc_top = top_frc(frc_list)
      index = 0
      frc_list = []
      state = %{:start_time => time, :index => index, :frc => frc, :frc_list => frc_list, :frc_top => frc_top}
      {:noreply, state}
    end
  end

  @impl true
  def handle_call(:top_frc, _from, state) do

    {:reply, state[:frc_top], state}
  end

  def top_frc(frc_list) do
    map = Enum.frequencies(frc_list)
    map = Enum.sort(map,  fn {_k, v}, {_k1, v1} -> v > v1 end)
    tuple = Enum.at(map, 0)
    list = Tuple.to_list(tuple)
    List.first(list)
  end




end
