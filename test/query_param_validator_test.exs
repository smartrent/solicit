defmodule Solicit.Plugs.Validation.QueryParamTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest
  alias Solicit.Plugs.Validation.QueryParam

  describe "call" do
    test "query param is empty, expect error" do
      build_conn(:get, "?test=")
      |> Plug.Conn.fetch_query_params()
      |> QueryParam.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "query params all are empty, expect error" do
      build_conn(:get, "?test=&foo=&bar=")
      |> Plug.Conn.fetch_query_params()
      |> QueryParam.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "query params some are empty, expect error" do
      build_conn(:get, "?test=123&foo=&bar=")
      |> Plug.Conn.fetch_query_params()
      |> QueryParam.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "query param not empty" do
      conn = Plug.Conn.fetch_query_params(build_conn(:get, "?test=123"))
      assert conn == QueryParam.call(conn, %{})
    end

    test "query params not empty" do
      conn =
        Plug.Conn.fetch_query_params(build_conn(:get, "?test=123&foo=abc123&bar=somestringhere"))

      assert conn == QueryParam.call(conn, %{})
    end
  end
end
