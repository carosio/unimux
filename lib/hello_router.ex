defmodule HelloRouter do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = for client <- Application.get_env(:hello_router, :routes, []) do
      {name, url} = client
      worker(:hello_client, [{:local, namespace(name)}, url, {[], [], []}], id: namespace(name))
    end
    listener_url = Application.get_env(:hello_router, :listener_url, 'zmq-tcp://0.0.0.0')
    :hello.start_service(__MODULE__, [])
    :hello.start_listener(listener_url, [], :hello_proto_jsonrpc, [], HelloRouter.Router)
    :hello.bind(listener_url, __MODULE__)
    opts = [strategy: :one_for_one, name: HelloRouter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def name(), do: Application.get_env(:hello_router, :name, "proxy/server")
  def router_key(), do: ""
  def validation(), do: __MODULE__
  def request(_, m, p), do: {:ok, m, p}

  def init(_identifier, _), do: {:ok, Application.get_env(:hello_router, :routes, [])}

  def handle_request(_context, method, args, state) do
    splittedMethod = method |> :hello_lib.to_binary |> String.split(".", [:global])
    name = Enum.join(List.delete_at(splittedMethod, length(splittedMethod) - 1), ".")
    case Application.get_env(:hello_router, :routes) |> List.keyfind(name, 0) do
      nil -> {:stop, :normal, {:ok, :not_found}, state}
      _ ->
        r = namespace(name) |> :hello_client.call({method, args, []})
        {:stop, :normal, r, state}
    end
  end

  def handle_info(_context, _message, state) do
    {:noreply, state}
  end

  def terminate(_context, _reason, _state) do
    :ok
  end

  def namespace(name) do
    String.to_atom("hello_client_" <> name)
  end
end


defmodule HelloRouter.Router do
  require Record
  Record.defrecordp(:context, Record.extract(:context, from_lib: "hello/include/hello.hrl"))

  def route(context(session_id: id), _request, _uri) do
    {:ok, HelloRouter.name(), id}
  end
end