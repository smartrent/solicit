defmodule Solicit.Plugs.PaginationParamValidatorTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest
  alias Solicit.Plugs.PaginationParamValidator

  describe "call" do
    test "offset and page provided, expect error" do
      build_conn(:get, "?offset=1&page=1")
    |> Plug.Conn.fetch_query_params()
      |> PaginationParamValidator.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "offset provided not a number, expect error" do
      build_conn(:get, "?offset=abc123")
      |> Plug.Conn.fetch_query_params()
      |> PaginationParamValidator.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "page provided not a number, expect error" do
      build_conn(:get, "?page=abc123")
      |> Plug.Conn.fetch_query_params()
      |> PaginationParamValidator.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "limit provided not a number, expect error" do
      build_conn(:get, "?limit=abc123")
      |> Plug.Conn.fetch_query_params()
      |> PaginationParamValidator.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "offset provided but empty, expect error" do
      build_conn(:get, "?offset=")
      |> Plug.Conn.fetch_query_params()
      |> PaginationParamValidator.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "page provided but empty, expect error" do
      build_conn(:get, "?page=")
      |> Plug.Conn.fetch_query_params()
      |> PaginationParamValidator.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "limit provided but empty, expect error" do
      build_conn(:get, "?limit=")
      |> Plug.Conn.fetch_query_params()
      |> PaginationParamValidator.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "offset provided but negative number, expect error" do
      build_conn(:get, "?offset=-1")
      |> Plug.Conn.fetch_query_params()
      |> PaginationParamValidator.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "page provided but negative number, expect error" do
      build_conn(:get, "?page=-1")
      |> Plug.Conn.fetch_query_params()
      |> PaginationParamValidator.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "limit provided but negative number, expect error" do
      build_conn(:get, "?limit=-1")
      |> Plug.Conn.fetch_query_params()
      |> PaginationParamValidator.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "offset provided" do
      conn = Plug.Conn.fetch_query_params(build_conn(:get, "?offset=1"))
      assert conn == PaginationParamValidator.call(conn, %{})
    end

    test "page provided" do
      conn = Plug.Conn.fetch_query_params(build_conn(:get, "?page=1"))
      assert conn == PaginationParamValidator.call(conn, %{})
    end

    test "offset and limit provided" do
      conn = Plug.Conn.fetch_query_params(build_conn(:get, "?offset=1&limit=1"))
      assert conn == PaginationParamValidator.call(conn, %{})
    end

    test "page and limit provided" do
      conn = Plug.Conn.fetch_query_params(build_conn(:get, "?page=1&limit=1"))
      assert conn == PaginationParamValidator.call(conn, %{})
    end
  end
end
