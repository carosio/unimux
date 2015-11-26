defmodule UniMux do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = for client <- Application.get_env(:unimux, :routes, []) do
      {name, url, timeout} = client
      worker(Hello.Client, [{:local, namespace(name)}, url, {[{:recv_timeout, timeout}], [], []}], id: namespace(name))
    end
    # Set hello server timeout to the maximum value of client's timeouts 
    # and add some  value for pretend errors
    timeouts = for {_, _, timeout} <- Application.get_env(:unimux, :routes, []), do: timeout
    Application.put_env(:hello, :server_timeout, Enum.max(timeouts ++ [10000]) + 500)
    listener_url = Application.get_env(:unimux, :listen, 'zmq-tcp://0.0.0.0')
    Hello.start_listener(listener_url, [], :hello_proto_jsonrpc, [], UniMux.Router)
    Hello.bind(listener_url, __MODULE__)
    opts = [strategy: :one_for_one, name: UniMux.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def name(), do: Application.get_env(:unimux, :name, "proxy/server")
  def router_key(), do: ""
  def validation(), do: __MODULE__
  def request(_, m, p), do: {:ok, m, p}

  def init(_identifier, _), do: {:ok, Application.get_env(:unimux, :routes, [])}

  def handle_request(_context, method, args, state) do
    case resolve(method) do
      nil -> {:stop, :not_found, {:ok, :not_found}, state}
      {name, timeout} ->
        r = Hello.Client.call(name, {method, args, []}, timeout)
        {:stop, :normal, r, state}
    end
  end

  def handle_info(_context, _message, state) do
    {:noreply, state}
  end

  def terminate(_context, _reason, _state) do
    :ok
  end

  defp resolve(method) do
    names = for client <- Application.get_env(:unimux, :routes, []), do: {elem(client, 0), elem(client, 2)}
    splittedMethod = method |> :hello_lib.to_binary |> String.split(".", [:global])
    resolve(splittedMethod, names)
  end
  
  defp resolve([], _), do: nil
  defp resolve(_, []), do: nil
  defp resolve(method, names) do
    name = Enum.join(method, ".")
    case :lists.keyfind(name, 1, names) do
      {name, timeout} -> {namespace(name), timeout}
      false -> List.delete_at(method, length(method) - 1) |>  resolve(names)
    end
  end

  defp namespace(name) do
    String.to_atom("hello_client_" <> name)
  end
end


defmodule UniMux.Router do
  require Record
  Record.defrecordp(:context, Record.extract(:context, from_lib: "hello/include/hello.hrl"))

  def route(context(session_id: id), _request, _uri) do
    {:ok, UniMux.name(), id}
  end
end
