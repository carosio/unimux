defmodule UniMuxTest do
  use ExUnit.Case

  import Mock
  
  require Record
  Record.defrecordp(:context, Record.extract(:context, from_lib: "hello/include/hello.hrl"))

  setup do
    on_exit fn -> 
      Application.put_env(:unimux, :routes, [])
    end
  end

  test "handle request - not found" do
    state = []
    assert {:stop, :not_found, {:ok, :not_found}, state} == UniMux.handle_request(:context, "a.b.c", [], state)
  end

  test_with_mock "handle request - ok", :hello_client, [call: fn(name, _, timeout) -> {:ok, name, timeout} end] do
    state = []
    Application.put_env(:unimux, :routes, [{"a", 'http://127.0.0.1:8080', 10000}])
    assert UniMux.handle_request(:context, "a.b.c", [], state) == {:stop, :normal, {:ok, :hello_client_a, 10000}, state}  

    Application.put_env(:unimux, :routes, [{"a", 'http://127.0.0.1:8080', 10000}, {"a.b", "http://127.0.0.1:8081", 20000}])
    assert UniMux.handle_request(:context, "a.b.c", [], state) == {:stop, :normal, {:ok, :"hello_client_a.b", 20000}, state}
  end

  test "router" do
    id = 1
    assert {:ok, UniMux.name(), id} == UniMux.Router.route(context(session_id: id), :req, :uri)
  end

  test "server_timeout" do
    assert 10500 == Application.get_env(:hello, :server_timeout)
  end
end
