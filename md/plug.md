# Plug

## Pagination Params Validator

Usage:

This plug is used to validate pagination parameters `page`, `offset`, and `limit`.

`page` - must be a positive number
`offset` - must be a positive number
`limit` - must be a positive number and must be under the defined record limit (see below)

### Default Options

When using the plug, the default `limit` is defined to fetch 1000 records or if the
limit is defined as part of a config value.

```text
solicit: [pagination_max_limit: 2000]
```

Example usage:
```elixir
  plug(Solicit.Plugs.Validation.PaginationParams)
```

### Custom Limit Option

You also have the option to define what you would like the `max_limit` ceiling to be
when fetching records by passing an `option`

```elixir
  plug(Solicit.Plugs.Validation.PaginationParams, [max_limit: 5])
```
## Query Params Validator

Usage:

This plug is used to validate query parameters have a value set.

```elixir
  plug(Solicit.Plugs.Validation.QueryParams)
```

Examples:

If providing query parameters such as
```text
GET /api?foo=
```
we will return the equivalent of
```text
GET /api
```

If providing query parameters such as
```text
GET /api?foo=&bar=123
```
we will return the equivalent of
```text
GET /api?bar=123
```