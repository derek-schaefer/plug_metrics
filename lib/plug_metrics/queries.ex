defmodule PlugMetrics.Queries do
  @behaviour Plug

  require Logger

  alias Plug.Conn
  alias PlugMetrics.{MetricsClient, Metric, QueryPayload}

  def init(options \\ []), do: options

  def call(conn, options) do
    :ok = MetricsClient.register(options)

    Conn.register_before_send(conn, &put_runtime_headers(&1, options))
  end

  defp put_runtime_headers(conn, options) do
    queries = query_metrics(options)
    queries_count = Enum.count(queries)

    queue_time = total_seconds(queries, & &1.queue_time)
    query_time = total_seconds(queries, & &1.query_time)
    decode_time = total_seconds(queries, & &1.decode_time)
    total_time = queue_time + query_time + decode_time

    queries_count_value = Integer.to_string(queries_count)
    queue_time_value = average_time(queue_time, queries_count) |> Float.to_string
    query_time_value = average_time(query_time, queries_count) |> Float.to_string
    decode_time_value = average_time(decode_time, queries_count) |> Float.to_string
    total_time_value = Float.to_string(total_time)

    prefix = header_name(options)

    conn
    |> Conn.put_resp_header(prefix <> "-count", queries_count_value)
    |> Conn.put_resp_header(prefix <> "-queue-time", queue_time_value)
    |> Conn.put_resp_header(prefix <> "-query-time", query_time_value)
    |> Conn.put_resp_header(prefix <> "-decode-time", decode_time_value)
    |> Conn.put_resp_header(prefix <> "-total-time", total_time_value)
  end

  defp query_metrics(options) do
    options
    |> MetricsClient.pop
    |> Enum.filter(&match?(%Metric{payload: %QueryPayload{}}, &1))
    |> Enum.map(& &1.payload)
  end

  defp total_seconds(collection, f) do
    collection
    |> Enum.map(f)
    |> Enum.reject(&is_nil(&1))
    |> Enum.sum
    |> native_time_to_seconds
  end

  defp native_time_to_seconds(time) do
    System.convert_time_unit(time, :native, :millisecond) / 1_000.0
  end

  defp header_name(options) do
    Keyword.get(options, :http_header, "x-queries")
  end

  defp average_time(_, 0), do: 0.0
  defp average_time(total, count), do: total / count
end
