defmodule Solicit.Plugs.StaticTest do
  use ExUnit.Case, async: true

  import Phoenix.ConnTest

  alias Solicit.Plugs.Static

  @default_opts %{
    at: [],
    from: {:solicit, "priv/static"},
    gzip?: false,
    brotli?: false,
    only_rules: {~w(css fonts images js favicon.ico robots.txt), []}
  }

  test "Throws :bad_request is path is invalid" do
    build_conn(:get, "/")
    |> struct(path_info: ["images", "%20%0d%0a%3Csvg%2fonload%3dalert%281%29%0d%0a%0d%0a"])
    |> Static.call(@default_opts)
    |> json_response(:bad_request)
  end

  test "Does not throw an error if path is valid" do
    conn =
      build_conn(:get, "/")
      |> struct(path_info: [])
      |> Static.call(@default_opts)

    assert conn.path_info == []
  end
end
