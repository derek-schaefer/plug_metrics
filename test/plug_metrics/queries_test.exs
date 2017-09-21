defmodule PlugMetrics.QueriesTest do
  use ExUnit.Case
  use Plug.Test

  import Ecto.Query, only: [select: 2]

  alias PlugMetrics.{Repo, MetricsServer, Queries}

  setup do
    {:ok, _} = start_supervised(Repo, [])
    {:ok, _} = start_supervised(MetricsServer, [])

    :ok
  end

  defp call(conn, options) do
    Queries.call(conn, Queries.init(options))
  end

  defp call_with_metrics(conn, options \\ []) do
    conn
    |> call(options)
    |> action
    |> response
  end

  defp call_without_metrics(conn, options \\ []) do
    conn
    |> call(options)
    |> response
  end

  defp action(conn) do
    Repo.insert_all("users", [%{name: "test"}], [])
    select("users", "*") |> Repo.all
    conn
  end

  defp response(conn) do
    send_resp(conn, 200, "Hello, world!")
  end

  test "sets query headers if metrics are available" do
    conn = conn(:get, "/") |> call_with_metrics

    [query_count] = get_resp_header(conn, "x-queries-count")
    [queue_time] = get_resp_header(conn, "x-queries-queue-time")
    [query_time] = get_resp_header(conn, "x-queries-query-time")
    [decode_time] = get_resp_header(conn, "x-queries-decode-time")
    [total_time] = get_resp_header(conn, "x-queries-total-time")

    assert Integer.parse(query_count) |> elem(0) == 2
    assert Float.parse(queue_time) |> elem(0) >= 0
    assert Float.parse(query_time) |> elem(0) >= 0
    assert Float.parse(decode_time) |> elem(0) >= 0
    assert Float.parse(total_time) |> elem(0) >= 0
  end

  test "sets query headers if metrics are not available" do
    conn = conn(:get, "/") |> call_without_metrics

    [query_count] = get_resp_header(conn, "x-queries-count")
    [queue_time] = get_resp_header(conn, "x-queries-queue-time")
    [query_time] = get_resp_header(conn, "x-queries-query-time")
    [decode_time] = get_resp_header(conn, "x-queries-decode-time")
    [total_time] = get_resp_header(conn, "x-queries-total-time")

    assert Integer.parse(query_count) |> elem(0) == 0
    assert Float.parse(queue_time) |> elem(0) == 0
    assert Float.parse(query_time) |> elem(0) == 0
    assert Float.parse(decode_time) |> elem(0) == 0
    assert Float.parse(total_time) |> elem(0) == 0
  end

  test "sets query headers using a custom name" do
    conn = conn(:get, "/") |> call_without_metrics(http_header: "x-custom")

    [query_count] = get_resp_header(conn, "x-custom-count")
    [queue_time] = get_resp_header(conn, "x-custom-queue-time")
    [query_time] = get_resp_header(conn, "x-custom-query-time")
    [decode_time] = get_resp_header(conn, "x-custom-decode-time")
    [total_time] = get_resp_header(conn, "x-custom-total-time")

    assert Integer.parse(query_count) |> elem(0) == 0
    assert Float.parse(queue_time) |> elem(0) == 0
    assert Float.parse(query_time) |> elem(0) == 0
    assert Float.parse(decode_time) |> elem(0) == 0
    assert Float.parse(total_time) |> elem(0) == 0
  end
end
