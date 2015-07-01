UniMux [![Build Status](https://travis-ci.org/carosio/unimux.svg)](https://travis-ci.org/carosio/unimux)
======

UniMux applciation for routing [hello](https://github.com/travelping/hello)-based requests.

Minimal requirements are:

* erlang >= 17 (better 17.5)
* elixir >= 1.0 (1.1.0-dev)
* Apple Bonjour or a compatible API such as Avahi with it's compatibility layer along with the appropriate development files:
  * OS X - bundled
  * Windows - Bonjour SDK
  * BSD/Linux - search for Avahi in your operating systems software manager

If you install erlang on Ubuntu, install aditionally:

* erlang-parsetools
* erlang-eunit

Build an application:

    $> mix do deps.get, compile

Start an interactive shell with application:

    $> iex -S mix

Dev configuration is placed on `config/config.exs`

Release configuration is placed here: `unimux.conf`, but should not changed manuelly, instead change the schema: `unimux.schema.exs` and regenerate the configuration with:

    $> mix conform.configure

Build an test release locally:

    $> MIX_ENV=prod mix release

See more information about releases here: [exrm](https://github.com/bitwalker/exrm) and [relx](https://github.com/erlware/relx)

Build release on builder, which does download dependencies for you, use release enviroment, which overwrites the pathes to `deps/<app>`

    $> MIX_ENV=release mix release

Building the documentation:

    $> mix docs
