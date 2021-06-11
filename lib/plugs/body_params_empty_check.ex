defmodule Solicit.Plugs.Validation.BodyParamsEmpty do
  @moduledoc """
  Check all root level attributes for an empty value
  """

  alias Plug.Conn
  alias Solicit.Response

  @spec init(keyword()) :: keyword()
  def init(opts \\ []), do: opts

  @spec call(Conn.t(), keyword()) :: Plug.Conn.t()
  def call(%{body_params: body_params} = conn, _opts) do
    if Enum.any?(body_params, fn {_key, value} ->
         not is_nil(value) and not is_list(value) and byte_size(value) == 0
       end) do
      Response.unprocessable_entity(conn, [
        %{
          code: :no_empty_values,
          description: "Cannot provide empty value for an attribute",
          field: nil
        }
      ])
    else
      conn
    end
  end
end
