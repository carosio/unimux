[
  mappings: [
    "listen": [
      doc: """
      API endpoint in form of <protocol>://<host>[:<port>]

      Supported protocols are: zmq-tcp, zmq-tcp6, zmq-ipc, http

      It is possible to specify port as 0 or * to using only mdns registration
      """ ,
      to: "unimux.listen",
      datatype: :charlist,
      default: "http://127.0.0.1:20000"
    ],
    "route.*": [
      to: "unimux.routes",
      datatype: [:complex],
      default: []
    ],
    "route.*.pattern": [
      doc: "API prefix pattern",
      to: "unimux.routes",
      datatype: :binary,
      default: "APIPrefix"
    ],
    "route.*.target": [
      doc: "Route API endpoint in form of <protocol>://<host>[:<port>]",
      to: "unimux.routes",
      datatype: :string,
      default: "http://127.0.0.1:8080"
    ]
  ],
  translations: [
    "unimux.routes.*": fn _, {key, value_map}, acc ->
      [{value_map[:pattern], value_map[:target]} | acc]
    end,
    "listen": fn
      _, uri, acc ->
        try do
          :ex_uri.decode(uri)
          uri
        catch
          _, _ ->
            IO.puts("Unsupported URI format: #{uri}")
            exit(1)
        end
    end
  ]
]
