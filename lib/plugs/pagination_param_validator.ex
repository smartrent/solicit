defmodule Solicit.Plugs.PaginationParamValidator do
  @moduledoc """
  Check to make sure for an endpoint that allows for pagination that both the `offset` and `page` query parameter
  cannot be provided in the same call. It can only be 1 or the other.

  Also that the provided `offset`, `page`, and `limit` are valid values
  """

  alias Plug.Conn
  alias Solicit.Response

  @spec init(list()) :: list()
  def init(action), do: action

  @spec call(Conn.t(), any) :: Plug.Conn.t()
  def call(%{query_params: params} = conn, _params) do
    offset = Map.get(params, "offset")
    page = Map.get(params, "page")
    limit = Map.get(params, "limit")

    if pagination_params_valid?(offset, page, limit) do
      conn
    else
      Response.unprocessable_entity(conn)
    end
  end

  @spec pagination_params_valid?(any(), any(), any()) :: boolean
  defp pagination_params_valid?(offset, page, limit),
    do:
      (is_nil(offset) or is_nil(page)) and
        (is_valid_pagination_value?(offset) and is_valid_pagination_value?(page) and
           is_valid_pagination_value?(limit))

  @spec is_valid_pagination_value?(any) :: boolean()
  defp is_valid_pagination_value?(pagination_value) when not is_nil(pagination_value) do
    case Integer.parse(pagination_value) do
      {parsed_number, ""} ->
        parsed_number > 0

      :error ->
        false
    end
  end

  defp is_valid_pagination_value?(_), do: true
end
