# ISO8583

An ISO 8583 messaging library for Elixir. Supports message validation, encoding and decoding. [See the docs](https://hexdocs.pm/iso_8583)

```elixir
iex> message
%{
  "0": "0800",
  "11": "646465",
  "12": "160244",
  "13": "0818",
  "7": "0818160244",
  "70": "001"
}
iex> {:ok, encoded} = ISO8583.encode(message)
{:ok,
 <<0, 49, 48, 56, 48, 48, 130, 56, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 48,
   56, 49, 56, 49, 54, 48, 50, 52, 52, 54, 52, 54, 52, 54, 53, 49, 54, 48, 50,
   52, 52, 48, 56, 49, 56, ...>>}
iex> {:ok, decoded} = ISO8583.decode(encoded)
{:ok,
 %{
   "0": "0800",
   "11": "646465",
   "12": "160244",
   "13": "0818",
   "7": "0818160244",
   "70": "001"
 }}
iex>
```

## Installation

```elixir
def deps do
  [
    {:iso_8583, "~> 0.1.1"}
  ]
end
```

## Customization and Configuration

Coming soon.
