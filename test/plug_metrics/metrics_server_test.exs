defmodule PlugMetrics.MetricsServerTest do
  use ExUnit.Case

  alias PlugMetrics.{MetricsServer, Metric}

  setup do
    {:ok, _} = MetricsServer.start_link

    :ok
  end

  describe "#handle_call" do
    test "pop returns any empty list if the consumer has been registered" do
      :ok = call(:register)

      assert [] = call(:pop)
    end

    test "pop returns nil if called multiple times" do
      :ok = call(:register)

      assert call(:pop) == []
      assert call(:pop) == nil
    end

    test "pop returns nil if the consumer has not been registered" do
      :ok = call(:register)

      assert fn -> call(:pop) end |> Task.async |> Task.await == nil
    end

    test "register does not overwrite existing metrics if called multiple times" do
      :ok = call(:register)
      :ok = cast({:push, self(), %Metric{}})
      :ok = call(:register)

      assert call(:pop) == [%Metric{}]
    end

    test "registering after popping resets the state" do
      :ok = call(:register)
      :ok = cast({:push, self(), %Metric{}})

      assert call(:pop) == [%Metric{}]

      :ok = call(:register)
      :ok = cast({:push, self(), %Metric{}})

      assert call(:pop) == [%Metric{}]
    end
  end

  describe "#handle_cast" do
    test "push stores the metric if the consumer has been registered" do
      :ok = call(:register)
      :ok = cast({:push, self(), %Metric{}})

      assert call(:pop) == [%Metric{}]
    end

    test "push does not store the metric if the consumer has not been registered" do
      :ok = cast({:push, self(), %Metric{}})

      assert call(:pop) == nil
    end

    test "push accumulates metrics if called multiple times" do
      :ok = call(:register)
      :ok = cast({:push, self(), %Metric{}})
      :ok = cast({:push, self(), %Metric{}})

      assert call(:pop) == [%Metric{}, %Metric{}]
    end
  end

  defp call(payload) do
    GenServer.call(MetricsServer, payload)
  end

  defp cast(payload) do
    GenServer.cast(MetricsServer, payload)
  end
end
