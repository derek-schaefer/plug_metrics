defmodule PlugMetrics.Integrations.Ecto do
  alias PlugMetrics.Metrics.QueryMetric

  defmacro __using__(_options) do
    quote do
      defoverridable [__log__: 1]

      def __log__(entry) do
        send entry.caller_pid, QueryMetric.from_ecto(entry)

        super(entry)
      end
    end
  end
end
