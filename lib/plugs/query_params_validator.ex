defmodule Solicit.Plugs.Validation.QueryParams do
  @moduledoc """
  Check to make sure that if a query parameter is provided that it has a value
    - /api?test=1&foo=abc123
    - /api?test=&foo= would be strip out the empty query params and be equiv to /api
    - /api?test=&foo=123 would be strip out the empty query params and be equiv to /api?foo=123
  """

  @spec init(keyword()) :: keyword()
  def init(opts \\ []), do: opts

  @spec call(Plug.Conn.t(), keyword()) :: Plug.Conn.t()
  def call(%Plug.Conn{query_params: query_params} = conn, _options) when query_params != %{} do
    filtered_params =
      Enum.reduce(query_params, %{}, fn {key, value}, acc ->
        if byte_size(value) > 0 do
          Map.put(acc, key, value)
        else
          acc
        end
      end)

    struct(conn,
      query_params: filtered_params,
      params: filtered_params |> Map.merge(conn.body_params) |> Map.merge(conn.path_params)
    )
  end

  def call(conn, _options), do: conn
end
