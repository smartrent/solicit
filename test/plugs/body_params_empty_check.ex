defmodule Solicit.Plugs.Validation.BodyParamsEmptyTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest
  alias Solicit.Plugs.Validation.BodyParamsEmpty

  describe "call" do
    test "Nil value provided returns connection" do
      conn = build_conn(:post, "/api/v1/users", %{somevalue: nil})
      assert %{status: nil} = BodyParamsEmpty.call(conn, %{})
    end

    test "Empty array value provided returns connection" do
      conn = build_conn(:post, "/api/v1/users", %{somevalue: []})
      assert %{status: nil} = BodyParamsEmpty.call(conn, %{})
    end

    test "Empty value provided returns error" do
      build_conn(:post, "/api/v1/users", %{somevalue: ""})
      |> BodyParamsEmpty.call(%{})
      |> json_response(:unprocessable_entity)
    end

    test "Multiple values where one is empty value provided returns error" do
      build_conn(:post, "/api/v1/users", %{somevalue: "test", someothervalue: ""})
      |> BodyParamsEmpty.call(%{})
      |> json_response(:unprocessable_entity)
    end
  end
end
