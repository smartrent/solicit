defmodule Solicit.Plugs.Static do
  @moduledoc """
  Creates a wrapper around Plug.Static to catch Invalid Path Errors.

  See Plug.Parsers documentation
  """
  alias Plug.Static

  def init(opts), do: Static.init(opts)

  def call(conn, opts) do
    Static.call(conn, opts)
  rescue
    _e in Static.InvalidPathError ->
      Solicit.Response.bad_request(conn, "Invalid path for static asset.")
  end
end
