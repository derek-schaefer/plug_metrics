defimpl PlugMetrics.Metricable, for: Ecto.LogEntry do
  def from(source) do
    %PlugMetrics.Metric{
      payload: %PlugMetrics.QueryPayload{
        queue_time: source.queue_time,
        query_time: source.query_time,
        decode_time: source.decode_time
      }
    }
  end
end
