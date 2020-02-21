defmodule Iso8583.Utils do

  @moduledoc false
  
  def binary_to_hex(string) do
    case Integer.parse(string, 2) do
      :error -> {:error, "Binary string is not valid"}
      {decimal_no, _} -> Integer.to_string(decimal_no, 16)
    end
  end

  def hex_to_binary(string) do
    case Integer.parse(string, 16) do
      :error -> {:error, "Hexadecimal string is not valid"}
      {decimal_no, _} -> Integer.to_string(decimal_no, 2)
    end
  end

  def hex_to_bytes(hexa_string) do
    hexa_string
    |> Base.decode16!()
  end

  def bytes_to_hex(hexa_string) do
    hexa_string
    |> Base.encode16()
  end

  def create_bitmap_array(length) do
    List.duplicate(0, length) |> List.replace_at(0, 1)
  end

  def padd_chars(string, pad_length, pad_char) do
    string_length = String.length(string)

    case string_length < pad_length do
      true ->
        List.duplicate(pad_char, pad_length - string_length)
        |> Enum.join()
        |> Kernel.<>(string)

      _ ->
        string
    end
  end

  def extract_date_time(timestamp) do
    padd_chars(Integer.to_string(timestamp.month), 2, "0")
    |> Kernel.<>(padd_chars(Integer.to_string(timestamp.day), 2, "0"))
    |> Kernel.<>(padd_chars(Integer.to_string(timestamp.hour), 2, "0"))
    |> Kernel.<>(padd_chars(Integer.to_string(timestamp.minute), 2, "0"))
    |> Kernel.<>(padd_chars(Integer.to_string(timestamp.second), 2, "0"))
  end

  def extract_time(timestamp) do
    padd_chars(Integer.to_string(timestamp.hour), 2, "0")
    |> Kernel.<>(padd_chars(Integer.to_string(timestamp.minute), 2, "0"))
    |> Kernel.<>(padd_chars(Integer.to_string(timestamp.second), 2, "0"))
  end

  def attach_timestamps(message) do
    timestamp = DateTime.utc_now()
    Map.merge(message, %{"7": extract_date_time(timestamp), "12": extract_time(timestamp)})
  end

  def attach_timestamps(message, timestamp) do
    Map.merge(message, %{"7": extract_date_time(timestamp), "12": extract_time(timestamp)})
  end

  def atomify_map(map) do
    atomkeys = fn {k, v}, acc ->
      Map.put_new(acc, atomize_binary(k), v)
    end

    Enum.reduce(map, %{}, atomkeys)
  end

  defp atomize_binary(value) do
    if is_binary(value), do: String.to_atom(value), else: value
  end

  def construct_field(field, pad) when is_integer(field) do
    pad
    |> Kernel.<>(Integer.to_string(field))
    |> String.to_atom()
  end

  def construct_field(field, pad) when is_binary(field) do
    pad
    |> Kernel.<>(field)
    |> String.to_atom()
  end

  def encode_tcp_header(data) do
    length = byte_size(data)
    part_1 = div(length, 256) |> Integer.to_string(16) |> pad_string("0", 2) |> hex_to_bytes()
    part_2 = rem(length, 256) |> Integer.to_string(16) |> pad_string("0", 2) |> hex_to_bytes()

    part_1 <> part_2 <> data
  end

  def pad_string(string, pad, max) do
    current_size = byte_size(string)

    case current_size < max do
      true ->
        List.duplicate(pad, max - current_size)
        |> Enum.join()
        |> Kernel.<>(string)

      false ->
        string
    end
  end

  def var_len_chars(%{len_type: len_type}) do
    [type | _] = len_type |> String.split("var")
    byte_size(type)
  end
end
