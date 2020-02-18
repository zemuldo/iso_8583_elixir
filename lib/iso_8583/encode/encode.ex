defmodule Iso8583.Encode do
  @bitmap_encoding :hex
  @len_header true

  @sample_message %{
    "0" => "0800",
    "7" => "0818160244",
    "11" => "646465",
    "12" => "160244",
    "13" => "0818",
    "70" => "001"
  }

  @sample_message_2 %{
    "0": "0100",
    "2": "5413330",
    "3": "000000",
    "4": "000000002000",
    "7": "0210160607",
    "11": "148893",
    "12": "160607",
    "13": "0210",
    "14": "2512",
    "18": "4111",
    "22": "141",
    "23": "003",
    "25": "00",
    "26": "12",
    "35": "5413330089020011D2512601079360805F",
    "41": "31327676",
    "42": "4D4F424954494C4",
    "43": "My Termianl Business                    ",
    "49": "404",
    "45": "0303030204E4149524F4249204B452dataString04B45",
    "123": "09010001000105010103040C010001"
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

    message
    |> Bitmap.create_bitmap(128)
    |> loop_bitmap(message, message[:"0"])
    |> Utils.encode_tcp_header()
  end

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
    encode_length_indicator(field, data, format)
  end

  defp encode_length_indicator(field, data, %{len_type: len_type} = format)
       when len_type == "fixed" do
    data |> encode_data(format.content_type)
  end

  defp encode_data(data, content_type) do
    case content_type do
      "b" -> Utils.hex_to_bytes(data)
      _ -> data
    end
  end

  defp encode_length_indicator(field, data, format) do
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
