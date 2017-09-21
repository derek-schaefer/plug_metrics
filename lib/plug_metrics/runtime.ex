defmodule PlugMetrics.Runtime do
  @behaviour Plug

  alias Plug.Conn

  def init(options \\ []), do: options

  def call(conn, options, start \\ timestamp()) do
    Conn.register_before_send(conn, &put_runtime_header(&1, start, options))
  end

  defp put_runtime_header(conn, start, options) do
    Conn.put_resp_header(conn, header_name(options), runtime_seconds(start) |> Float.to_string)
  end

  defp runtime_seconds(start) do
    (timestamp() - start) / 1_000.0
  end

  defp header_name(options) do
    Keyword.get(options, :http_header, "x-runtime")
  end

  defp timestamp do
    :erlang.monotonic_time(:milli_seconds)
  end
end
