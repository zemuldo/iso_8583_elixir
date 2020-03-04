defmodule ISO8583.Utils do
  @moduledoc false

  def slice(payload, lower, upper) when byte_size(payload) > lower and upper < 0 do
    <<lower_part::binary-size(lower), upper_part::binary>> = payload
    {:ok, lower_part, upper_part}
  end

  def slice(payload, lower, upper) when byte_size(payload) >= upper do
    lower_part =
      payload
      |> binary_part(lower, upper)

    <<_::binary-size(upper), upper_part::binary>> = payload
    {:ok, lower_part, upper_part}
  end

  def encode_bitmap(bitmap, encoding) do
    case encoding do
      :hex -> bitmap |> hex_to_bytes()
      _ -> bitmap
    end
  end

  def iterable_bitmap(hex, length) do
    hex
    |> hex_to_binary()
    |> pad_string("0", length)
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> List.replace_at(0, 0)
  end

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

  def extract_tcp_header(hex) do
    part_1 = hex |> String.slice(0..1) |> String.to_integer(16)
    part_2 = hex |> String.slice(2..4) |> String.to_integer(16)

    256 * part_1 + part_2
  end

  def extract_hex_data(message, length, "b") do
    extracted = message |> binary_part(0, div(length, 2)) |> bytes_to_hex()
    rem = message |> String.slice(div(length, 2)..-1)
    {extracted, rem}
  end

  def extract_hex_data(message, length, _) do
    extracted = message |> String.slice(0, length)
    rem = message |> String.slice(length..-1)
    {extracted, rem}
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

  def check_data_length(field, data, max_len) do
    case byte_size(data) <= max_len do
      true ->
        :ok

      false ->
        {:error,
         "Error while decoding field #{field}, data exceeds configured length, expected maximum of #{
           max_len
         } but found #{byte_size(data)}"}
    end
  end
end
