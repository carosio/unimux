defmodule HelloRouter.Mixfile do
  use Mix.Project

  def project do
    [app: :hello_router,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :elixir, :hello],
     mod: {HelloRouter, []}]
  end

  defp deps do
    [{:lager, "~> 2.1.1", override: true},
     {:jsx, github: "talentdeficit/jsx", branch: "develop", override: true},
     {:hello, github: "travelping/hello", branch: "hello_v3"},
     {:exrm, github: "xerions/exrm", branch: "forward"}]
  end
end
