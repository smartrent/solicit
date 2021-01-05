# Solicit

_Solicit_ is an Elixir package that provides basic API Response Handling.

## Installation

Solicit can be installed by adding `solicit` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:solicit, github: "smartrent/solicit", branch: "master"}
  ]
end
```

## Core Components

- [Response](./md/response.md)

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/log](https://hexdocs.pm/log).

## Publishing

Using the `--organization` flag is important to keep the repository **private**.

```bash
mix hex.publish --organization smartrent
```