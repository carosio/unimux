defmodule UniMux.Mixfile do
  use Mix.Project

  def project do
    [app: :unimux,
     version: "0.1.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger, :elixir, :hello, :runtime_tools, :exrun | (if Mix.env == :release do [:lager_journald_backend] else [] end)],
     mod: {UniMux, []}]
  end

  defp deps do
    [{:lager, "~> 2.1.1", override: true},
     {:hello, github: "travelping/hello", branch: "hello_v3"},
     {:exlager, github: "xerions/exlager"},
     {:exrun, github: "liveforeverx/exrun"},
     {:exrm, github: "thz/exrm", branch: "configurability", override: true}]
  end
end
