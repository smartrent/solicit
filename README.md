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

## Publishing

```bash
mix git_ops.release    # bumps version, generates changelog, commits and tags
mix hex.publish        # publishes to hex.pm
```
