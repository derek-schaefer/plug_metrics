defmodule PlugMetrics.RuntimeTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias PlugMetrics.Runtime

  defmodule TestRouter do
    use Plug.Router

    plug Runtime
    plug :match
    plug :dispatch

    get "/fast" do
      action(conn)
    end

    get "/slow" do
      :timer.sleep(100)
      action(conn)
    end

    defp action(conn) do
      send_resp(conn, 200, "Hello, world!")
    end
  end

  defp call_test_router(conn) do
    TestRouter.call(conn, [])
  end

  defp call(conn, options) do
    conn
    |> Runtime.call(Runtime.init(options))
    |> send_resp(200, "Hello, world!")
  end

  test "sets a runtime header for the fast action" do
    conn = conn(:get, "/fast") |> call_test_router
    [runtime] = get_resp_header(conn, "x-runtime")
    assert runtime |> Float.parse |> elem(0) >= 0
  end

  test "sets a runtime header for the slow action" do
    conn = conn(:get, "/slow") |> call_test_router
    [runtime] = get_resp_header(conn, "x-runtime")
    assert runtime |> Float.parse |> elem(0) >= 100 / 1_000
  end

  test "sets a runtime header using a custom name" do
    conn = conn(:get, "/") |> call(http_header: "x-custom")
    [runtime] = get_resp_header(conn, "x-custom")
    assert runtime |> Float.parse |> elem(0) >= 0
  end
end
