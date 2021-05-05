defmodule Solicit.Plugs.CastPathParamTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest

  alias Solicit.Plugs.CastPathParam

  test "it allows requests with valid params" do
    conn =
      build_conn(:get, "/")
      |> struct(path_params: %{"foo" => "1"})
      |> CastPathParam.call(param: "foo", type: :integer)

    assert conn.path_params["foo"] == 1
  end

  test "it returns a 404 when path params are invalid" do
    build_conn(:get, "/")
    |> struct(path_params: %{"foo" => "bar"})
    |> CastPathParam.call(param: "foo", type: :integer)
    |> json_response(:not_found)
  end

  test "it does not update conn.params or conn.path_params when overwrite is false" do
    conn =
      build_conn(:get, "/")
      |> struct(path_params: %{"foo" => "1"})
      |> CastPathParam.call(param: "foo", type: :integer, overwrite: false)

    assert conn.path_params["foo"] == "1"
  end

  test "it allows nil and empty string when required is false" do
    conn =
      CastPathParam.call(build_conn(:get, "/"), param: "foo", type: :integer, required: false)

    assert conn.path_params["foo"] == nil

    conn =
      build_conn(:get, "/")
      |> struct(path_params: %{"foo" => ""})
      |> CastPathParam.call(param: "foo", type: :integer, required: false)

    assert conn.path_params["foo"] == ""

    build_conn(:get, "/")
    |> struct(path_params: %{"foo" => "asdf"})
    |> CastPathParam.call(param: "foo", type: :integer, required: false)
    |> json_response(:not_found)
  end

  test "handles non-primitive types" do
    valid_uuid = Ecto.UUID.generate()

    conn =
      build_conn(:get, "/")
      |> struct(path_params: %{"uuid" => valid_uuid})
      |> CastPathParam.call(param: "uuid", type: Ecto.UUID)

    assert conn.path_params["uuid"] == valid_uuid

    build_conn(:get, "/")
    |> struct(path_params: %{"uuid" => "asdf"})
    |> CastPathParam.call(param: "uuid", type: Ecto.UUID)
    |> json_response(:not_found)
  end
end
