use Mix.Config

config :logger, level: :info

config :plug_metrics,
  ecto_repos: [PlugMetrics.Repo]

config :plug_metrics, PlugMetrics.Repo,
  adapter: Ecto.Adapters.Postgres,
  hostname: "localhost",
  username: "postgres",
  password: "postgres",
  database: "plug_metrics_test",
  pool: Ecto.Adapters.SQL.Sandbox
