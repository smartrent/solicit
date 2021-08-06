defmodule DateHelper do
  @doc """
    Returns :ok or {:error, reason} on 2 DateTime structs

  ## Examples
    iex> DateHelper.validate_start_and_end_datetime(Timex.now(), Timex.shift(Timex.now(), days: 1))
    :ok

    iex> DateHelper.validate_start_and_end_datetime(Timex.now(), Timex.shift(Timex.now(), days: -1))
    {:error, :start_before_end}

    iex> DateHelper.validate_start_and_end_datetime(Timex.shift(Timex.now, days: -2), Timex.shift(Timex.now(), days: -1))
    {:error, :end_before_now}

    iex> DateHelper.validate_start_and_end_datetime("bad", "2021-08-03T00:00:00.000Z")
    {:error, :invalid_start_date}

    iex> DateHelper.validate_start_and_end_datetime("2021-08-03T00:00:00.000Z", "bad")
    {:error, :invalid_end_date}

    iex> DateHelper.validate_start_and_end_datetime(nil, nil)
    {:error, :invalid_start_date}

    iex> DateHelper.validate_start_and_end_datetime("2021-08-03T00:00:00.000Z", nil)
    {:error, :invalid_end_date}

    iex> DateHelper.validate_start_and_end_datetime("2021-08-03T00:00:00.000Z", "2021-08-02T00:00:00.000Z")
    {:error, :start_before_end}

    iex> DateHelper.validate_start_and_end_datetime("2021-08-03T00:00:00.000Z", "2021-08-03T01:00:00.000Z")
    {:error, :end_before_now}

    iex> DateHelper.validate_start_and_end_datetime("2021-08-03T00:00:00.000Z", Timex.format!(Timex.shift(Timex.now(), days: 1), "{ISO:Extended:Z}"))
    :ok
  """
  @spec validate_start_and_end_datetime(DateTime.t(), DateTime.t()) ::
          :ok | {:error, :end_before_now | :start_before_end}
  def validate_start_and_end_datetime(%DateTime{} = start_date, %DateTime{} = end_date) do
    with {_, true} <- {:start_before_end, Timex.before?(start_date, end_date)},
         {_, true} <- {:end_before_now, Timex.before?(Timex.now(), end_date)} do
      :ok
    else
      {reason, _} -> {:error, reason}
    end
  end

  @spec validate_start_and_end_datetime(String.t() | nil, String.t() | nil) ::
          :ok
          | {:error,
             :end_before_now | :invalid_end_date | :invalid_start_date | :start_before_end}
  def validate_start_and_end_datetime(start_date, end_date)
      when is_binary(start_date) and is_binary(end_date) do
    validate_start_and_end_datetime(start_date, end_date, "{ISO:Extended:Z}")
  end

  def validate_start_and_end_datetime(start_date, _end_date)
      when is_nil(start_date),
      do: {:error, :invalid_start_date}

  def validate_start_and_end_datetime(_start_date, end_date)
      when is_nil(end_date),
      do: {:error, :invalid_end_date}

  def validate_start_and_end_datetime(_, _), do: {:error, :invalid_start_date}

  @spec validate_start_and_end_datetime(String.t() | nil, String.t() | nil, String.t()) ::
          :ok
          | {:error,
             :end_before_now | :invalid_end_date | :invalid_start_date | :start_before_end}
  def validate_start_and_end_datetime(start_date, end_date, time_format)
      when is_binary(start_date) and is_binary(end_date) do
    with {_, {:ok, start_date_time}} <-
           {:invalid_start_date, Timex.parse(start_date, time_format)},
         {_, {:ok, end_date_time}} <- {:invalid_end_date, Timex.parse(end_date, time_format)} do
      validate_start_and_end_datetime(start_date_time, end_date_time)
    else
      {reason, _} -> {:error, reason}
    end
  end
end
