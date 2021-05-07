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
      conn = Plug.Conn.fetch_query_params(build_conn(:get, "?test=123"))
      assert conn == QueryParams.call(conn, %{})
    end

    test "query params not empty" do
      conn =
        Plug.Conn.fetch_query_params(build_conn(:get, "?test=123&foo=abc123&bar=somestringhere"))

      assert conn == QueryParams.call(conn, %{})
    end

    test "no query params" do
      conn = Plug.Conn.fetch_query_params(build_conn())

      %{params: %{}, query_params: %{}} = QueryParams.call(conn, %{})
    end
  end
end
