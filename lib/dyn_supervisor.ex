defmodule DynSupervisor do
  use DynamicSupervisor

  def start_link(_init_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    DynamicSupervisor.init(max_children: 5, strategy: :one_for_one)
  end

  def add_slave(msg) do
    child_spec = %{
      id: Slave,
      start: {Slave, :start, [msg]}
    }
    {:ok, pid} = DynamicSupervisor.start_child(__MODULE__, child_spec)
    {:ok, pid}
  end

  def rm_slave(pid) do
    pid = DynamicSupervisor.terminate_child(__MODULE__, pid)
  end

  def count_children do
    DynamicSupervisor.which_children(__MODULE__)
  end
end
