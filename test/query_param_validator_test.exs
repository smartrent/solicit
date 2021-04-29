defmodule Solicit.Plugs.QueryParamValidatorTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest
  alias Solicit.Plugs.QueryParamValidator

  describe "call" do
    test "query param is empty, expect error" do
      build_conn(:get, "?test=")
      |> Plug.Conn.fetch_query_params()
      |> QueryParamValidator.call(%{})
      |> json_response(:bad_request)
    end

    test "query params all are empty, expect error" do
      build_conn(:get, "?test=&foo=&bar=")
      |> Plug.Conn.fetch_query_params()
      |> QueryParamValidator.call(%{})
      |> json_response(:bad_request)
    end

    test "query params some are empty, expect error" do
      build_conn(:get, "?test=123&foo=&bar=")
      |> Plug.Conn.fetch_query_params()
      |> QueryParamValidator.call(%{})
      |> json_response(:bad_request)
    end

    test "query param not empty" do
      conn = Plug.Conn.fetch_query_params(build_conn(:get, "?test=123"))
      assert conn == QueryParamValidator.call(conn, %{})
    end

    test "query params not empty" do
      conn =
        Plug.Conn.fetch_query_params(build_conn(:get, "?test=123&foo=abc123&bar=somestringhere"))

      assert conn == QueryParamValidator.call(conn, %{})
    end
  end
end
