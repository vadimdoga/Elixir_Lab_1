defmodule Lab1.Application do
  use Application

  @registry :workers_registry

  def start(_type, _args) do
    children = [
      {
        Registry,
        [keys: :unique, name: @registry]
      },
      {
        DynSupervisor,
        []
      },
      %{
        id: Fetch,
        start: {Fetch, :start_link, ["http://localhost:4000/iot"]}
      },
      %{
        id: Router,
        start: {Router, :start_link, []}
      },
      %{
        id: Aggregator,
        start: {Aggregator, :start_link, []}
      },
      %{
        id: FlowRouter,
        start: {FlowRouter, :start_link, []}
      },
      %{
        id: FlowAggr,
        start: {FlowAggr, :start_link, []}
      }
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
