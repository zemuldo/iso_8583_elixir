defmodule Tools do

  use Timex

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

  def create_bitmap_array(length) do
    List.duplicate(0, length)
  end

  def padd_chars(string, pad_length, pad_char) do
    string_length = String.length(string)
    case string_length < pad_length do
      true ->
        List.duplicate(pad_char, pad_length - string_length)
          |> Enum.join()
          |> Kernel.<>(string)
      _ -> string
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
    Map.merge(message,%{"7": extract_date_time(timestamp), "12": extract_time(timestamp)})
  end

  def attach_timestamps(message, timestamp) do
    Map.merge(message,%{"7": extract_date_time(timestamp), "12": extract_time(timestamp)})
  end
end
