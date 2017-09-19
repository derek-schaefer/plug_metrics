defmodule PlugMetrics.Metrics.QueryMetricTest do
  use ExUnit.Case, async: true

  alias PlugMetrics.Metrics.QueryMetric

  describe "#from_ecto" do
    test "converts an ecto log entry" do
      actual= QueryMetric.from_ecto(
        %Ecto.LogEntry{queue_time: 1, query_time: 2, decode_time: 3}
      )

      assert actual.queue_time == 1
      assert actual.query_time == 2
      assert actual.decode_time == 3
    end
  end
end
