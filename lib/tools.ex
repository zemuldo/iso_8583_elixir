defmodule Tools do
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
end
