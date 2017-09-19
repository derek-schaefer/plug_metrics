defmodule PlugMetrics.Runtime do
  @behaviour Plug

  alias Plug.Conn

  def init(options \\ []) do
    options
  end

  def call(conn, options) do
    conn
    |> Conn.assign(:runtime, %{timestamp: timestamp()})
    |> Conn.register_before_send(&put_runtime_header(&1, options))
  end

  defp put_runtime_header(conn, options) do
    Conn.put_resp_header(conn, runtime_header(options), runtime_value(conn) |> Float.to_string)
  end

  defp runtime_value(conn) do
    (timestamp() - conn.assigns[:runtime][:timestamp]) / 1_000.0
  end

  defp runtime_header(options) do
    header_name(options)
  end

  defp header_name(options) do
    Keyword.get(options, :http_header, "x-runtime")
  end

  defp timestamp do
    :erlang.monotonic_time(:milli_seconds)
  end
end
