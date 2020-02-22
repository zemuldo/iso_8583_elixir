defmodule ISO8583.Decode do
  @moduledoc false
  alias ISO8583.Utils
  alias ISO8583.Formats

  @tcp_len_header true
  @bitmap_encoding :hex

  def decode_0_127(message) do
    with {:ok, _, chunk1} <- extract_tcp_len_header(message),
         {:ok, mti, chunk2} <- extract_mti(chunk1),
         {:ok, bitmap, chunk3} <- extract_bitmap(chunk2),
         data <- extract_children(bitmap, chunk3, "", %{}, 0) do
      data |> Map.merge(%{"0": mti})
    else
      error -> error
    end
  end

  defp extract_bitmap(message) do
    case @bitmap_encoding do
      :hex ->
        bitmap =
          message
          |> :binary.part(0, 16)
          |> Utils.bytes_to_hex()
          |> bitmap_list(128)
          |> List.replace_at(0, "0")

        {:ok, bitmap, message |> String.slice(16..-1)}

      _ ->
        bitmap =
          message
          |> String.slice(0..32)
          |> bitmap_list(128)
          |> List.replace_at(0, "0")

        {:ok, bitmap, message |> String.slice(32..-1)}
    end
  end

  defp extract_mti(message) do
    mti = message |> String.slice(0, 4)
    message = message |> String.slice(4..-1)
    {:ok, mti, message}
  end

  defp extract_tcp_len_header(message) do
    case @tcp_len_header do
      true ->
        tcp_len_header =
          message |> binary_part(0, 2) |> Utils.bytes_to_hex() |> String.to_integer()

        message = message |> String.slice(2..-1)
        {:ok, tcp_len_header, message}

      false ->
        message
    end
  end

  def expand_field(%{"127": data} = message, "127.") do
    message
    |> Map.merge(expand_binary(data, "127."))
  end

  def expand_field(%{"127.25": data} = message, "127.25.") do
    message
    |> Map.merge(expand_binary(data, "127.25."))
  end

  def expand_field(message, _), do: message

  def expand_binary(data, field_pad) do
    data
    |> String.slice(0, 16)
    |> Utils.hex_to_binary()
    |> Utils.pad_string("0", 64)
    |> String.graphemes()
    |> extract_children(data |> String.slice(16..-1), field_pad, %{}, 0)
  end

  defp extract_children([], _, _, extracted, _), do: extracted

  defp extract_children(bitmap, data, pad, extracted, counter) do
    [current | rest] = bitmap
    field = Utils.construct_field(counter + 1, pad)

    case current do
      "1" ->
        {field_data, left} = extract_field_data(field, data, field |> Formats.format())
        extracted = extracted |> Map.put(field, field_data)
        extract_children(rest, left, pad, extracted, counter + 1)

      "0" ->
        extract_children(rest, data, pad, extracted, counter + 1)
    end
  end

  defp extract_field_data(_, data, nil), do: {"", data}

  defp extract_field_data(field, data, %{len_type: len_type} = format)
       when len_type == "fixed" do
    {data |> String.slice(0, format.max_len), data |> String.slice(format.max_len..-1)}
  end

  defp extract_field_data(field, data, %{len_type: len_type} = format) do
    len_indicator_length = Utils.var_len_chars(format)
    length = String.slice(data, 0, len_indicator_length)
    field_data_len = String.to_integer(length)
    data = String.slice(data, len_indicator_length..-1)
    {String.slice(data, 0, field_data_len), String.slice(data, field_data_len..-1)}
  end

  defp bitmap_list(hex_string, length) do
    hex_string
    |> Utils.hex_to_binary()
    |> Utils.pad_string("0", length)
    |> String.graphemes()
  end
end
