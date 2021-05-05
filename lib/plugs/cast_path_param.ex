defmodule Solicit.Plugs.CastPathParam do
  @moduledoc """
  Casts the given path param to the given type. If the cast fails, returns a 404.
  """

  @typedoc """
  Plug options.

  - `:param` - the string name of the parameter to be cast. *Required.*
  - `:type` - the type to cast to using `Ecto.Type.cast/2`. *Required.*
  - `:required` - if false, allows the parameter to be nil or an empty string after casting. *Default:* `true`.
  - `:overwrite` - if false, does not update `conn.path_params` or `conn.params`. Allows the plug to be used only for validation. *Default:* `true`.
  """
  @type options :: [
          param: binary(),
          type: Ecto.Type.t(),
          required: boolean(),
          overwrite: boolean()
        ]

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

  @spec call(Plug.Conn.t(), keyword) :: Plug.Conn.t()
  def call(conn, opts) do
    param_name = Keyword.get(opts, :param)
    type = Keyword.get(opts, :type)
    required = Keyword.get(opts, :required, true)
    overwrite = Keyword.get(opts, :overwrite, true)

    value = Map.get(conn.path_params, param_name)

    case Ecto.Type.cast(type, value) do
      {:ok, cast_value} ->
        cond do
          # return a 404
          required && (is_nil(cast_value) || cast_value == "") ->
            Solicit.Response.not_found(conn)

          # pass the request but do not update the values in conn
          not overwrite ->
            conn

          # update the value in conn.path_params and conn.params
          true ->
            struct(conn,
              path_params: Map.put(conn.path_params, param_name, cast_value),
              params: Map.put(conn.params, param_name, cast_value)
            )
        end

      :error ->
        Solicit.Response.not_found(conn)
    end
  end
end
