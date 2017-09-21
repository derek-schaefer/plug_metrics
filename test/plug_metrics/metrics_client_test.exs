defmodule PlugMetrics.MetricsClientTest do
  use ExUnit.Case

  alias PlugMetrics.{MetricsServer, MetricsClient, Metric}

  setup do
    {:ok, _} = MetricsServer.start_link

    :ok
  end

  describe "#init" do
    test "uses the metrics server by default" do
      assert Keyword.get(MetricsClient.init(), :server) == MetricsServer
    end

    test "allows the server to be specified" do
      assert Keyword.get(MetricsClient.init([server: self()]), :server) == self()
    end
  end

  describe "#register" do
    test "registers the consumer with the server" do
      assert MetricsClient.pop == nil

      :ok = MetricsClient.register

      assert MetricsClient.pop == []
    end
  end

  describe "#push" do
    test "pushes metrics to the server" do
      :ok = MetricsClient.register
      :ok = MetricsClient.push(self(), %Metric{payload: 42})
      :ok = MetricsClient.push(self(), %Metric{payload: 99})

      assert MetricsClient.pop == [%Metric{payload: 99}, %Metric{payload: 42}]
    end
  end

  describe "#pop" do
    test "pops available metrics from the server" do
      :ok = MetricsClient.register
      :ok = MetricsClient.push(self(), %Metric{payload: 42})

      assert MetricsClient.pop == [%Metric{payload: 42}]
      assert MetricsClient.pop == nil
    end
  end
end
