defmodule Solicit.Plugs.Validation.PaginationParams do
  @moduledoc """
  Check to make sure for an endpoint that allows for pagination that both the `offset` and `page` query parameter
  cannot be provided in the same call. It can only be 1 or the other.

  Also that the provided `offset`, `page`, and `limit` are valid values
  """

  alias Plug.Conn
  alias Solicit.Response

  @spec init(keyword()) :: keyword()
  def init(opts \\ []), do: opts

  @spec call(Conn.t(), keyword()) :: Plug.Conn.t()
  def call(%{query_params: params} = conn, opts) do
    max_limit = get_max_limit(opts)
    offset = Map.get(params, "offset")
    page = Map.get(params, "page")
    limit = Map.get(params, "limit")

    if is_valid_limit_value?(limit, max_limit) do
      if pagination_params_valid?(offset, page) do
        conn
      else
        Response.unprocessable_entity(conn)
      end
    else
      struct(conn,
        query_params: Map.put(conn.query_params, "limit", max_limit),
        params: Map.put(conn.params, "limit", max_limit)
      )
    end
  end

  @spec pagination_params_valid?(any(), any()) :: boolean
  defp pagination_params_valid?(offset, page),
    do:
      (is_nil(offset) or is_nil(page)) and
        (is_valid_offset_value?(offset) and is_valid_page_value?(page))

  @spec is_valid_offset_value?(any) :: boolean()
  defp is_valid_offset_value?(offset_value) when not is_nil(offset_value) do
    case Integer.parse(offset_value) do
      {parsed_number, ""} ->
        parsed_number > -1

      :error ->
        false
    end
  end

  defp is_valid_offset_value?(_), do: true

  @spec is_valid_page_value?(any) :: boolean()
  defp is_valid_page_value?(page_value) when not is_nil(page_value) do
    case Integer.parse(page_value) do
      {parsed_number, ""} ->
        parsed_number > 0

      :error ->
        false
    end
  end

  defp is_valid_page_value?(_), do: true

  @spec is_valid_limit_value?(any(), pos_integer()) :: boolean()
  defp is_valid_limit_value?(limit, max_limit) when not is_nil(limit) do
    case Integer.parse(limit) do
      {parsed_number, ""} ->
        parsed_number <= max_limit and parsed_number > -1

      :error ->
        false
    end
  end

  defp is_valid_limit_value?(_, _), do: true

  @spec get_max_limit(keyword()) :: number()
  defp get_max_limit(opts),
       do: Keyword.get(opts, :max_limit, Application.get_env(:solicit, :pagination_max_limit, 1000))
end
