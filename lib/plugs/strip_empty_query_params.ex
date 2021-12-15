defmodule Solicit.Plugs.StripEmptyQueryParams do
  @moduledoc """
  Strips empty query string parameters.

  * `/api?test=1&foo=abc123` remains unchanged
  * `/api?test=&foo=` is equivalent `/api`
  * `/api?test=&foo=123` is equivalent to `/api?foo=123`
  """

  @doc false
  @spec init(keyword()) :: keyword()
  def init(opts \\ []), do: opts

  @doc false
  @spec call(Plug.Conn.t(), keyword()) :: Plug.Conn.t()
  def call(%Plug.Conn{query_params: query_params} = conn, _options) when query_params != %{} do
    filtered_params = filter_params(query_params)

    struct(conn,
      query_params: filtered_params,
      params: filtered_params |> Map.merge(conn.body_params) |> Map.merge(conn.path_params)
    )
  end

  def call(conn, _options), do: conn

  @doc """
  Given a map of query string parameters, keep only entries where the value is a list
  or a non-empty binary.

  ## Examples

      iex> Solicit.Plugs.StripEmptyQueryParams.filter_params(%{
      iex>   foo: "foo",
      iex>   bar: "",
      iex>   baz: :foo,
      iex>   qux: []
      iex> })
      %{foo: "foo", qux: []}
  """
  @spec filter_params(map()) :: map()
  def filter_params(query_params) do
    query_params
    |> Enum.filter(fn {_, value} ->
      (is_binary(value) && byte_size(value) > 0) || is_list(value)
    end)
    |> Enum.into(%{})
  end
end
