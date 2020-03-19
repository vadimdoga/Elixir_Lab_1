defmodule DynSupervisor do
  use DynamicSupervisor

  def start_link(_init_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_slave(mdl_name, mdl_fnc, mdl_arg) do
    name =
      ?a..?z
      |> Enum.take_random(6)
      |> List.to_string()
    child_spec = %{
      id: name,
      start: {mdl_name, mdl_fnc, mdl_arg}
    }
    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def rm_slave(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end

  def count_children do
    DynamicSupervisor.count_children(__MODULE__)
  end
end
