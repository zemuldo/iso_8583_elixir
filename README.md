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
    {:iso_8583, "~> 0.1.2"}
  ]
end
```

## Customization and configuration

  All exposed API functions take options with the following configurable options.
  
  ### TCP Length Indicator
  This is used to specify whether or not to include the 2 byte hexadecimal encoded byte length of the whole message
  whe encoding or to consider it when decoding.
  This value is set to true by default.
  Example:
  ```elixir
  ISO8583.encode(message, tcp_len_header: false)
  ```

  ### Bitmap encoding
  Primary and SecondaryBitmap encoding bitmap for fields 0-127 is configurable like below.

  Examples:

  ```elixir
  ISO8583.encode(bitmap_encoding: :ascii) # will result in 32 byte length bitmap
  ```

  ```elixir
  ISO8583.encode() # will default to :hex result in 16 byte length bitmap
  ```

  ### Custom formats

  Custom formats for data type, data length and length type for all fields including special bitmaps like 
  for 127.1 and 127.25.1 are configurable through custom formats. The default formats will be replaced by the custom one.

  To see the default formats [check here](https://github.com/zemuldo/iso_8583_elixir/blob/master/lib/iso_8583/formats/definitions.ex)

  Example:

  Here we override field 2 to have maximum of 30 characters.

  ```elixir
  custome_format = %{
        "2": %{
          content_type: "n",
          label: "Primary account number (PAN)",
          len_type: "llvar",
          max_len: 30,
          min_len: 1
        }
      }

      {:ok, message} =
        fixture_message(:"0100")
        |> Map.put(:"2", "444466668888888888888888")
        |> ISO8583.encode(formats: custome_format)

      refute message |> ISO8583.valid?()
    end
  ```
