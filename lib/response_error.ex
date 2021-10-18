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

  @spec generic_error(binary()) :: ResponseError.t()
  def generic_error(description \\ "An unknown error occurred."),
    do: %ResponseError{code: :error, description: description}

  @spec bad_request(binary()) :: ResponseError.t()
  def bad_request(description \\ "Bad request."),
    do: %ResponseError{code: :bad_request, description: description}

  @spec forbidden(binary()) :: ResponseError.t()
  def forbidden(description \\ "This action is forbidden."),
    do: %ResponseError{code: :forbidden, description: description}

  @spec not_found(binary()) :: ResponseError.t()
  def not_found(description \\ "The resource was not found."),
    do: %ResponseError{code: :not_found, description: description}

  @spec timeout(binary()) :: ResponseError.t()
  def timeout(description \\ "Request timed out."),
    do: %ResponseError{code: :timeout, description: description}

  @spec unprocessable_entity(binary()) :: ResponseError.t()
  def unprocessable_entity(description \\ "Unable to process change.")
      when is_binary(description),
      do: %ResponseError{code: :unprocessable_entity, description: description}

  @spec conflict(binary()) :: ResponseError.t()
  def conflict(description \\ "A conflict has occurred."),
    do: %ResponseError{code: :conflict, description: description}

  @spec unauthorized(binary()) :: ResponseError.t()
  def unauthorized(description \\ "Must include valid Authorization credentials"),
    do: %ResponseError{
      code: :unauthorized,
      description: description
    }

  @spec method_not_allowed(binary()) :: ResponseError.t()
  def method_not_allowed(description \\ "Method is not allowed."),
    do: %ResponseError{
      code: :method_not_allowed,
      description: description
    }

  @spec internal_server_error(binary()) :: ResponseError.t()
  def internal_server_error(description \\ "Internal Server Error"),
    do: %ResponseError{code: :internal_server_error, description: description}

  @spec bad_gateway(binary()) :: ResponseError.t()
  def bad_gateway(description \\ "Bad Gateway"),
    do: %ResponseError{code: :bad_gateway, description: description}

  @spec service_unavailable(binary()) :: ResponseError.t()
  def service_unavailable(description \\ "Service Unavailable"),
    do: %ResponseError{code: :service_unavailable, description: description}

  @spec too_many_requests(binary()) :: ResponseError.t()
  def too_many_requests(description \\ "Exceeded request threshold."),
    do: %ResponseError{
      code: :too_many_requests,
      description: description
    }

  @spec gone(binary()) :: ResponseError.t()
  def gone(description \\ "Access to resource is no longer available."),
    do: %ResponseError{code: :gone, description: description}

  @spec request_entity_too_large(binary()) :: ResponseError.t()
  def request_entity_too_large(description \\ "Request entity is too large."),
    do: %ResponseError{code: :request_entity_too_large, description: description}

  @spec unsupported_media_type(binary()) :: ResponseError.t()
  def unsupported_media_type(description \\ "Request contains an unsupported media type."),
    do: %ResponseError{code: :unsupported_media_type, description: description}

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
