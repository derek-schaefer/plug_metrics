defmodule PlugMetrics.RuntimeTest do
  use ExUnit.Case
  use Plug.Test

  alias PlugMetrics.Runtime

  defp call(conn, options \\ []) do
    Runtime.call(conn, Runtime.init(options))
  end

  defp call_fast(conn, options \\ []) do
    call(conn, options) |> response
  end

  defp call_slow(conn) do
    conn = call(conn)

    :timer.sleep(100)

    response(conn)
  end

  defp response(conn) do
    send_resp(conn, 200, "Hello, world!")
  end

  test "sets the runtime header for the fast action" do
    conn = conn(:get, "/") |> call_fast

    [runtime] = get_resp_header(conn, "x-runtime")

    assert runtime |> Float.parse |> elem(0) >= 0
  end

  test "sets the runtime header for the slow action" do
    conn = conn(:get, "/") |> call_slow

    [runtime] = get_resp_header(conn, "x-runtime")

    assert runtime |> Float.parse |> elem(0) >= 100 / 1_000
  end

  test "sets the runtime header using a custom name" do
    conn = conn(:get, "/") |> call_fast(http_header: "x-custom")

    [runtime] = get_resp_header(conn, "x-custom")

    assert runtime |> Float.parse |> elem(0) >= 0
  end
end
