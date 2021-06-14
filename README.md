# Solicit

[![CI](https://github.com/smartrent/solicit/actions/workflows/ci.yml/badge.svg)](https://github.com/smartrent/solicit/actions/workflows/ci.yml)

_Solicit_ is an Elixir package that provides basic API Response Handling.

## Installation

Solicit can be installed by adding `solicit` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:solicit, github: "smartrent/solicit", branch: "main"}
  ]
end
```

## Core Components

- [Response](./md/response.md)
- [Plug](md/plug.md)

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/log](https://hexdocs.pm/log).

## Publishing

```bash
mix git_ops.release    # bumps version, generates changelog, commits and tags
mix hex.publish        # publishes to hex.pm
```
