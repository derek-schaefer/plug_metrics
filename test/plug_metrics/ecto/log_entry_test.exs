defmodule PlugMetrics.Ecto.LogEntryTest do
  use ExUnit.Case

  alias PlugMetrics.{Metricable, Metric, MetricQueryPayload}

  describe "#from" do
    test "returns a metric struct with a query payload" do
      source = %Ecto.LogEntry{queue_time: 1, query_time: 2, decode_time: 3}

      assert Metricable.from(source) == %Metric{payload: %MetricQueryPayload{queue_time: 1, query_time: 2, decode_time: 3}}
    end
  end
end
