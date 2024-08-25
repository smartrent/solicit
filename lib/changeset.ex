defmodule Solicit.Changeset do
  @moduledoc """
  Generic functions for working with changesets that are not packaged with Ecto.
  """

  @doc """
  A module encapsulating the translation layer between a changeset error and the JSON error shape returned in an API response.
  """
  @spec code_and_description(tuple()) :: tuple()
    def code_and_description({description, list}) when is_list(list) do
    list
    |> Keyword.fetch(:error_code)
    |> case do
      :error ->
        Keyword.fetch(list, :validation)
      
      result ->
        result
    end
    |> case do
      :error ->
        {:unknown_error, description}
      
      {:ok, error_code} ->
        {error_code, description}
    end
  end
  
  def code_and_description({changeset_error, _}), do: {:unknown_error, changeset_error}
end
