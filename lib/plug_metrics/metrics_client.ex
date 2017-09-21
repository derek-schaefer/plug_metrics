defmodule PlugMetrics.MetricsClient do
  alias PlugMetrics.{MetricsServer, Metric}

  def init(options \\ []) do
    Keyword.merge([server: MetricsServer], options)
  end

  def register(options \\ []) do
    GenServer.call(server(options), :register)
  end

  def push(pid, %Metric{} = metric, options \\ []) when is_pid(pid) do
    GenServer.cast(server(options), {:push, pid, metric})
  end

  def pop(options \\ []) do
    GenServer.call(server(options), :pop)
  end

  defp server(options) do
    Keyword.get(init(options), :server)
  end
end
