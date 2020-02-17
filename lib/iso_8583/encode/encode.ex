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

  alias Iso8583.Bitmap
  alias Iso8583.Utils
  alias Iso8583.Formats
  alias Iso8583.Encode.TCPLenHeader

  def call(message) do
    @sample_message
    |> Utils.atomify_map()
    |> encode_0_127()
  end

  defp encode_0_127(message) do
    bitmap = Bitmap.fields_0_127_binary(message)
    [mti_bitmap | rest] = Bitmap.create_bitmap(message, 128)
    
    message[:"0"]
    |> Kernel.<>(Utils.hex_to_bytes(bitmap))
    |> Kernel.<>(rest |> loop_bitmap(message))
    |> Utils.encode_tcp_header()
  end

  defp loop_bitmap(bitmap, message, encoded \\ <<>>, field_pad \\ <<>>, counter \\ 1)
  defp loop_bitmap([], _, encoded, _, _), do: encoded
  defp loop_bitmap(bitmap, message, encoded, field_pad, counter) do
    [current | rest_bitmaps] = bitmap
    case current do
        1 -> 
            field = Utils.construct_field(counter + 1, field_pad) |> IO.inspect
            data = message[field] |> IO.inspect
            new_encoded = encoded <> encode_field(field, data)
            loop_bitmap(rest_bitmaps, message, new_encoded, field_pad, counter + 1)
        0 -> loop_bitmap(rest_bitmaps, message, encoded, field_pad, counter + 1)
    end
  end

  defp encode_field(field, data) do
    format = field |> Iso8583.Formats.format()
    encode_length_indicator(field, data, format)
  end

  defp encode_length_indicator(field, data, %{len_type: len_type} = format) when len_type == "fixed" do
    data
  end

  defp encode_length_indicator(field, data, format) do
    actual_len = byte_size(data)
    len = format |> get_len_type |> byte_size()
    pad = len - actual_len
    len_indicator = List.duplicate(0, pad) |> Enum.join()
    len_indicator <> data
  end

  defp get_len_type(%{len_type: len_type}) do
    [type | _] = len_type |> String.split("var")
  end
end
