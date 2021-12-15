defmodule Solicit.Plugs.Parsers do
  @moduledoc """
  Wraps `Plug.Parsers` and rescues from the following errors:

  * `Parsers.ParseError` - 400 Bad Request
  * `Parsers.BadEncodingError` - 400 Bad Request
  * `Parsers.RequestTooLargeError` - 413 Request Entity Too Large
  * `Parsers.UnsupportedMediaTypeError` - 415 Unsupported Media Type

  See `Plug.Parsers`.
  """

  alias Plug.Parsers

  @doc false
  def init(opts), do: Parsers.init(opts)

  @doc false
  def call(conn, options) do
    Parsers.call(conn, options)
  rescue
    _e in Parsers.ParseError ->
      Solicit.Response.bad_request(conn, "Request is malformed.")

    _e in Parsers.RequestTooLargeError ->
      Solicit.Response.request_entity_too_large(conn)

    _e in Parsers.UnsupportedMediaTypeError ->
      Solicit.Response.unsupported_media_type(conn)

    _e in Parsers.BadEncodingError ->
      Solicit.Response.bad_request(conn, "Request has bad encoding.")
  end
end
