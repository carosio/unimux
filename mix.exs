defmodule HelloProxy.Mixfile do
  use Mix.Project

  def project do
    [app: :hello_proxy,
     version: "0.0.1",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :elixir, :hello],
     mod: {HelloProxy, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:lager, "~> 2.1.1", override: true},
     {:jsx, github: "talentdeficit/jsx", branch: "develop", override: true},
     {:hello, git: "https://github.com/travelping/hello", branch: "hello_v3"}]
  end
end
