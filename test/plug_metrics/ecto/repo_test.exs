defmodule PlugMetrics.Ecto.RepoTest do
  use ExUnit.Case

  alias PlugMetrics.{Repo, MetricsServer, MetricsClient, Metric, QueryPayload}

  setup do
    {:ok, _} = Repo.start_link
    {:ok, _} = MetricsServer.start_link

    :ok
  end

  describe "#__log__" do
    test "converts and pushes the metric to the server" do
      :ok = MetricsClient.register

      Repo.__log__(%Ecto.LogEntry{caller_pid: self(), queue_time: 1, query_time: 2, decode_time: 3})

      assert MetricsClient.pop == [%Metric{payload: %QueryPayload{queue_time: 1, query_time: 2, decode_time: 3}}]
    end
  end
end
