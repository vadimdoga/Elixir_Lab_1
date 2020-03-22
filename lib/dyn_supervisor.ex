defmodule DynSupervisor do
  use DynamicSupervisor

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one, max_children: 25)
  end

  def add_slave(child_name, msg) do
    child_spec = %{
      id: Slave,
      start: {Slave, :start_link, [child_name,msg]},
      restart: :temporary
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
