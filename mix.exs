defmodule UniMux.Mixfile do
  use Mix.Project

  def project do
    [app: :unimux,
     version: "1.2.11",
     elixir: "~> 1.3.0",
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
    [{:lager, "~> 3.2.1", override: true},
     {:goldrush, github: "DeadZen/goldrush", tag: "0.1.6", override: true},
     {:hello, github: "travelping/hello", branch: "master"},
     {:hackney, "~> 1.4.4", override: true},
     {:metricman, github: "xerions/metricman"},
     {:exlager, github: "xerions/exlager"},
     {:exrun, github: "liveforeverx/exrun"},
     {:conform_exrm, github: "bitwalker/conform_exrm"},
     {:conform, "~> 2.1.1"},
     {:exrm, github: "bitwalker/exrm", override: true},
     {:coverex, github: "alfert/coverex", tag: "v1.4.3", only: :test},
     {:meck, github: "eproxus/meck", tag: "0.8.3", override: true},
		 {:exometer_core, github: "Feuerlabs/exometer_core", override: true},
     {:erlware_commons, "~> 0.21.0", override: true},
     {:edown, github: "uwiger/edown", override: true},
     {:setup, github: "uwiger/setup", override: true},
     {:mock, github: "jjh42/mock"}]
  end
end
