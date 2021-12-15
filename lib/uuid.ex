defmodule Solicit.UUID do
  @moduledoc """
  UUID helpers.
  """

  @doc """
  Returns true if the given value is a valid UUID.

  ## Examples

      iex> Solicit.UUID.valid?("00000000-0000-0000-0000-000000000000")
      true

      iex> Solicit.UUID.valid?("21985486-b01a-11ea-b3de-0242ac130004")
      true

      iex> Solicit.UUID.valid?("🍉")
      false

      iex> Solicit.UUID.valid?("John Jacob Jingle-Heimerschmidt")
      false

      iex> Solicit.UUID.valid?("")
      false

      iex> Solicit.UUID.valid?("                     ")
      false

      iex> Solicit.UUID.valid?("	")
      false
  """
  @spec valid?(Ecto.UUID.t()) :: boolean()
  def valid?(uuid) do
    uuid
    |> Ecto.UUID.dump()
    |> case do
      {:ok, _} -> true
      :error -> false
    end
  end

  @doc """
  Encodes a UUID in short hexadecimal format without any dashes. Generates a random
  UUID if none is provided.

  ###Examples

      iex> Solicit.UUID.hex("7f3c1729-b7be-4eed-86a0-e843ac2219e8")
      "7f3c1729b7be4eed86a0e843ac2219e8"

      iex> Solicit.UUID.hex(<<127, 60, 23, 41, 183, 190, 78, 237, 134, 160, 232, 67, 172, 34, 25, 232>>)
      "7f3c1729b7be4eed86a0e843ac2219e8"
  """
  @spec hex(Ecto.UUID.t() | Ecto.UUID.raw() | nil) :: binary()
  def hex(uuid \\ Ecto.UUID.bingenerate())

  # binary format
  def hex(<<_::128>> = uuid), do: uuid |> Base.encode16() |> String.downcase()

  # string format
  def hex(uuid), do: uuid |> Ecto.UUID.dump!() |> hex()
end
