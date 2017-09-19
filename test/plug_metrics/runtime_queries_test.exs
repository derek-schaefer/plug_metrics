defmodule PlugMetrics.RuntimeQueriesTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Ecto.Query, only: [from: 2]

  alias PlugMetrics.Repo
  alias PlugMetrics.RuntimeQueries

  setup do
    Repo.start_link |> elem(0)
  end

  defp call(conn) do
    conn
    |> RuntimeQueries.call(RuntimeQueries.init())
    |> send_resp(200, "Hello, world!")
  end

  test "sets runtime query headers" do
    Repo.all((from u in "users", select: "*"))

    conn = conn(:get, "/") |> call

    [query_count] = get_resp_header(conn, "x-runtime-queries-count")
    [queue_time] = get_resp_header(conn, "x-runtime-queries-queue-time")
    [query_time] = get_resp_header(conn, "x-runtime-queries-query-time")
    [decode_time] = get_resp_header(conn, "x-runtime-queries-decode-time")
    [total_time] = get_resp_header(conn, "x-runtime-queries-total-time")

    assert Integer.parse(query_count) |> elem(0) == 1
    assert Float.parse(queue_time) |> elem(0) >= 0
    assert Float.parse(query_time) |> elem(0) >= 0
    assert Float.parse(decode_time) |> elem(0) >= 0
    assert Float.parse(total_time) |> elem(0) >= 0
  end
end
