defmodule PlugMetrics.Metric do
  defstruct [:payload]
end

defmodule PlugMetrics.MetricQueryPayload do
  defstruct [:queue_time, :query_time, :decode_time]
end
