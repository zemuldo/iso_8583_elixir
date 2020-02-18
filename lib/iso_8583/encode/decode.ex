defmodule Iso8583.Decode do
  alias Iso8583.Utils
  alias Iso8583.Formats

  def expand_field(%{"127": data} = message, "127.") do
    message
    |> Map.merge(expand_generic(data, "127."))
  end

  def expand_field(%{"127.25": data} = message, "127.25.") do
    message
    |> Map.merge(expand_generic(data, "127.25."))
  end

  def expand_field(_, _), do: %{}

  defp expand_generic(data, field_pad) do
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
      "0" -> extract_children(rest, data, pad, extracted, counter + 1)
    end
  end

  defp extract_field_data(_, data, nil), do: {"", data}
  defp extract_field_data(field, data, %{len_type: len_type} = format)
       when len_type == "fixed" do
    {data |>  String.slice(0, format.max_len), data |>  String.slice(format.max_len..-1)}
  end

  defp extract_field_data(field, data, %{len_type: len_type} = format) do
    len_indicator_length = Utils.var_len_chars(format)
    length = String.slice(data, 0, len_indicator_length)
    field_data_len = String.to_integer(length)
    data = String.slice(data, len_indicator_length..-1)
    {String.slice(data, 0, field_data_len), String.slice(data, field_data_len..-1)}
  end
end
