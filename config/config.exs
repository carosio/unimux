# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :hello_router,
  routes: [{"Test", 'zmq-tcp://app/test'}],
  listener_url: 'zmq-tcp://0.0.0.0'