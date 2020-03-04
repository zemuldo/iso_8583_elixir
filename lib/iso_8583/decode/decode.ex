defmodule ISO8583.Decode do
  @moduledoc false
  alias ISO8583.DataTypes
  alias ISO8583.Utils
  import ISO8583.Guards
  alias ISO8583.Message.MTI

  def decode_0_127(message, opts) do
    with {:ok, _, chunk1} <- extract_tcp_len_header(message, opts),
         {:ok, mti, chunk2} <- extract_mti(chunk1),
         {:ok, bitmap, chunk3} <- extract_bitmap(chunk2, opts),
         {:ok, decoded} <- extract_children(bitmap, chunk3, "", %{}, 0, opts) do
      {:ok, decoded |> Map.merge(%{"0": mti})}
    else
      error -> error
    end
  end

  defp extract_bitmap(message, opts) do
    case opts[:bitmap_encoding] do
      :hex -> extract_bitmap(message, opts, 16)
      _ ->extract_bitmap(message, opts, 32)
    end
  end

  defp extract_bitmap(message, _, length) do
    with {:ok, bitmap, without_bitmap} <- Utils.slice(message, 0, length),
         bitmap <- Utils.bytes_to_hex(bitmap) |> Utils.iterable_bitmap(128) do
      {:ok, bitmap, without_bitmap}
    else
      error -> error
    end
  end

  defp extract_mti(message) when has_mti(message) do

    with {:ok, mti, without_mti} <- Utils.slice(message, 0, 4),
         {:ok, _} <- MTI.is_valid(mti) do
      {:ok, mti, without_mti}
    else
      error -> error
    end
  end

  defp extract_mti(_), do: {:error, "Error while extracting MTI, Not encoded"}

  defp extract_tcp_len_header(message, opts) when has_tcp_length_indicator(message) do
    case opts[:tcp_len_header] do
      true ->
        tcp_len_header =
          message |> binary_part(0, 2) |> Utils.bytes_to_hex() |> Utils.extract_tcp_header()

        message = message |> String.slice(2..-1)
        {:ok, tcp_len_header, message}

      false ->
        {:ok, 0, message}
    end
  end

  defp extract_tcp_len_header(_, _),
    do: {:error, "Error while extracting message length indicator, Not encoded"}

  def expand_field(%{"127": data} = message, "127.", opts) do
    case expand_binary(data, "127.", opts) do
      {:ok, expanded} -> {:ok, Map.merge(message, expanded)}
      error -> error
    end
  end

  def expand_field(%{"127.25": data} = message, "127.25.", opts) do
    case expand_binary(data, "127.25.", opts) do
      {:ok, expanded} -> {:ok, Map.merge(message, expanded)}
      error -> error
    end
  end

  def expand_field(message, _, _), do: {:ok, message}

  def expand_binary(data, field_pad, opts) do
    with bitmap <- Utils.iterable_bitmap(String.slice(data, 0, 16), 64),
         {:ok, expanded} <-
           extract_children(bitmap, data |> String.slice(16..-1), field_pad, %{}, 0, opts) do
      {:ok, expanded}
    else
      error -> error
    end
  end

  defp extract_children([], _, _, extracted, _, _), do: {:ok, extracted}

  defp extract_children(bitmap, data, pad, extracted, counter, opts) do
    [current | rest] = bitmap
    field = Utils.construct_field(counter + 1, pad)

    case current do
      1 ->
        format = opts[:formats][field]
        {field_data, left} = extract_field_data(field, data, format)

        with true <- DataTypes.check_data_length(field, field_data, format),
             true <- DataTypes.valid?(field, field_data, format) do
          extracted = extracted |> Map.put(field, field_data)
          extract_children(rest, left, pad, extracted, counter + 1, opts)
        else
          error ->
            error
        end

      0 ->
        extract_children(rest, data, pad, extracted, counter + 1, opts)
    end
  end

  defp extract_field_data(_, data, nil), do: {"", data}

  defp extract_field_data(_, data, %{len_type: len_type} = format)
       when len_type == "fixed" do
    Utils.extract_hex_data(
      data,
      format.max_len,
      format.content_type
    )
  end

  defp extract_field_data(_, <<>>, _), do: {"", <<>>}

  defp extract_field_data(_, data, %{len_type: _} = format) do
    len_indicator_length = Utils.var_len_chars(format)
    length = String.slice(data, 0, len_indicator_length)
    field_data_len = String.to_integer(length)
    data = String.slice(data, len_indicator_length..-1)

    Utils.extract_hex_data(
      data,
      field_data_len,
      format.content_type
    )
  end
end
