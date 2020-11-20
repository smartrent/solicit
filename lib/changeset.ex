defmodule Solicit.Changeset do
  @moduledoc """
  Generic functions for working with changesets that are not packaged with Ecto.
  """

  @doc """
  A module encapsulating the translation layer between a changeset error and the JSON error shape returned in an API response.
  """
  @spec code_and_description(tuple()) :: tuple()
  def code_and_description({"can't be blank", _}),
    do: {:required, "This value cannot be blank."}

  def code_and_description({"has already been taken", _}),
    do: {:duplicate, "This value has already been taken."}

  def code_and_description({"does not exist", _}),
    do: {:missing_relation, "The specified relation does not exist."}

  def code_and_description({"is invalid", [type: :string, validation: :cast]}),
    do: {:string_required, "This value must be a string."}

  def code_and_description({"is invalid", [type: :boolean, validation: :cast]}),
    do: {:boolean_required, "This value must be boolean."}

  def code_and_description({"is invalid", [type: :integer, validation: :cast]}),
    do: {:integer_required, "This value must be an integer."}

  def code_and_description({"is invalid", [type: :float, validation: :cast]}),
    do: {:float_required, "This value must be a float."}

  def code_and_description({"is invalid", [type: :utc_datetime, validation: :cast]}),
    do: {:utc_datetime_required, "This value must be a UTC datetime in ISO8601 format."}

  def code_and_description({"is invalid", [type: :time, validation: :cast]}),
    do: {:time_required, "This value must be a time string (e.g. '15:30:10')."}

  def code_and_description({"is invalid", [type: Ecto.UUID, validation: :cast]}),
    do: {:uuid_required, "This value must be a version 4 UUID."}

  def code_and_description({"is invalid", [type: :map, validation: :cast]}),
    do: {:object_required, "This value must be an object."}

  def code_and_description({"is invalid", [type: {:array, :string}, validation: :cast]}),
    do: {:string_array_required, "This value must be an array of strings."}

  def code_and_description({"is invalid", [type: {:array, :boolean}, validation: :cast]}),
    do: {:boolean_array_required, "This value must be an array of booleans."}

  def code_and_description({"is invalid", [type: {:array, :integer}, validation: :cast]}),
    do: {:integer_array_required, "This value must be an array of integers."}

  def code_and_description({"is invalid", [type: {:array, :float}, validation: :cast]}),
    do: {:float_array_required, "This value must be an array of floats."}

  def code_and_description({"is invalid", [type: {:array, :map}, validation: :cast]}),
    do: {:object_array_required, "This value must be an array of objects."}

  def code_and_description({"is invalid", [validation: :inclusion]}),
    do:
      {:invalid_value, "This value is the correct type but is not in the set of allowed values."}

  def code_and_description({"has invalid format", _}),
    do: {:format, "This value has invalid format."}

  def code_and_description({"invalid value", [value: v]}),
    do: {:invalid_value, "This property has an invalid value: #{v} (The type may be incorrect)"}

  def code_and_description(
        {"should have at least %{count} item(s)", [count: count, validation: :length, min: _]}
      ),
      do: {:invalid_value, "This property should have at least #{count} items."}

  # Custom Errors

  def code_and_description({"must be an existing device", _}),
    do: {:missing_relation, "The device relation does not exist."}

  def code_and_description({"not accepted", _}),
    do: {:not_accepted, "This property is not accepted; please remove it."}

  def code_and_description({"must be a device associated with the given hub", _}),
    do: {:invalid_device_id, "The device does not belong to the given hub."}

  def code_and_description(
        {"must reference a device associated with the given hub having the given attribute",
         [device_id: device_id, attribute: attribute]}
      ),
      do:
        {:device_not_found,
         "Could not find a device with ID #{device_id} associated with the given hub and having an attribute called `#{
           attribute
         }`"}

  def code_and_description(
        {"should have at most %{count} item(s)", [count: count, validation: :length, max: _]}
      ),
      do: {:invalid_value, "This property should have at most #{count} items."}

  def code_and_description({"must be empty if property given", [property: property]}),
    do: {:invalid_value, "This property must be empty if #{property} is given."}

  def code_and_description({"time range incomplete", _}),
    do: {:time_range_incomplete, "Both time range fields must be non-null."}

  def code_and_description({"must be in the future", _}),
    do: {:future_value_required, "Must be in the future."}

  def code_and_description({"invalid start time", _}),
    do: {:invalid_start_time, "The start of the time range must be before the end."}

  def code_and_description({"invalid end time", _}),
    do: {:invalid_end_time, "The end of the time range must be after the start."}

  def code_and_description({"phone or email required", _}),
    do: {:phone_or_email_required, "Either phone or email must be provided."}

  def code_and_description({"no slot available on device", _}),
    do: {:no_slot_available, "No slot available on the device."}

  def code_and_description(
        {"Permanent codes cannot have a start and end time, or recurring fields", _}
      ),
      do:
        {:invalid_activation_type_fields,
         "Permanent codes cannot have a start and end time, or recurring fields"}

  def code_and_description(
        {"Recurring codes cannot have a temporary start at or temporary end at time", _}
      ),
      do:
        {:invalid_activation_type_fields,
         "Recurring codes cannot have a temporary start at or temporary end at time"}

  def code_and_description(
        {"Each value must be a capitalized day of the week", [invalid_values: invalid_values]}
      ),
      do:
        {:invalid_values,
         "Each value must be a capitalized day of the week. Invalid values: #{
           Enum.join(invalid_values, ", ")
         }"}

  def code_and_description({"Icon not supported", _}),
    do: {:invalid_icon, "Icon not supported. Please use a valid icon name."}

  def code_and_description(
        {"should be at most %{count} character(s)",
         [count: count, validation: :length, kind: :max, type: :string]}
      ),
      do: {:invalid_value, "This property should have at most #{count} characters."}

  # V1 of mobile apps respond to this error
  def code_and_description({"duplicate code", _}),
    do: {:duplicate_code, "Code already in use."}

  # If a custom validation error was created with an error_code attached,
  # use that error_code (and the error message as the description)
  def code_and_description({description, [error_code: error_code]}),
    do: {error_code, description}

  def code_and_description({changeset_error, _}), do: {:unknown_error, changeset_error}
end
