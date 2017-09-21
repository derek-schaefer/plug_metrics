defmodule PlugMetrics.MetricsServer do
  use GenServer

  alias PlugMetrics.Metric

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, nil, Keyword.merge([name: __MODULE__], options))
  end

  def init(_options) do
    {:ok, Map.new}
  end

  def handle_call(:register, {pid, _tag}, state) when is_pid(pid) do
    {:reply, :ok, Map.put_new(state, pid, [])}
  end

  def handle_call(:pop, {pid, _tag}, state) when is_pid(pid) do
    {:reply, Map.get(state, pid), Map.pop(state, pid) |> elem(1)}
  end

  def handle_cast({:push, pid, %Metric{} = metric}, state) when is_pid(pid) do
    {:noreply, Map.replace(state, pid, [metric | Map.get(state, pid, [])])}
  end
end
