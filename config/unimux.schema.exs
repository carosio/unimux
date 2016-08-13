[
  mappings: [
    "listen": [
      doc: """
      API endpoint in form of <protocol>://<host>[:<port>]

      Supported protocols are: zmq-tcp, zmq-tcp6, zmq-ipc, http
      """ ,
      to: "unimux.listen",
      datatype: :charlist,
      default: "http://127.0.0.1:20000"
    ],
    "default_timeout": [
      doc: "Default timeout for all routes in milliseconds",
      to: "unimux.default_timeout",
      datatype: :integer,
      default: 10000
    ],
    "route.$id.pattern": [
      doc: "API prefix pattern",
      to: "unimux.$id.pattern",
      datatype: :binary,
      default: "APIPrefix"
    ],
    "route.$id.target": [
      doc: "Route API endpoint in form of <protocol>://<host>[:<port>]",
      to: "unimux.$id.target",
      datatype: :charlist,
      default: "http://127.0.0.1:8080",
    ],
    "route.$id.timeout": [
      doc: "Timeout for the route in milliseconds",
      to: "unimux.$id.timeout",
      datatype: :integer,
      default: :undefined
    ]
  ],
  transforms: [
    "unimux.routes": fn table ->
      patterns = Conform.Conf.get(table, "unimux.$id.pattern")
      targets = Conform.Conf.get(table, "unimux.$id.target")
      timeouts = Conform.Conf.get(table, "unimux.$id.timeout")
      Enum.map(patterns, fn({[_, id, _], pattern}) ->
        :ets.delete(table, ['unimux', id, 'pattern'])
        target = case Conform.Conf.get(table, "unimux." <> to_string(id) <> ".target") do
                   [{_, target}] ->
                     :ets.delete(table, ['unimux', id, 'target'])
                     target
                   _ ->
                     "http://127.0.0.1:8080"
                 end
        timeout = case Conform.Conf.get(table, "unimux." <> to_string(id) <> ".timeout") do
                   [{_, timeout}] ->
                      :ets.delete(table, ['unimux', id, 'timeout'])
                      timeout
                   _ ->
                     :undefined
                 end        
        [{pattern, target, timeout}]
      end)
    end,
    "listen": fn table ->
      [{_, uri}] = Conform.Conf.get(table, "unimux.listen")
      case :ex_uri.decode(uri) do
          {:error, :invalid_uri} ->
            IO.puts("#{IO.ANSI.red}Unsupported URI format for 'listen' (API endpoint) option: #{uri}#{IO.ANSI.reset}")
            exit("Unsupported URI format for 'listen' (API endpoint) option: #{uri}")
          _ ->
            uri
        end
    end
  ]
]
