# Pagination

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
  plug(Solicit.Plugs.Validation.PaginationParam)
```

### Custom Limit Option

You also have the option to define what you would like the `limit` ceiling to be
when fetching records by passing an `option`

```elixir
  plug(Solicit.Plugs.Validation.PaginationParam, [limit: 5])
```

