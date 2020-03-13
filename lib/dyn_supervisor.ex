defmodule DynSupervisor do
  use DynamicSupervisor

  def start_link(_init_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def add_slave(msg) do
    child_spec = %{
      id: Slave,
      start: {Slave, :start, [msg]}
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
