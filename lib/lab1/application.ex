defmodule Lab1.Application do

  use Application

  def start(_type, _args) do

    children = [
      %{
        id: DynSupervisor,
        start: {DynSupervisor, :start_link, [:ok]}
      },
      %{
        id: Fetch,
        start: {Fetch, :start_link, ["http://localhost:4000/iot"]}
      },
      %{
        id: Router,
        start: {Router, :recv, [[]]}
      },
      %{
        id: Aggregator,
        start: {Aggregator, :recv, [:ok]}
      }
    ]

    opts = [strategy: :one_for_one, name: Lab1.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
