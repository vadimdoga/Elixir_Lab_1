defmodule Lab1.Application do

  use Application

  def start(_type, _args) do

    children = [
      %{
        id: Supervisor_1,
        start: {Supervisor_1, :start_link, ["http://localhost:4000/iot"]}
      },
    ]

    opts = [strategy: :one_for_one, name: Lab1.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
