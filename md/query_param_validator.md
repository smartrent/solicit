# Query Param Validator

Usage:

This plug is used to validate query parameters have a value set.

```elixir
  plug(Solicit.Plugs.Validation.QueryParam)
```

If providing query parameters such as
```text
GET /api?foo=
```
we will return a `400 bad_request`