defmodule ISO8583 do
  @moduledoc ~S"""
  ISO 8583 messaging library for Elixir. This library has utilities validate, encode and decode message 
  between systems using ISO 8583 regadless of the language the other system is written in. 
  """

  import ISO8583.Encode
  import ISO8583.Decode
  alias ISO8583.Formats
  alias ISO8583.DataTypes
  alias ISO8583.Utils

  @doc """
  Function to encode json or Elixir map into ISO 8583 encoded binary. Use this to encode all fields that are supported.
  See the formats module for details.
  ## Examples
      iex> message = %{
      iex>   "0": "0800",
      iex>   "7": "0818160244",
      iex>   "11": "646465",
      iex>   "12": "160244",
      iex>   "13": "0818",
      iex>   "70": "001"
      iex> }
      %{
      "0": "0800",
      "11": "646465",
      "12": "160244",
      "13": "0818",
      "7": "0818160244",
      "70": "001"
      }
      iex>ISO8583.encode(message)
      {:ok, <<0, 49, 48, 56, 48, 48, 130, 56, 0, 0, 0, 0, 
      0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 48, 56, 49, 56, 
      49, 54, 48, 50, 52, 52, 54, 52, 54, 52, 54, 53, 
      49, 54, 48, 50, 52, 52, 48, 56, 49, 56, 48, 48, 
      49>>}
  """

  def encode(message, opts \\ []) do
    opts = opts |> default_opts()

    message
    |> Utils.atomify_map()
    |> encode_0_127(opts)
  end

  @doc """
  Function to encode field 127 extensions.
  ## Examples

      iex>message = %{
      iex>"127.1": "0000008000000000",
      iex>"127.25": "7E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959"
      iex>}
      %{
        "127.1": "0000008000000000",
        "127.25": "7E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959"
      }
      iex>ISO8583.encode_127(message)
      {:ok, %{
        "127": "000000800000000001927E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959", 
        "127.1": "0000008000000000", 
        "127.25": "7E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959"
      }}
  """
  def encode_127(message, opts \\ []) do
    opts = opts |> default_opts()

    message
    |> encoding_extensions(:"127", opts)
  end

  @doc """
  Function to encode field 127.25 extensions.
  ## Examples

      iex>message = %{
      iex>"127.25.1": "7E1E5F7C00000000",
      iex>"127.25.12": "61F379D43D5AEEBC",
      iex>"127.25.13": "80",
      iex>"127.25.14": "00000000000000001E0302031F00",
      iex>"127.25.15": "020300",
      iex>"127.25.18": "06010A03A09000",
      iex>"127.25.2": "000000005000",
      iex>"127.25.20": "008C",
      iex>"127.25.21": "E0D0C8",
      iex>"127.25.22": "404",
      iex>"127.25.23": "21",
      iex>"127.25.24": "0280048800",
      iex>"127.25.26": "404",
      iex>"127.25.27": "170911",
      iex>"127.25.28": "00000147",
      iex>"127.25.29": "60",
      iex>"127.25.3": "000000000000",
      iex>"127.25.30": "BAC24959",
      iex>"127.25.4": "A0000000031010",
      iex>"127.25.5": "5C00",
      iex>"127.25.6": "0128",
      iex>"127.25.7": "FF00"
      iex>}
      %{
        "127.25.1": "7E1E5F7C00000000",
        "127.25.2": "000000005000",
        "127.25.3": "000000000000",
        "127.25.4": "A0000000031010",
        "127.25.5": "5C00",
        "127.25.6": "0128",
        "127.25.7": "FF00",
        "127.25.12": "61F379D43D5AEEBC",
        "127.25.13": "80",
        "127.25.14": "00000000000000001E0302031F00",
        "127.25.15": "020300",
        "127.25.18": "06010A03A09000",
        "127.25.20": "008C",
        "127.25.21": "E0D0C8",
        "127.25.22": "404",
        "127.25.23": "21",
        "127.25.24": "0280048800",
        "127.25.26": "404",
        "127.25.27": "170911",
        "127.25.28": "00000147",
        "127.25.29": "60",
        "127.25.30": "BAC24959"
      }
      iex>ISO8583.encode_127_25(message)
      {:ok, %{
        "127.25": "01927E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959", 
        "127.25.1": "7E1E5F7C00000000", 
        "127.25.12": "61F379D43D5AEEBC", 
        "127.25.13": "80", 
        "127.25.14": "00000000000000001E0302031F00", 
        "127.25.15": "020300", 
        "127.25.18": "06010A03A09000", 
        "127.25.2": "000000005000", 
        "127.25.20": "008C", 
        "127.25.21": "E0D0C8", 
        "127.25.22": "404", 
        "127.25.23": "21", 
        "127.25.24": "0280048800", 
        "127.25.26": "404", 
        "127.25.27": "170911", 
        "127.25.28": "00000147", 
        "127.25.29": "60", 
        "127.25.3": "000000000000", 
        "127.25.30": "BAC24959", 
        "127.25.4": "A0000000031010", 
        "127.25.5": "5C00", 
        "127.25.6": "0128", 
        "127.25.7": "FF00"
      }}
  """
  def encode_127_25(message, opts \\ []) do
    opts = opts |> default_opts()

    message
    |> encoding_extensions(:"127.25", opts)
  end

  @doc """
  Function to encode json or Elixir map into ISO 8583 encoded binary. Use this to encode all fields that are supported.
  See the formats module for details.
  ## Examples
      iex> message = <<0, 49, 48, 56, 48, 48, 130, 56, 0, 0, 0, 0,
      iex> 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 48, 56, 49, 56, 
      iex> 49, 54, 48, 50, 52, 52, 54, 52, 54, 52, 54, 53,
      iex> 49, 54, 48, 50, 52, 52, 48, 56, 49, 56, 48, 48, 
      iex> 49>>
      iex>ISO8583.decode(message)
      {:ok, %{
      "0": "0800",
      "11": "646465",
      "12": "160244",
      "13": "0818",
      "7": "0818160244",
      "70": "001"
      }}
  """

  def decode(message, opts \\ []) do
    opts = opts |> default_opts()

    message
    |> decode_0_127(opts)
  end

  @doc """
  Function to expand field 127 to its sub fields.
  ## Examples

      iex>message = %{
      iex>"127": "000000800000000001927E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959"
      iex>}
      %{
          "127": "000000800000000001927E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959"
      }
      iex>ISO8583.decode_127(message)
      %{
          "127": "000000800000000001927E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959",
          "127.25": "7E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959"
       }
  """
  def decode_127(message, opts \\ [])

  def decode_127(message, opts) when is_binary(message) do
    opts = opts |> default_opts()

    message
    |> expand_binary("127.", opts)
  end

  def decode_127(message, opts) do
    opts = opts |> default_opts()

    message
    |> expand_field("127.", opts)
  end

  @doc """
  Function to expand field 127.25 to its sub fields
  ## Examples

      iex>message = %{
      iex>"127": "000000800000000001927E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959",
      iex>"127.25": "7E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959"
      iex>}
      %{
          "127": "000000800000000001927E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959",
          "127.25": "7E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959"
      }
      iex>ISO8583.decode_127_25(message)
      %{
        "127": "000000800000000001927E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959",
        "127.25": "7E1E5F7C0000000000000000500000000000000014A00000000310105C000128FF0061F379D43D5AEEBC8002800000000000000001E0302031F000203001406010A03A09000008CE0D0C840421028004880040417091180000014760BAC24959",
        "127.25.12": "61F379D43D5AEEBC",
        "127.25.13": "80",
        "127.25.14": "00000000000000001E0302031F00",
        "127.25.15": "020300",
        "127.25.18": "06010A03A09000",
        "127.25.2": "000000005000",
        "127.25.20": "008C",
        "127.25.21": "E0D0C8",
        "127.25.22": "404",
        "127.25.23": "21",
        "127.25.24": "0280048800",
        "127.25.26": "404",
        "127.25.27": "170911",
        "127.25.28": "00000147",
        "127.25.29": "60",
        "127.25.3": "000000000000",
        "127.25.30": "BAC24959",
        "127.25.4": "A0000000031010",
        "127.25.5": "5C00",
        "127.25.6": "0128",
        "127.25.7": "FF00"
      }
  """
  def decode_127_25(message, opts \\ []) do
    opts = opts |> default_opts()

    message
    |> expand_field("127.25.", opts)
  end

  @doc """
  Function check if json message is valid.
  ## Examples
      iex> message = %{
      iex>   "0": "0800",
      iex>   "7": "0818160244",
      iex>   "11": "646465",
      iex>   "12": "160244",
      iex>   "13": "0818",
      iex>   "70": "001"
      iex> }
      %{
      "0": "0800",
      "11": "646465",
      "12": "160244",
      "13": "0818",
      "7": "0818160244",
      "70": "001"
      }
      iex>ISO8583.valid?(message)
      true
      iex> message = <<0, 49, 48, 56, 48, 48, 130, 56, 0, 0, 0, 0,
      iex> 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 48, 56, 49, 56, 
      iex> 49, 54, 48, 50, 52, 52, 54, 52, 54, 52, 54, 53,
      iex> 49, 54, 48, 50, 52, 52, 48, 56, 49, 56, 48, 48, 
      iex> 49>>
      iex>ISO8583.valid?(message)
      true
  """
  def valid?(message, opts \\ [])

  def valid?(message, opts) when is_map(message) do
    opts = opts |> default_opts()

    with atomified <- Utils.atomify_map(message),
         {:ok, _} <- DataTypes.valid?(atomified, opts) do
      true
    else
      _ -> false
    end
  end

  def valid?(message, opts) when is_binary(message) do
    opts = opts |> default_opts()

    with {:ok, decoded} <- decode(message),
         {:ok, _} <- DataTypes.valid?(decoded, opts) do
      true
    else
      error -> false
    end
  end

  @doc """
  Function check if json message is valid.
  ## Examples
      iex> message = %{
      iex>   "0": "0800",
      iex>   "7": "0818160244",
      iex>   "11": "646465",
      iex>   "12": "160244",
      iex>   "13": "0818",
      iex>   "70": "001"
      iex> }
      %{
      "0": "0800",
      "11": "646465",
      "12": "160244",
      "13": "0818",
      "7": "0818160244",
      "70": "001"
      }
      iex>ISO8583.valid(message)
      {:ok, message}
      iex> message = <<0, 49, 48, 56, 48, 48, 130, 56, 0, 0, 0, 0,
      iex> 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 48, 56, 49, 56, 
      iex> 49, 54, 48, 50, 52, 52, 54, 52, 54, 52, 54, 53,
      iex> 49, 54, 48, 50, 52, 52, 48, 56, 49, 56, 48, 48, 
      iex> 49>>
      iex>ISO8583.valid(message)
      {:ok, %{
      "0": "0800",
      "11": "646465",
      "12": "160244",
      "13": "0818",
      "7": "0818160244",
      "70": "001"
      }}
  """
  def valid(message, opts \\ [])

  def valid(message, opts) when is_map(message) do
    opts = opts |> default_opts()

    message
    |> Utils.atomify_map()
    |> DataTypes.valid?(opts)
  end

  def valid(message, opts) when is_binary(message) do
    opts = opts |> default_opts()

    with {:ok, decoded} <- decode(message) do
      decoded |> DataTypes.valid?(opts)
    else
      error -> error
    end
  end

  defp default_opts([]) do
    [bitmap_encoding: :hex, tcp_len_header: true, formats: Formats.formats_definitions()]
  end

  defp default_opts(opts) do
    default_opts([])
    |> Keyword.merge(opts)
    |> configure_formats()
  end

  defp configure_formats(opts) do
    case opts[:formats] |> is_map() do
      false ->
        opts
        |> Keyword.put(:formats, Formats.formats_definitions())

      true ->
        formats_with_customs =
          Formats.formats_definitions()
          |> Map.merge(opts[:formats] |> Utils.atomify_map())

        opts
        |> Keyword.merge(formats: formats_with_customs)
    end
  end
end
