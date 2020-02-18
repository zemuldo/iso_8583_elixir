defmodule Iso8583.Encode do
  @bitmap_encoding :hex
  @len_header true

  @expanded %{
    "0": "0100",
    "2": "4761739001010119",
    "3": "000000",
    "4": "000000005000",
    "7": "0911131411",
    "12": "131411",
    "13": "0911",
    "14": "2212",
    "18": "4111",
    "22": "051",
    "23": "001",
    "25": "00",
    "26": "12",
    "32": "423935",
    "33": "111111111",
    "35": "4761739001010119D22122011758928889",
    "41": "12345678",
    "42": "MOTITILL_000001",
    "43": "My Termianl Business                    ",
    "49": "404",
    "52": "7434F67813BAE545",
    "56": "1510",
    "123": "91010151134C101",
    "127.1": "0000008000000000",
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

  alias Iso8583.Bitmap
  alias Iso8583.Utils
  alias Iso8583.Formats
  alias Iso8583.Encode.TCPLenHeader
  alias Iso8583.Decode

  def call(message) do
    message
    |> Utils.atomify_map()
    |> encode_0_127()
  end

  defp encode_0_127(message) do

    message =
      message
      |> Map.put(:"1", Bitmap.fields_0_127_binary(message))
      |> Decode.expand_field("127.")
      |> Decode.expand_field("127.25.")
      |> encoding_extensions(:"127.25")
      |> encoding_extensions(:"127")

    message
    |> Bitmap.fields_0_127_binary()
    |> Utils.hex_to_binary()
    |> Utils.pad_string("0", 64)
    |> String.graphemes()
    |> Enum.map(fn n -> String.to_integer(n) end)
    |> loop_bitmap(message, message[:"0"])
    |> Utils.encode_tcp_header()
  end

  def encoding_extensions(%{"127.25.1": _} = message, :"127.25") do
    data = message[:"127.25.1"]
    |> Utils.hex_to_binary()
    |> Utils.pad_string("0", 64)
    |> String.graphemes()
    |> Enum.map(fn n -> String.to_integer(n) end)
    |> loop_bitmap(message, message[:"127.25.1"], "127.25.")
    |> encode_length_indicator("127.25", Formats.format(:"127.25"))
    
    Map.merge(message, %{"127.25": data})
  end

  def encoding_extensions(%{"127.1": _} = message, :"127") do
    data = message[:"127.1"]
    |> Utils.hex_to_binary()
    |> Utils.pad_string("0", 64)
    |> String.graphemes()
    |> Enum.map(fn n -> String.to_integer(n) end)
    |> loop_bitmap(message, message[:"127.1"], "127.")

    Map.merge(message, %{"127": data})
  end

  def encoding_extensions(message, _), do: message

  defp encode_with_extensions(_, rest_bitmaps, message, new_encoded, field_pad, counter), do: message

  defp loop_bitmap(bitmap, message, encoded \\ <<>>, field_pad \\ <<>>, counter \\ 0)
  defp loop_bitmap([], _, encoded, _, _), do: encoded

  defp loop_bitmap(bitmap, message, encoded, field_pad, counter) do
    [current | rest_bitmaps] = bitmap

    case current do
      1 ->
        field = Utils.construct_field(counter + 1, field_pad)
        data = message[field]
        new_encoded = encoded <> encode_field(field, data)
        loop_bitmap(rest_bitmaps, message, new_encoded, field_pad, counter + 1)

      0 ->
        loop_bitmap(rest_bitmaps, message, encoded, field_pad, counter + 1)
    end
  end

  defp encode_field(field, data) do
    format = field |> Formats.format()
    encode_length_indicator(data, field, format)
  end

  defp encode_length_indicator(data, field, %{len_type: len_type} = format)
       when len_type == "fixed" do
    data |> encode_data(format.content_type)
  end

  defp encode_data(data, content_type) do
    case content_type do
      "b" -> Utils.hex_to_bytes(data)
      _ -> data
    end
  end

  defp encode_length_indicator(data, field, format) do
    max_len_chars = format |> get_len_type |> byte_size()

    byte_size(data)
    |> Integer.to_string()
    |> Utils.padd_chars(max_len_chars, "0")
    |> Kernel.<>(data |> encode_data(format.content_type))
  end

  defp get_len_type(%{len_type: len_type}) do
    [type | _] = len_type |> String.split("var")
    type
  end
end
