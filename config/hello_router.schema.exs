[
  mappings: [
    "api": [
      doc: """
      API endpoint in form of <protocol>://<host>[:<port>]

      Supported protocols are: zmq-tcp, zmq-tcp6, zmq-ipc, http

      It is possible to specify port as 0 or * to using only mdns registration
      """ ,
      to: "hello_router.listen_url",
      datatype: :charlist,
      default: 'http://127.0.0.1:8080'
    ],
    "route.*": [
      doc: """
      List with target API endpoints in form of APIPrefix-><protocol>://<host>[:<port>]

      Supported protocols are: zmq-tcp, zmq-tcp6, zmq-ipc, http
      
      """ ,
      to: "hello_router.routes",
      datatype: [:complex],
      default: []
    ],
    "route.*.pattern": [
      to: "hello_router.routes",
      datatype: :binary,
      default: ""
    ],
    "route.*.target": [
      to: "hello_router.routes",
      datatype: :string,
      default: ""
    ]
  ],
  translations: [
    "hello_router.routes.*": fn _, {key, value_map}, acc ->
      [{value_map[:pattern], value_map[:target]} | acc]
    end,
    "api": fn
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
