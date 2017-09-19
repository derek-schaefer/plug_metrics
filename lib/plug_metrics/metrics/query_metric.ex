defmodule PlugMetrics.Metrics.QueryMetric do
  defstruct [:queue_time, :query_time, :decode_time]

  def from_ecto(%Ecto.LogEntry{} = entry) do
    %__MODULE__{
      queue_time: entry.queue_time,
      query_time: entry.query_time,
      decode_time: entry.decode_time
    }
  end
end
