defmodule Solicit.Plugs.Validation.DateBodyParams do
  @moduledoc """
  Check to make sure when dates are provided in the request body that they in a valid format
  and follow correct logic
  """

  alias Plug.Conn
  alias Solicit.Response

  @spec init(keyword()) :: keyword()
  def init(opts \\ []), do: opts

  @spec call(Conn.t(), keyword()) :: Plug.Conn.t()
  def call(%{body_params: params} = conn, _opts) do
    case validate_dates_payload(params) do
      :ok ->
        conn

      {:error, error} ->
        Response.unprocessable_entity(conn, [error])
    end
  end

  @spec validate_dates_payload(map()) :: :ok | {:error, map()}
  defp validate_dates_payload(%{"end_date" => end_date})
       when is_nil(end_date),
       do: :ok

  defp validate_dates_payload(%{"start_date" => start_date, "end_date" => end_date})
       when is_nil(start_date) and not is_nil(end_date),
       do:
         {:error,
          %{
            code: :unprocessable_entity,
            description: "start_date must be set if end_date is set",
            field: "start_date"
          }}

  defp validate_dates_payload(%{"start_date" => start_date, "end_date" => end_date})
       when not is_nil(start_date) and not is_nil(end_date) do
    case DateHelper.validate_start_and_end_datetime(start_date, end_date) do
      {:error, :invalid_start_date} ->
        {:error,
         %{
           code: :unprocessable_entity,
           description: "failed to parse start_date",
           field: "start_date"
         }}

      {:error, :invalid_end_date} ->
        {:error,
         %{
           code: :unprocessable_entity,
           description: "failed to parse end_date",
           field: "end_date"
         }}

      {:error, :start_before_end} ->
        {:error,
         %{
           code: :unprocessable_entity,
           description: "start_date must be before end_date",
           field: "start_date"
         }}

      {:error, :end_before_now} ->
        {:error,
         %{
           code: :unprocessable_entity,
           description: "end_date must be in the future",
           field: "end_date"
         }}

      _ ->
        :ok
    end
  end

  defp validate_dates_payload(%{"end_date" => end_date})
       when not is_nil(end_date),
       do:
         {:error,
          %{
            code: :unprocessable_entity,
            description: "start_date must be set if end_date is set",
            field: "start_date"
          }}

  defp validate_dates_payload(%{"start_date" => start_date}) when not is_nil(start_date) do
    case Timex.parse(start_date, "{ISO:Extended:Z}") do
      {:ok, _} ->
        :ok

      _ ->
        {:error,
         %{
           code: :unprocessable_entity,
           description: "failed to parse start_date",
           field: "start_date"
         }}
    end
  end

  defp validate_dates_payload(%{"end_at" => end_at})
       when is_nil(end_at),
       do: :ok

  defp validate_dates_payload(%{"start_at" => start_at, "end_at" => end_at})
       when is_nil(start_at) and not is_nil(end_at),
       do:
         {:error,
          %{
            code: :unprocessable_entity,
            description: "start_at must be set if end_at is set",
            field: "start_at"
          }}

  defp validate_dates_payload(%{"start_at" => start_at, "end_at" => end_at})
       when not is_nil(start_at) and not is_nil(end_at) do
    case DateHelper.validate_start_and_end_datetime(start_at, end_at) do
      {:error, :invalid_start_date} ->
        {:error,
         %{
           code: :unprocessable_entity,
           description: "failed to parse start date",
           field: "start_at"
         }}

      {:error, :invalid_end_date} ->
        {:error,
         %{
           code: :unprocessable_entity,
           description: "failed to parse end date",
           field: "end_at"
         }}

      {:error, :start_before_end} ->
        {:error,
         %{
           code: :unprocessable_entity,
           description: "start date must be before end date",
           field: "start_at"
         }}

      {:error, :end_before_now} ->
        {:error,
         %{
           code: :unprocessable_entity,
           description: "end date must be in the future",
           field: "end_at"
         }}

      _ ->
        :ok
    end
  end

  defp validate_dates_payload(%{"end_at" => end_at})
       when not is_nil(end_at),
       do:
         {:error,
          %{
            code: :unprocessable_entity,
            description: "start_at must be set if end_at is set",
            field: "start_at"
          }}

  defp validate_dates_payload(%{"start_at" => start_at}) when not is_nil(start_at) do
    case Timex.parse(start_at, "{ISO:Extended:Z}") do
      {:ok, _} ->
        :ok

      _ ->
        {:error,
         %{
           code: :unprocessable_entity,
           description: "failed to parse start_at",
           field: "start_at"
         }}
    end
  end

  defp validate_dates_payload(_), do: :ok
end
