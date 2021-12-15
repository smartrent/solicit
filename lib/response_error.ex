defmodule Solicit.ResponseError.Generator do
  @moduledoc false

  defmacro __using__(opts \\ []) do
    status_codes = Keyword.get(opts, :status_codes, [])
    descriptions = Keyword.get(opts, :descriptions, %{})

    quote bind_quoted: [
            status_codes: status_codes,
            descriptions: descriptions,
            module: __MODULE__
          ] do
      @status_codes Enum.flat_map(status_codes, & &1)
      @descriptions descriptions
      @before_compile module
    end
  end

  defmacro __before_compile__(env) do
    status_codes = Module.get_attribute(env.module, :status_codes, [])
    descriptions = Module.get_attribute(env.module, :descriptions, %{})

    Enum.map(status_codes, fn status_code ->
      %{
        reason_atom: reason_atom,
        reason_phrase: reason_phrase,
        spec_title: spec_title,
        spec_href: spec_href,
        docs: docs
      } = Solicit.HTTP.StatusCodes.metadata(status_code)

      default_description = Map.get(descriptions, status_code, reason_phrase)

      quote do
        @doc """
        #{unquote(status_code)} #{unquote(reason_phrase)}

        #{unquote(docs)}

        * [#{unquote(spec_title)}](#{unquote(spec_href)})
        """
        @spec unquote(reason_atom)(String.t()) :: t()
        def unquote(reason_atom)(description \\ unquote(default_description)) do
          new(unquote(reason_atom), description)
        end
      end
    end)
  end
end

defmodule Solicit.ResponseError do
  @moduledoc """
  Represents an error in the JSON body of an HTTP response.

  Use `Solicit.ResponseError.new/3` to create an error with a custom code, description,
  and optional field.
  """

  use Solicit.ResponseError.Generator,
    status_codes: [400..418, 421..422, 429..429, 451..451, 500..504],
    descriptions: %{
      401 => "Must include valid Authorization credentials",
      405 => "Method is not allowed",
      409 => "A conflict has occurred",
      410 => "Access to resource is no longer available",
      413 => "Request entity is too large",
      415 => "Request contains an unsupported media type",
      422 => "Unable to process change",
      429 => "Exceeded request threshold"
    }

  @enforce_keys [:code, :description]
  defstruct code: "",
            description: "",
            field: nil

  @type code :: String.t() | atom()
  @type field :: String.t() | atom()
  @type description :: String.t()

  @type t :: %__MODULE__{
          code: code(),
          description: description(),
          field: field() | nil
        }

  @doc """
  Creates a new `Solicit.ResponseError` with the given code, description, and
  optional field.
  """
  def new(code \\ :error, description, field \\ nil) do
    %__MODULE__{code: code, description: description, field: field}
  end

  @spec generic_error(binary()) :: t()
  def generic_error(description \\ "An unknown error occurred."),
    do: new(description)

  @spec timeout(binary()) :: t()
  @deprecated "Use Solicit.ResponseError.request_timeout/1 or Solicit.ResponseError.gateway_timeout/1 instead."
  def timeout(description \\ "Timeout"),
    do: request_timeout(description)

  @doc """
  Converts the errors in an `Ecto.Changeset` with errors, convert the errors into
  a list of `Solicit.ResponseError` structs.
  """
  @spec from_changeset(Ecto.Changeset.t(), String.t() | nil) :: list(t())
  def from_changeset(%Ecto.Changeset{errors: errors} = c, field_prefix \\ nil) do
    # Attempt to get an ResponseError from a changeset errors keyword list entry
    # Remove all nils (failed ResponseError conversions) from the list
    errors
    |> Enum.map(&from_changeset_error/1)
    |> Enum.filter(& &1)
    |> Enum.concat(nested_errors(c))
    |> Enum.map(&prefix_field_name(&1, field_prefix))
  end

  @spec nested_errors(Ecto.Changeset.t()) :: list(t())
  defp nested_errors(%Ecto.Changeset{changes: changes}) do
    Enum.flat_map(changes, fn
      {key, %Ecto.Changeset{} = c} ->
        from_changeset(c, Atom.to_string(key))

      {key, changes} when is_list(changes) ->
        nested_errors(Atom.to_string(key), changes)

      _ ->
        []
    end)
  end

  @spec nested_errors(any(), list()) :: list(t())
  defp nested_errors(_, []), do: []

  defp nested_errors(key, changes) when is_binary(key) and is_list(changes) and changes != [] do
    length = length(changes)

    Enum.flat_map(0..(length - 1), fn index ->
      change = Enum.at(changes, index)

      case change do
        %Ecto.Changeset{} = c ->
          from_changeset(c, "#{key}.#{index}")

        _ ->
          []
      end
    end)
  end

  @spec prefix_field_name(t(), nil | String.t()) :: t()
  defp prefix_field_name(%__MODULE__{} = a, nil), do: a

  defp prefix_field_name(%__MODULE__{field: field} = a, prefix)
       when is_binary(field) and is_binary(prefix) do
    %{a | field: "#{prefix}.#{field}"}
  end

  # Given a keyword list entry, attempt to turn it into an ResponseError.
  # Assumption: all changeset errors are going to relate to a specific database field.
  @spec from_changeset_error(tuple()) :: t() | tuple()
  defp from_changeset_error({field, error}) do
    {code, description} = code_and_description(error)

    if code && description do
      field = if is_atom(field), do: Atom.to_string(field), else: field

      %__MODULE__{
        field: field,
        code: code,
        description: description
      }
    end
  end

  @spec code_and_description(tuple()) :: tuple()
  defp code_and_description({description, [error_code: error_code]}),
    do: {error_code, description}

  defp code_and_description({changeset_error, _}), do: {:unknown_error, changeset_error}
end

defimpl Jason.Encoder, for: Solicit.ResponseError do
  alias Solicit.ResponseError

  def encode(%ResponseError{} = error, opts) do
    take =
      case error do
        %{field: nil} -> ~w(code description)a
        _ -> ~w(field code description)a
      end

    error
    |> Map.take(take)
    |> Jason.Encode.map(opts)
  end
end
