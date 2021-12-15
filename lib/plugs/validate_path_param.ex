defmodule Solicit.Plugs.ValidatePathParam do
  @moduledoc """
  Casts the given path param to the given type. If the cast fails, returns a 404.
  Uses Solicit for 404 responses, so only API routes are supported.

  ## Usage

  ```
  plug Solicit.Plugs.ValidatePathParam,
       param: "user_id",
       type: :integer,
       required: true
  ```

  ### Options

  * `:param` - the string name of the parameter to be cast. **Required.**
  * `:type` - the type to cast to using `Ecto.Type.cast/2`. **Required.**
  * `:required` - if true, requires the parameter to not be nil or an empty string after
    casting. **Default:** `true`.
  """

  @typedoc "Plug options."
  @type options :: [
          param: binary(),
          type: Ecto.Type.t(),
          required: boolean()
        ]

  @doc false
  @spec init(keyword()) :: keyword()
  def init(opts) do
    unless is_binary(Keyword.get(opts, :param)) do
      raise ":param is required and must be a string"
    end

    unless Keyword.has_key?(opts, :type) do
      raise ":type is required"
    end

    opts
  end

  @doc false
  @spec call(Plug.Conn.t(), keyword) :: Plug.Conn.t()
  def call(conn, opts) do
    param_name = Keyword.get(opts, :param)
    type = Keyword.get(opts, :type)
    required = Keyword.get(opts, :required, true)

    value = Map.get(conn.path_params, param_name)

    case Ecto.Type.cast(type, value) do
      {:ok, cast_value} ->
        if required && (is_nil(cast_value) || cast_value == "") do
          Solicit.Response.not_found(conn)
        else
          # don't update conn because changing path_params breaks spandex_phoenix
          conn
        end

      :error ->
        Solicit.Response.not_found(conn)
    end
  end
end
