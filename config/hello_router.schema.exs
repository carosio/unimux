[
  mappings: [
    "api": [
      doc: """
      API endpoint in form of <protocol>://<host>[:<port>]

      Supported protocols are: zmq-tcp, zmq-tcp6, zmq-ipc, http

      It is possible to specify port as 0 or * to using only mdns registration
      """ ,
      to: "hello_router.api",
      datatype: :charlist,
      default: 'http://127.0.0.1:8080'
    ],
    "routes": [
      doc: """
      List with target API endpoints in form of APIPrefix-><protocol>://<host>[:<port>]

      Supported protocols are: zmq-tcp, zmq-tcp6, zmq-ipc, http
      
      """ ,
      to: "hello_router.routes",
      datatype: [list: :binary],
      default: "APIPrefix1->http://127.0.0.1:8090, APIPrefix2->http://127.0.0.1:8091"
    ]
  ],
  translations: [
    "routes": fn
      _, uri, acc ->
        Enum.map(uri, fn (x) -> 
          [name, target] = String.split(x, "->")
          {name, to_char_list(target)}
        end)
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