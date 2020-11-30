defmodule Solicit.ResponseError do
  @moduledoc """
  An error in the JSON body of an HTTP response.
  """

  alias Ecto.Changeset
  alias __MODULE__

  defstruct code: "",
            description: "",
            field: nil

  @type t :: %__MODULE__{}

  @spec generic_error :: ResponseError.t()
  def generic_error, do: %ResponseError{code: :error, description: "An unknown error occurred."}

  @spec bad_request :: ResponseError.t()
  def bad_request, do: %ResponseError{code: :bad_request, description: "Bad request."}

  @spec forbidden :: ResponseError.t()
  def forbidden, do: %ResponseError{code: :forbidden, description: "This action is forbidden."}

  @spec not_found :: ResponseError.t()
  def not_found, do: %ResponseError{code: :not_found, description: "The resource was not found."}

  @spec unprocessable_entity :: ResponseError.t()
  def unprocessable_entity,
    do: %ResponseError{code: :unprocessable_entity, description: "Unable to process change."}

  @spec conflict(binary()) :: ResponseError.t()
  def conflict(description) when is_binary(description),
    do: %ResponseError{code: :conflict, description: description}

  @spec unauthorized :: ResponseError.t()
  def unauthorized,
    do: %ResponseError{
      code: :unauthorized,
      description: "Must include valid Authorization credentials"
    }

  @doc """
  Given an Ecto Changeset with errors, convert the errors into a list of ResponseError objects.
  """
  @spec from_changeset(Changeset.t(), String.t() | nil) :: list(ResponseError.t())
  def from_changeset(%Changeset{errors: errors} = c, field_prefix \\ nil) do
    # Attempt to get an ResponseError from a changeset errors keyword list entry
    # Remove all nils (failed ResponseError conversions) from the list
    errors
    |> Enum.map(&from_changeset_error/1)
    |> Enum.filter(& &1)
    |> Enum.concat(nested_errors(c))
    |> Enum.map(&prefix_field_name(&1, field_prefix))
  end

  @spec nested_errors(Ecto.Changeset.t()) :: list(ResponseError.t())
  defp nested_errors(%Changeset{changes: changes}) do
    Enum.flat_map(changes, fn
      {key, %Changeset{} = c} ->
        from_changeset(c, Atom.to_string(key))

      {key, changes} when is_list(changes) ->
        nested_errors(Atom.to_string(key), changes)

      _ ->
        []
    end)
  end

  @spec nested_errors(any(), list()) :: list(ResponseError.t())
  defp nested_errors(_, []), do: []

  defp nested_errors(key, changes)
       when is_binary(key) and is_list(changes) and length(changes) > 0 do
    length = length(changes)

    Enum.flat_map(0..(length - 1), fn index ->
      change = Enum.at(changes, index)

      case change do
        %Changeset{} = c ->
          from_changeset(c, "#{key}.#{index}")

        _ ->
          []
      end
    end)
  end

  @spec prefix_field_name(ResponseError.t(), nil | String.t()) :: ResponseError.t()
  defp prefix_field_name(%ResponseError{} = a, nil), do: a

  defp prefix_field_name(%ResponseError{field: field} = a, prefix)
       when is_binary(field) and is_binary(prefix) do
    %{a | field: "#{prefix}.#{field}"}
  end

  @doc """
  Given a keyword list entry, attempt to turn it into an ResponseError.
  Assumption: All Changeset errors are going to relate to a specific database field.
  """
  @spec from_changeset_error(tuple()) :: ResponseError.t() | tuple()
  def from_changeset_error({field, error}) do
    {code, description} = Solicit.Changeset.code_and_description(error)

    if code && description do
      field = if is_atom(field), do: Atom.to_string(field), else: field

      %ResponseError{
        field: field,
        code: code,
        description: description
      }
    end
  end
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
