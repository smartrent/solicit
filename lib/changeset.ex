defmodule Solicit.Changeset do
  @moduledoc """
  Generic functions for working with changesets that are not packaged with Ecto.
  """

  @doc """
  A module encapsulating the translation layer between a changeset error and the JSON error shape returned in an API response.
  """
  @spec code_and_description(tuple()) :: tuple()
  def code_and_description({description, [error_code: error_code]}),
    do: {error_code, description}

  def code_and_description({description, [validation: error_code]}),
    do: {error_code, description}

  def code_and_description({changeset_error, _}), do: {:unknown_error, changeset_error}
end
