defmodule PlugMetrics.Repo do
  use Ecto.Repo, otp_app: :plug_metrics
  use PlugMetrics.Integrations.Ecto
end
