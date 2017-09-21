defmodule PlugMetrics.Runtime do
  @behaviour Plug

  alias Plug.Conn

  def init(options \\ []), do: options

  def call(conn, options, timestamp \\ timestamp()) do
    Conn.register_before_send(conn, &put_runtime_header(&1, timestamp, options))
  end

  defp put_runtime_header(conn, timestamp, options) do
    Conn.put_resp_header(conn, header_name(options), runtime_value(timestamp) |> Float.to_string)
  end

  defp runtime_value(timestamp) do
    (timestamp() - timestamp) / 1_000.0
  end

  defp header_name(options) do
    Keyword.get(options, :http_header, "x-runtime")
  end

  defp timestamp do
    :erlang.monotonic_time(:milli_seconds)
  end
end
