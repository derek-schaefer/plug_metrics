defmodule PlugMetrics.Ecto.Repo do
  alias PlugMetrics.{MetricsClient, Metricable}

  defmacro __using__(options \\ []) do
    quote do
      defoverridable [__log__: 1]

      def __log__(entry) do
        MetricsClient.push(entry.caller_pid, Metricable.from(entry), unquote(options))

        super(entry)
      end
    end
  end
end
