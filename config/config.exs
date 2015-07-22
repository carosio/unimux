# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config


config :unimux,
  routes: [{"APIPrefix", 'http://127.0.0.1:8080'}],
  listen: 'zmq-tcp://127.0.0.1:20000'

metricman_config = "deps/metricman/config/config.exs"
if File.exists? metricman_config do
  import_config "../" <> metricman_config
end
