defmodule Solicit.Plugs.Validation.QueryParamsTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest
  alias Solicit.Plugs.Validation.QueryParams

  describe "call" do
    test "query param is empty, expect to be stripped out" do
      %{params: %{}, query_params: %{}} =
        build_conn(:get, "?test=")
        |> Plug.Conn.fetch_query_params()
        |> QueryParams.call(%{})
    end

    test "query params all are empty, expect to be stripped out" do
      %{params: %{}, query_params: %{}} =
        build_conn(:get, "?test=&foo=&bar=")
        |> Plug.Conn.fetch_query_params()
        |> QueryParams.call(%{})
    end

    test "query params some are empty, expect empty params to be stripped out" do
      %{params: %{"foo" => "123"}, query_params: %{"foo" => "123"}} =
        build_conn(:get, "?test=&foo=123&bar=")
        |> Plug.Conn.fetch_query_params()
        |> QueryParams.call(%{})
    end

    test "query param not empty" do
      conn =
        build_conn(:get, "?test=123")
        |> Plug.Conn.fetch_query_params()
        |> struct(body_params: %{})

      assert conn == QueryParams.call(conn, %{})
    end

    test "query params not empty" do
      conn =
        build_conn(:get, "?test=123&foo=abc123&bar=somestringhere")
        |> Plug.Conn.fetch_query_params()
        |> struct(body_params: %{})

      assert conn == QueryParams.call(conn, %{})
    end

    test "query params is array - [] and has values" do
      conn =
        build_conn(:get, "?test[]=123&test[]=abc123")
        |> Plug.Conn.fetch_query_params()
        |> struct(body_params: %{})

      assert conn == QueryParams.call(conn, %{})
    end

    test "query params is array - [] and no values" do
      conn =
        build_conn(:get, "?test[]=&test[]=")
        |> Plug.Conn.fetch_query_params()
        |> struct(body_params: %{})

      assert conn == QueryParams.call(conn, %{})
    end

    test "query params is array - [] encoded and has a value" do
      conn =
        build_conn(:get, "?test=%5B1%5D")
        |> Plug.Conn.fetch_query_params()
        |> struct(body_params: %{})

      assert conn == QueryParams.call(conn, %{})
    end

    test "query params is array - [] encoded and no values" do
      conn =
        build_conn(:get, "?test=%5B%5D")
        |> Plug.Conn.fetch_query_params()
        |> struct(body_params: %{})

      assert conn == QueryParams.call(conn, %{})
    end

    test "query params is array - comma separated list" do
      conn =
        build_conn(:get, "?test=123,abc123")
        |> Plug.Conn.fetch_query_params()
        |> struct(body_params: %{})

      assert conn == QueryParams.call(conn, %{})
    end

    test "query params is nested object" do
      source_file = "../../../wp-config.php"
      params = %{"adaptive-images-settings" => %{"source_file" => source_file}}

      conn =
        build_conn(
          :get,
          "?adaptive-images-settings%5Bsource_file%5D=..%2F..%2F..%2Fwp-config.php"
        )
        |> Plug.Conn.fetch_query_params()
        |> struct(body_params: %{})

      assert %{
               params: ^params,
               query_params: ^params
             } = QueryParams.call(conn, %{})
    end

    test "no query params" do
      conn = Plug.Conn.fetch_query_params(build_conn())

      %{params: %{}, query_params: %{}} = QueryParams.call(conn, %{})
    end
  end
end
