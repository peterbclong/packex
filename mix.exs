defmodule Packex.Mixfile do
  use Mix.Project

  def project do
    [app: :packex,
     version: "0.1.0",
     elixir: "~> 1.5",
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {Packex.Application, []}]
  end

  defp deps do
    [{:uuid, "~> 1.1"},
     {:maru, "~> 0.12"},
     {:poison, "~> 3.1"},
     {:httpoison, "~> 0.13"}]
  end
end
