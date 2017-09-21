defmodule PlugMetrics.Mixfile do
  use Mix.Project

  def project do
    [
      app: :plug_metrics,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.0"},
      {:ecto, "~> 2.0"},
      {:postgrex, "~> 0.13", only: [:test]},
      {:credo, ">= 0.0.0", only: [:dev]},
      {:ex_doc, ">= 0.0.0", only: [:dev]}
    ]
  end

  defp description() do
    "Track metrics for your plug requests."
  end

  defp package() do
    [
      maintainers: ["Derek Schaefer"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/derek-schaefer/plug_metrics"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
