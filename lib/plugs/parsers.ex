defmodule Solicit.Plugs.Parsers do
  alias Plug.Parsers

  def init(opts), do: Parsers.init(opts)

  def call(conn, options) do
    Parsers.call(conn, options)
  rescue
    _e in Parsers.ParseError ->
      Solicit.Response.bad_request(conn, "Request is malformed")

    _e in Parsers.RequestTooLargeError ->
      Solicit.Response.request_entity_too_large(conn)

    _e in Parsers.UnsupportedMediaTypeError ->
      Solicit.Response.unsupported_media_type(conn)

    _e in Parsers.BadEncodingError ->
      Solicit.Response.bad_request(conn, "Request has bad encoding")
  end
end
