# Erlgrey

Erlgrey is an Erlang Term Packer (in elixir), it's intention is to provide better compatability with erlang's types than a general purpose solution like MessagePack could provide, while keeping a somewhat simple structure that can be consumed by other languages.

## Supported Types

* Binary
* List
* Map
* Atom (includes nil, true and false)
* Tuple
* Float
* Integer

## Pack32 and Pack64

The library provides 2 implementations one using 32 bit integers as it's main
type size and one as 64, there is no 'default' implementation, choose one and stick to it.

You cannot unpack a 64 bit blob as a 32 bit and vice-versa, the format does not
support known type widths (in case computers go 128 bit one day, their will be a Pack128)

## Spec

The erlgrey packing format is extremely simple, every value is denoted by a single byte letter code followed by the type's specific data.

```elixir
# Binary
# The data is just a direct dump of the binary data with no additional transformations
<<"B",size::big-signed-integer-size(32/64),data::binary-size(size)>>

# List
# The data contains 'count' elements, to unpack a list, load up to the count
<<"L",count::big-signed-integer-size(32/64),data::binary>>

# Map
# The data contains 'count' of pairs, to unpack a map, load the data
# as a pair, where the key is first and the value is second.
<<"M",pair_count::big-signed-integer-size(32/64),data::binary>>

# Tuple
# Has the same structure as a list
<<"U",count::big-signed-integer-size(32/64),data::binary>>

# Integer
<<"I",value::big-signed-integer-size(32/64)>>

# Float
<<"I",value::big-float-size(32/64)>>

# NIL
<<"0">>

# TRUE
<<"T">>

# FALSE
<<"F">>

# Other Atoms
# Simlar to binaries
<<"A",size::big-signed-integer-size(32/64),data::binary-size(size)>>
```

By keeping the structures simple they can be easily read by other languages, even if they don't support the respective structures natively (e.g. tuples could be treated as Arrays in Java, while lists as... lists!)

## Custom Types

At the moment the library does not support custom types, it will in the future, once I figure out the best way to expose the pack and unpack APIs in a clean manner.

A mockup of the API:

```elixir
defimpl Erlgrey.CustomPacker, for: MyStruct do
  def pack(%MyStruct{} = value) do
    # ... do magic here and return binary blob
  end
end

defimpl Erlgrey.CustomUnpacker, for: MyStruct do
  def unpack(blob) do
    # ... do magic here and return {:ok, value::term, rest::binary}
  end
end
```

Erlgrey would handle setting the type information and custom type identifier.

```elixir
# Custom type
<<"C",custom_type_identifier::binary-size(4),data::binary>>
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `erlgrey` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:erlgrey, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/erlgrey](https://hexdocs.pm/erlgrey).
