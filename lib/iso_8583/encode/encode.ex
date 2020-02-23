defmodule ISO8583.Encode do
  @moduledoc false

  alias ISO8583.Bitmap
  alias ISO8583.Utils
  alias ISO8583.Decode

  def encode_0_127(message, opts) do
    message =
      message
      |> Map.put(:"1", Bitmap.fields_0_127(message))
      |> Decode.expand_field("127.", opts)
      |> Decode.expand_field("127.25.", opts)
      |> encoding_extensions(:"127.25", opts)
      |> encoding_extensions(:"127", opts)

    message
    |> Bitmap.fields_0_127()
    |> Utils.hex_to_binary()
    |> Utils.pad_string("0", 64)
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> loop_bitmap(message, message[:"0"], <<>>, 0, opts)
    |> Utils.encode_tcp_header()
  end

  def encoding_extensions(%{"127.25.1": _} = message, :"127.25", opts) do
    data =
      message[:"127.25.1"]
      |> Utils.hex_to_binary()
      |> Utils.pad_string("0", 64)
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> loop_bitmap(message, message[:"127.25.1"], "127.25.", 0, opts)
      |> encode_length_indicator("127.25", opts.formats[:"127.25"])

    Map.merge(message, %{"127.25": data})
  end

  def encoding_extensions(%{"127.1": _} = message, :"127", opts) do
    data =
      message[:"127.1"]
      |> Utils.hex_to_binary()
      |> Utils.pad_string("0", 64)
      |> String.graphemes()
      |> Enum.map(fn n -> String.to_integer(n) end)
      |> loop_bitmap(message, message[:"127.1"], "127.", 0, opts)

    Map.merge(message, %{"127": data})
  end

  def encoding_extensions(message, _, _), do: message

  defp loop_bitmap([], _, encoded, _, _, _), do: encoded

  defp loop_bitmap(bitmap, message, encoded, field_pad, counter, opts) do
    [current | rest_bitmaps] = bitmap

    case current do
      1 ->
        field = Utils.construct_field(counter + 1, field_pad)
        data = message[field]
        new_encoded = encoded <> encode_field(field, data, opts)
        loop_bitmap(rest_bitmaps, message, new_encoded, field_pad, counter + 1, opts)

      0 ->
        loop_bitmap(rest_bitmaps, message, encoded, field_pad, counter + 1, opts)
    end
  end

  defp encode_field(field, data, opts) do
    format = opts.formats[field]
    encode_length_indicator(data, field, format)
  end

  defp encode_length_indicator(data, _, %{len_type: len_type} = format)
       when len_type == "fixed" do
    data |> encode_data(format.content_type)
  end

  defp encode_length_indicator(data, _, format) do
    max_len_chars = format |> get_len_type |> byte_size()

    byte_size(data)
    |> Integer.to_string()
    |> Utils.padd_chars(max_len_chars, "0")
    |> Kernel.<>(data |> encode_data(format.content_type))
  end

  defp encode_data(data, content_type) do
    case content_type do
      "b" -> Utils.hex_to_bytes(data)
      _ -> data
    end
  end

  defp get_len_type(%{len_type: len_type}) do
    [type | _] = len_type |> String.split("var")
    type
  end
end
