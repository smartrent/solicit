defmodule Solicit.Plugs.QueryParamValidator do
  @moduledoc """
  Check to make sure that if a query parameter is provided that it has a value

  valid example
    - /api?test=1&foo=abc123

  invalid example
    - /api?test=&foo=

  """

  alias Solicit.Response

  @spec init(list()) :: list()
  def init(action), do: action

  @spec call(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def call(%Plug.Conn{query_params: query_params} = conn, _options) when query_params != %{} do
    if Enum.any?(query_params, fn {_key, value} -> byte_size(value) == 0 end) do
      Response.bad_request(conn)
    else
      conn
    end
  end

  def call(conn, _options), do: conn
end
