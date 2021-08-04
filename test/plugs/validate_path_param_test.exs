defmodule Solicit.Plugs.ValidatePathParamTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Solicit.Plugs.ValidatePathParam

  defmodule TestRouter do
    use Plug.Router

    plug(:match)
    plug(:dispatch)

    get("/foo/:foo", to: ValidatePathParam, init_opts: [param: "foo", type: :integer])

    get("/bar/*_rest",
      to: ValidatePathParam,
      init_opts: [param: "bar", type: :integer, required: false]
    )

    get("/uuid/:uuid", to: ValidatePathParam, init_opts: [param: "uuid", type: Ecto.UUID])
  end

  @opts TestRouter.init([])

  test "it allows requests with valid params" do
    conn = :get |> conn("/foo/1") |> TestRouter.call(@opts)

    assert conn.path_params["foo"] == "1"
    assert conn.params["foo"] == "1"
    assert conn.status == nil
  end

  test "it returns a 404 when path params are invalid" do
    conn = :get |> conn("/foo/bar") |> TestRouter.call(@opts)
    assert conn.status == 404
  end

  test "it does not 404 when optional params are missing" do
    conn = :get |> conn("/bar/1") |> TestRouter.call(@opts)

    assert conn.path_params["bar"] == nil
    assert conn.status == nil
  end

  test "handles non-primitive types" do
    valid_uuid = Ecto.UUID.generate()

    conn = :get |> conn("/uuid/#{valid_uuid}") |> TestRouter.call(@opts)

    assert conn.path_params["uuid"] == valid_uuid
    assert conn.status == nil

    conn = :get |> conn("/uuid/asdf") |> TestRouter.call(@opts)
    assert conn.status == 404
  end
end
