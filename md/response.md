# Response

### Response.ok/1

Usage:

This is used for a successful response and no payload is desired.

```elixir
  Response.ok(conn)
```

Returns `Plug.Conn.t()` with a status of `200` and an empty payload.

### Response.ok/3

Usage:

This is used for a successful response.

```elixir
  Response.ok(conn, %{records: _, current_page: _, total_pages: _, total_records: _}, fields)
```

Returns `Plug.Conn.t()` with a status of `200` and a payload of

```elixir
%{
  "current_page" => _,
  "records" => _,
  "total_pages" => _,
  "total_records" => _
}
```

### Response.created/3

Usage:

This is used for a successful created response.

```elixir
  Response.created(conn, result, fields)
```

Returns `Plug.Conn.t()` with a status of `201` and the result passed in as the payload.

### Response.accepted/1

Usage:

This is used for an accepted response. Normally used to signify that the request was accepted, but might not have finished processing.

```elixir
  Response.accepted(conn)
```

Returns `Plug.Conn.t()` with a status of `202` and an empty payload.

### Response.accepted/2

Usage:

This is used for an accepted response. Normally used to signify that the request was accepted, but might not have finished processing.

```elixir
  Response.accepted(conn, details)
```

Returns `Plug.Conn.t()` with a status of `202` and the details passed in as the payload.

### Response.accepted/3

Usage:

This is used for an accepted response. Normally used to signify that the request was accepted, but might not have finished processing.

```elixir
  Response.accepted(conn, %{license_plate: _, state: _}, fields)
```

Returns `Plug.Conn.t()` with a status of `202` and a payload of

```elixir
%{
  "license_plate" => _,
  "state" => _
}
```

### Response.no_content/1

Usage:

This is used for a no_content response. Normally used when deleting.

```elixir
  Response.no_content(conn)
```

Returns `Plug.Conn.t()` with a status of `204` and an empty payload.

### Response.bad_request/1

Usage:

This is used to signify a bad request.

```elixir
  Response.bad_request(conn)
```

Returns `Plug.Conn.t()` with a status of `400` and a payload of

```elixir
%{"errors" => {code: :bad_request, description: "Bad request.", field: nil}
```

### Response.bad_request/2

Usage:

This is used to signify a bad request and takes either `binary()` or `Ecto.Changeset.t()`.

```elixir
  Response.bad_request(conn, message | changeset)
```

Returns `Plug.Conn.t()` with a status of `400` and a payload dependent upon the provided data.

### Response.unauthorized/1

Usage:

This is used to signify an unauthorized request.

```elixir
  Response.unauthorized(conn)
```

Returns `Plug.Conn.t()` with a status of `401` and a payload of

```elixir
%{"errors" => [{code: :unauthorized, description: "Must include valid Authorization credentials", field: nil}]}
```

### Response.forbidden/1

Usage:

This is used to signify a forbidden response.

```elixir
  Response.forbidden(conn)
```

Returns `Plug.Conn.t()` with a status of `403` and a payload of

```elixir
%{"errors" => [{code: :forbidden, description: "This action is forbidden.", field: nil}]}
```

### Response.not_found/1

Usage:

This is used to signify a not found response.

```elixir
  Response.not_found(conn)
```

Returns `Plug.Conn.t()` with a status of `404` and a payload of

```elixir
%{"errors" => [{code: :not_found, description: "The resource was not found.", field: nil}]}
```

### Response.conflict/2

Usage:

This is used to signify a conflicting response.

```elixir
  Response.conflict(conn, description)
```

Returns `Plug.Conn.t()` with a status of `409` and a payload of

```elixir
%{"errors" => [{code: :conflict, description: description, field: nil}]}
```

### Response.unprocessable_entity/1

Usage:

This is used to signify a base unprocessable_entity response.

```elixir
  Response.unprocessable_entity(conn)
```

Returns `Plug.Conn.t()` with a status of `422` and a payload of

```elixir
%{"errors" => [{code: :unprocessable_entity, description: "Unable to process change.", field: nil}]}
```

### Response.internal_server_error/1

Usage:

This is used to signify an internal_server_error response. Use in the rare case that you want to throw a `500`.

```elixir
  Response.internal_server_error(conn, message)
```

Returns `Plug.Conn.t()` with a status of `500` and a payload of

```elixir
%{"errors" => [message]}
```
