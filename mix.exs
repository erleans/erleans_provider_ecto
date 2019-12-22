defmodule ErleansProviderEcto.MixProject do
  use Mix.Project

  def project do
    [
      app: :erleans_provider_ecto,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:postgrex, "~> 0.15.3"},
      {:ecto_sql, "~> 3.0"}
    ]
  end
end
