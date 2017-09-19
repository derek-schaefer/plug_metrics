defmodule PlugMetrics.RuntimeTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias PlugMetrics.Runtime

  defp call_fast(conn) do
    conn |> Runtime.call(Runtime.init()) |> response
  end

  defp call_slow(conn) do
    conn = Runtime.call(conn, Runtime.init())

    :timer.sleep(100)

    response(conn)
  end

  defp call(conn, options) do
    conn |> Runtime.call(Runtime.init(options)) |> response
  end

  defp response(conn) do
    send_resp(conn, 200, "Hello, world!")
  end

  test "sets a runtime header for the fast action" do
    conn = conn(:get, "/") |> call_fast
    [runtime] = get_resp_header(conn, "x-runtime")
    assert runtime |> Float.parse |> elem(0) >= 0
  end

  test "sets a runtime header for the slow action" do
    conn = conn(:get, "/") |> call_slow
    [runtime] = get_resp_header(conn, "x-runtime")
    assert runtime |> Float.parse |> elem(0) >= 100 / 1_000
  end

  test "sets a runtime header using a custom name" do
    conn = conn(:get, "/") |> call(http_header: "x-custom")
    [runtime] = get_resp_header(conn, "x-custom")
    assert runtime |> Float.parse |> elem(0) >= 0
  end
end
