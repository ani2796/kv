# KV

Implementing a distributed key-value store similar to Dynamo

## Project Structure

Currently, the application consists of simple key-value buckets which are tracked by a
registry.  
  
TODO: Use supervisor to handle registry failures  
TODO: Use dynamic supervisor to manage buckets  

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `kv` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:kv, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/kv>.

