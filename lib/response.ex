defmodule Solicit.Response do
  @moduledoc """
  Standardized responses
  """

  import Plug.Conn
  import Phoenix.Controller

  alias Ecto.Changeset
  alias Solicit.ResponseError

  # 200
  @doc """
  Returns a successful response.
  """
  @spec ok(
          Plug.Conn.t(),
          term(),
          term()
        ) :: Plug.Conn.t()
  def ok(
        conn,
        result,
        fields \\ nil
      ) do
    conn
    |> json(as_json(result, fields))
    |> halt()
  end

  @doc """
  Returns a successful response with no payload.
  """
  @spec ok(Plug.Conn.t()) :: Plug.Conn.t()
  def ok(conn) do
    conn
    |> json(nil)
    |> halt()
  end

  # 201
  @doc """
  Returns a successful created response.
  """
  @spec created(Plug.Conn.t(), term(), term()) :: Plug.Conn.t()
  def created(conn, result, fields \\ nil) do
    conn
    |> put_status(:created)
    |> json(as_json(result, fields))
    |> halt()
  end

  # 202
  @doc """
  Returns a successful accepted response. Normally used to signify that the request was accepted, but might not have finished processing.
  """
  @spec accepted(Plug.Conn.t()) :: Plug.Conn.t()
  def accepted(conn) do
    conn
    |> put_status(:accepted)
    |> json(nil)
    |> halt()
  end

  @spec accepted(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def accepted(conn, details) when is_binary(details) do
    conn
    |> put_status(:accepted)
    |> json(%{details: details})
    |> halt()
  end

  @spec accepted(Plug.Conn.t(), term(), term()) :: Plug.Conn.t()
  def accepted(conn, details, fields \\ nil) do
    conn
    |> put_status(:accepted)
    |> json(as_json(details, fields))
    |> halt()
  end

  # 204
  @doc """
  Returns a successful no_content response. Normally used when deleting.
  """
  @spec no_content(Plug.Conn.t()) :: Plug.Conn.t()
  def no_content(conn) do
    conn
    |> send_resp(:no_content, "")
    |> halt()
  end

  # 400
  @doc """
  Signifies a bad request.
  """
  @spec bad_request(Plug.Conn.t()) :: Plug.Conn.t()
  def bad_request(conn) do
    conn
    |> put_status(:bad_request)
    |> json(%{errors: [ResponseError.bad_request()]})
    |> halt()
  end

  @spec bad_request(Plug.Conn.t(), Ecto.Changeset.t()) :: Plug.Conn.t()
  def bad_request(conn, %Ecto.Changeset{} = changeset) do
    conn
    |> put_status(:bad_request)
    |> json(%{errors: ResponseError.from_changeset(changeset)})
    |> halt()
  end

  @spec bad_request(Plug.Conn.t(), binary()) :: Plug.Conn.t()
  def bad_request(conn, message) do
    conn
    |> put_status(:bad_request)
    |> json(%{errors: [message]})
    |> halt()
  end

  # 401
  @doc """
  Signifies an unauthorized request.
  """
  @spec unauthorized(Plug.Conn.t(), list()) :: Plug.Conn.t()
  def unauthorized(conn, errors) do
    conn
    |> put_status(:unauthorized)
    |> json(%{errors: errors})
    |> halt()
  end

  @spec unauthorized(Plug.Conn.t()) :: Plug.Conn.t()
  def unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> json(%{errors: [ResponseError.unauthorized()]})
    |> halt()
  end

  # 403
  @doc """
  Signifies a forbidden response.
  """
  @spec forbidden(Plug.Conn.t(), list()) :: Plug.Conn.t()
  def forbidden(conn, errors) do
    conn
    |> put_status(:forbidden)
    |> json(%{errors: errors})
    |> halt()
  end

  @spec forbidden(Plug.Conn.t()) :: Plug.Conn.t()
  def forbidden(conn) do
    conn
    |> put_status(:forbidden)
    |> json(%{errors: [ResponseError.forbidden()]})
    |> halt()
  end

  # 404
  @doc """
  Signifies a not found response.
  """
  @spec not_found(Plug.Conn.t(), list()) :: Plug.Conn.t()
  def not_found(conn, errors) do
    conn
    |> put_status(:not_found)
    |> json(%{errors: errors})
    |> halt()
  end

  @spec not_found(Plug.Conn.t()) :: Plug.Conn.t()
  def not_found(conn) do
    conn
    |> put_status(:not_found)
    |> json(%{errors: [ResponseError.not_found()]})
    |> halt()
  end

  # 405
  @doc """
  Signifies a method not allowed response.
  """
  @spec method_not_allowed(Plug.Conn.t(), list()) :: Plug.Conn.t()
  def method_not_allowed(conn, errors) do
    conn
    |> put_status(:method_not_allowed)
    |> json(%{errors: errors})
    |> halt()
  end

  @spec method_not_allowed(Plug.Conn.t()) :: Plug.Conn.t()
  def method_not_allowed(conn) do
    conn
    |> put_status(:method_not_allowed)
    |> json(%{errors: [ResponseError.method_not_allowed()]})
    |> halt()
  end

  # 408
  @doc """
  Signifies a request timeout response.
  """
  @spec timeout(Plug.Conn.t(), list()) :: Plug.Conn.t()
  def timeout(conn, errors) do
    conn
    |> put_status(:request_timeout)
    |> json(%{errors: errors})
    |> halt()
  end

  @spec timeout(Plug.Conn.t()) :: Plug.Conn.t()
  def timeout(conn) do
    conn
    |> put_status(:request_timeout)
    |> json(%{errors: [ResponseError.timeout()]})
    |> halt()
  end

  # 409
  @doc """
  Signifies a conflicting response.
  """
  @spec conflict(Plug.Conn.t()) :: Plug.Conn.t()
  def conflict(conn) do
    conn
    |> put_status(:conflict)
    |> json(%{errors: [ResponseError.conflict()]})
    |> halt()
  end

  @spec conflict(Plug.Conn.t(), list() | binary()) :: Plug.Conn.t()
  def conflict(conn, errors) when is_list(errors) do
    conn
    |> put_status(:conflict)
    |> json(%{errors: errors})
    |> halt()
  end

  def conflict(conn, description) when is_binary(description) do
    conn
    |> put_status(:conflict)
    |> json(%{errors: [ResponseError.conflict(description)]})
    |> halt()
  end

  # 410
  @doc """
  Signifies a gone response.
  """
  @spec gone(Plug.Conn.t()) :: Plug.Conn.t()
  def gone(conn) do
    conn
    |> put_status(:gone)
    |> json(%{errors: [ResponseError.gone()]})
    |> halt()
  end

  @spec gone(Plug.Conn.t(), binary()) :: Plug.Conn.t()
  def gone(conn, description) do
    conn
    |> put_status(:gone)
    |> json(%{errors: [ResponseError.gone(description)]})
    |> halt()
  end

  # 413
  @doc """
  Signifies a request_entity_too_large response.
  """
  @spec request_entity_too_large(Plug.Conn.t()) :: Plug.Conn.t()
  def request_entity_too_large(conn) do
    conn
    |> put_status(:request_entity_too_large)
    |> json(%{errors: [ResponseError.request_entity_too_large()]})
    |> halt()
  end

  @spec request_entity_too_large(Plug.Conn.t(), binary()) :: Plug.Conn.t()
  def request_entity_too_large(conn, description) do
    conn
    |> put_status(:request_entity_too_large)
    |> json(%{errors: [ResponseError.request_entity_too_large(description)]})
    |> halt()
  end

  # 415
  @doc """
  Signifies a unsupported_media_type response.
  """
  @spec unsupported_media_type(Plug.Conn.t()) :: Plug.Conn.t()
  def unsupported_media_type(conn) do
    conn
    |> put_status(:unsupported_media_type)
    |> json(%{errors: [ResponseError.unsupported_media_type()]})
    |> halt()
  end

  @spec unsupported_media_type(Plug.Conn.t(), binary()) :: Plug.Conn.t()
  def unsupported_media_type(conn, description) do
    conn
    |> put_status(:unsupported_media_type)
    |> json(%{errors: [ResponseError.unsupported_media_type(description)]})
    |> halt()
  end

  # 422
  @doc """
  Signifies an unprocessable_entity response.
  """
  @spec unprocessable_entity(
          Plug.Conn.t(),
          Ecto.Changeset.t() | binary() | atom() | Postgrex.Error.t() | list()
        ) ::
          Plug.Conn.t()
  def unprocessable_entity(conn, %Changeset{} = changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: ResponseError.from_changeset(changeset)})
    |> halt()
  end

  def unprocessable_entity(conn, %Postgrex.Error{} = postgrex_error) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: [postgrex_error.postgres.message]})
    |> halt()
  end

  def unprocessable_entity(conn, message) when is_binary(message) or is_atom(message) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: [message]})
    |> halt()
  end

  def unprocessable_entity(conn, errors) when is_list(errors) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: errors})
    |> halt()
  end

  @spec unprocessable_entity(Plug.Conn.t()) :: Plug.Conn.t()
  def unprocessable_entity(conn) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: [ResponseError.unprocessable_entity()]})
    |> halt()
  end

  # 429
  @doc """
  Signifies an too_many_requests request.
  """
  @spec too_many_requests(Plug.Conn.t()) :: Plug.Conn.t()
  def too_many_requests(conn) do
    conn
    |> put_status(:too_many_requests)
    |> json(%{errors: [ResponseError.too_many_requests()]})
    |> halt()
  end

  @spec too_many_requests(Plug.Conn.t(), binary()) :: Plug.Conn.t()
  def too_many_requests(conn, message) when is_binary(message) do
    conn
    |> put_status(:too_many_requests)
    |> json(%{errors: [ResponseError.too_many_requests(message)]})
    |> halt()
  end

  # 500
  @doc """
  Signifies an internal_server_error request.
  """
  @spec internal_server_error(Plug.Conn.t(), binary() | list()) :: Plug.Conn.t()
  def internal_server_error(conn, message) when is_binary(message) do
    conn
    |> put_status(:internal_server_error)
    |> json(%{errors: [message]})
    |> halt()
  end

  def internal_server_error(conn, errors) when is_list(errors) do
    conn
    |> put_status(:internal_server_error)
    |> json(%{errors: errors})
    |> halt()
  end

  @spec internal_server_error(Plug.Conn.t()) :: Plug.Conn.t()
  def internal_server_error(conn) do
    conn
    |> put_status(:internal_server_error)
    |> json(%{errors: [ResponseError.internal_server_error()]})
    |> halt()
  end

  # 502
  @doc """
  Signifies a bad gateway request.
  """
  @spec bad_gateway(Plug.Conn.t(), binary() | list(ResponseError.t())) :: Plug.Conn.t()
  def bad_gateway(conn, message) when is_binary(message) do
    conn
    |> put_status(:bad_gateway)
    |> json(%{errors: [ResponseError.bad_gateway(message)]})
    |> halt()
  end

  def bad_gateway(conn, errors) when is_list(errors) do
    conn
    |> put_status(:bad_gateway)
    |> json(%{errors: errors})
    |> halt()
  end

  @spec bad_gateway(Plug.Conn.t()) :: Plug.Conn.t()
  def bad_gateway(conn) do
    conn
    |> put_status(:bad_gateway)
    |> json(%{errors: [ResponseError.bad_gateway()]})
    |> halt()
  end

  # 503
  @doc """
  Signifies a service unavailable request.
  """
  @spec service_unavailable(Plug.Conn.t(), binary() | list(ResponseError.t())) :: Plug.Conn.t()
  def service_unavailable(conn, message) when is_binary(message) do
    conn
    |> put_status(:service_unavailable)
    |> json(%{errors: [ResponseError.service_unavailable(message)]})
    |> halt()
  end

  def service_unavailable(conn, errors) when is_list(errors) do
    conn
    |> put_status(:service_unavailable)
    |> json(%{errors: errors})
    |> halt()
  end

  @spec service_unavailable(Plug.Conn.t()) :: Plug.Conn.t()
  def service_unavailable(conn) do
    conn
    |> put_status(:service_unavailable)
    |> json(%{errors: [ResponseError.service_unavailable()]})
    |> halt()
  end

  @doc """
  Returns structs or maps with specific fields extracted.

  ## Example

      def show(%{assigns: %{user: user}} = conn, _params) do
        conn
        |> as_json(user, [
          :id,
          :first_name,
          :last_name,
          :email
        ])
      end

  ## Example w/ Association

      def show(%{assigns: %{unit: unit}} = conn, _params) do
        conn
        |> as_json(unit, [
          :id,
          :marketing_name,
          :street_address_1,
          :street_address_2,
          :city,
          :state,
          full_address: fn unit ->
            "\#{unit.street_address_1}, \#{unit.city}, \#{unit.state}"
          end
          group: [
            :id,
            :marketing_name
          ],
          residents: [
            :id,
            :first_name,
            :last_name
          ]
        ])
      end

  If you don't add an associations fields and just the key `:group`, it will throw an `ArgumentError` letting you know that you forgot to add the related fields.

  *Note: Associations must be added last in the list or you will result in a syntax error*

  ### Incorrect:

      def show(%{assigns: %{unit: unit}} = conn, _params) do
        conn
        |> as_json(unit, [
          :id,
          :marketing_name,
          :street_address_1,
          :street_address_2,
          group: [
            :id,
            :marketing_name
          ],
          :city,
          :state
        ])
      end

  ### Correct:

      def show(%{assigns: %{unit: unit}} = conn, _params) do
        conn
        |> as_json(unit, [
          :id,
          :marketing_name,
          :street_address_1,
          :street_address_2,
          :city,
          :state,
          group: [
            :id,
            :marketing_name
          ],
        ])
      end
  """
  def as_json(struct, nil), do: struct

  def as_json(nil, _fields), do: nil

  def as_json(struct, fields) do
    Enum.reduce(fields, %{}, fn field, acc ->
      {field, value} =
        case field do
          {field, generate} when is_function(generate, 1) ->
            {field, generate.(struct)}

          {field, {:array, assoc_fields}} ->
            transformed_array =
              struct
              |> Map.get(field)
              |> Enum.map(&as_json(&1, assoc_fields))

            {field, transformed_array}

          {field, assoc_fields} ->
            convert_assoc_struct(struct, field, assoc_fields)

          field ->
            convert_struct(struct, field)
        end

      Map.put(acc, field, value)
    end)
  end

  defp convert_struct(nil, _field), do: nil

  defp convert_struct(struct, field) do
    {field, Map.get(struct, field)}
  end

  defp convert_assoc_struct(struct, field, assoc_fields) do
    assoc = Map.get(struct, field)

    if is_list(assoc) do
      {field,
       Enum.map(assoc, fn assoc_struct ->
         as_json(assoc_struct, assoc_fields)
       end)}
    else
      {field, as_json(assoc, assoc_fields)}
    end
  end
end
