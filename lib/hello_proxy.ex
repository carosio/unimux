defmodule HelloProxy do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  use Application


  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = for client <- Application.get_env(:hello_proxy, :routes, []) do
      {name, url} = client
      worker(:hello_client, [{:local, namespace(name)}, url, {[], [], []}], id: namespace(name))
    end
    listener_url = Application.get_env(:hello_proxy, :listener_url, 'zmq-tcp://0.0.0.0')
    :hello.start_service(__MODULE__, [])
    :hello.start_listener(listener_url, [], :hello_proto_jsonrpc, [], HelloProxy.Router)
    :hello.bind(listener_url, __MODULE__)
    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloProxy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Hello service
  def name(), do: Application.get_env(:hello_proxy, :name, "proxy/server")
  def router_key(), do: ""
  def validation(), do: __MODULE__
  def request(_, m, p), do: {:ok, m, p}

  def init(_identifier, _), do: {:ok, Application.get_env(:hello_proxy, :routes, [])}

  def handle_request(_context, method, args, state) do
    method1 = :hello_lib.to_binary(method)
    splittedMethod = String.split(method1, ".", [:global])
    name = Enum.join(List.delete_at(splittedMethod, length(splittedMethod) - 1), ".")
    client = namespace(String.to_atom(name))
    case :erlang.whereis(client) do
      pid when is_pid(pid) ->
        r = :hello_client.call(client, {method, args, []})
        {:stop, :normal, r, state}
      _ ->
        {:stop, :normal, {:ok, :not_found}, state}
    end
  end

  def handle_info(_context, _message, state) do
    {:noreply, state}
  end

  def terminate(_context, _reason, _state) do
    :ok
  end

  def namespace(name) do
    List.to_atom('hello_client_' ++ Atom.to_char_list(name))
  end

  # for tests
  def run_client() do
    :hello_client.start({:local, __MODULE__}, 'zmq-tcp://proxy/server', [], [], [])
    :timer.sleep(1000)
  end

  def client() do
    :hello_client.call(__MODULE__, {"Test.try", [], []})
  end
end


defmodule HelloProxy.Router do
  require Record
  Record.defrecordp(:context, Record.extract(:context, from_lib: "hello/include/hello.hrl"))
  Record.defrecordp(:request, Record.extract(:request, from_lib: "hello/include/hello.hrl"))

  def route(context(session_id: id), request(method: _method), _uri) do
    {:ok, HelloProxy.name(), id}
  end
end
