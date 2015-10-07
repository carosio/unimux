defmodule UniMux.Mixfile do
  use Mix.Project

  def project do
    [app: :unimux,
     version: "0.2.4",
     elixir: "~> 1.0",
     test_coverage: [tool: Coverex.Task, coveralls: true],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(Mix.env)]
  end

  def application do
    [applications: [:logger, :elixir, :metricman, :hello, :runtime_tools, :exrun | (if Mix.env == :release do [:lager_journald_backend] else [] end)],
     mod: {UniMux, []}]
  end

  @exclude_deps [:earmark, :ex_doc]
  defp deps(:release) do
    Code.eval_file("mix.lock")
    |> elem(0)
    |> Enum.filter_map(&(not (elem(&1, 0) in @exclude_deps)), fn({key, _}) -> {key, path: "deps/" <> "#{key}", override: true} end)
  end

  defp deps(_) do
    [{:lager, "~> 2.1.1", override: true},
     {:hello, github: "travelping/hello", branch: "master"},
     {:metricman, github: "xerions/metricman", branch: "master"}, 
     {:exlager, github: "xerions/exlager"},
     {:exrun, github: "liveforeverx/exrun"},
     {:exrm, github: "xerions/exrm", override: true},
     {:coverex, github: "alfert/coverex", tag: "v1.4.3", only: :test},
     {:meck, github: "eproxus/meck", tag: "0.8.3", override: true},
     {:mock, github: "jjh42/mock"}]
  end
end
