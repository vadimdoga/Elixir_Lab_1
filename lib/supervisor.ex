defmodule Supervisor_1 do

  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(init_arg) do
    children = [
      %{
        id: DynSupervisor,
        start: {DynSupervisor, :start_link, [:ok]}
      },
      %{
        id: Fetch,
        start: {Fetch, :start_link, [init_arg]}
      },
      %{
        id: Router,
        start: {Router, :recv, [[],[]]}
      },
      %{
        id: Aggregator,
        start: {Aggregator, :recv, [:ok]}
      }
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
