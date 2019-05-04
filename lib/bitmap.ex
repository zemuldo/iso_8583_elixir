defmodule Bitmap do

    alias Tools
  def base_zeros(length) do
    List.duplicate(0, length)
    |> Enum.with_index(0)
    |> Enum.map(fn {k, v} -> {v, k} end)
    |> Enum.sort_by(fn({index, _}) -> index end)
    |> Map.new()
  end

  def fields_0_127_binary(message) do
    create_bitmap(128, message, "")
    |> Tools.binary_to_hex()
  end

  def fields_127_0_63_binary(message) do
    create_bitmap(64, message, "127.")
  end

  def fields_127_25_0_25_binary(message) do
    create_bitmap(64, message, "127.25.")
  end

  defp create_bitmap(length, message, field_extension) do
    base_zeros(length)
    |> comprehend(message, field_extension)
    |> Enum.sort_by(fn({index, _}) -> index end)
    |> Enum.map(fn({_index, value}) -> value end)
    |> Enum.join()
  end

  defp comprehend(list, message, field_extension) do
    for x <- list, do: field_present(message, x, field_extension)
  end

  defp field_present(_message, {0, _value}, "") do
    {0, "1"}
  end

  defp field_present(message, {index, _value}, field_extension) do
    field = index + 1
    
    case Map.get(message, integer_to_atom(field, field_extension)) do
      nil -> 
        
        {index, "0"}
      _ -> 
       
        {index, "1"}
    end
  end

  def integer_to_atom(integer, field_extension) do
    field_extension
    |> Kernel.<>(Integer.to_string(integer))
    |> String.to_atom()
  end
end
