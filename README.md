# Solicit

[![CI](https://github.com/smartrent/solicit/actions/workflows/ci.yml/badge.svg)](https://github.com/smartrent/solicit/actions/workflows/ci.yml)

_Solicit_ is an Elixir package that provides basic API Response Handling.

## Installation

Solicit can be installed by adding `solicit` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:solicit, "~> 1.3"}
  ]
end
```

## Core Components

- [Response](./md/response.md)
- [Plug](md/plug.md)

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/solicit](https://hexdocs.pm/solicit).

## Publishing

1. Update [`CHANGELOG.md`](./CHANGELOG.md)
2. Bump `@version` in [`mix.exs`](./mix.exs)
3. `git commit -m 'release x.y.z'`
4. `git tag -a x.y.z -m 'release x.y.z'`
4. `git push --follow-tags`
5. `mix hex.publish`
6. Create a [GitHub release](https://github.com/smartrent/solicit/releases/new)
