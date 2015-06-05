# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config


config :hello_router,
  routes: [{"APIPrefix1", 'http://127.0.0.1:8090'}],
  listener_url: 'zmq-tcp://127.0.0.1:8080'