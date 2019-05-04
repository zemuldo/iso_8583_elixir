defmodule Bitmap do
  @moduledoc """
  This module is for building the bitmaps. It supports both Primary, Secondary and Tertiary bitmaps for fields `0-127`. You can also 
  use the same module to build bitamps for extended fields like `127.0-63` and `127.25.0-63`
  """

  alias Tools

  defp base_zeros(length) do
    List.duplicate(0, length)
    |> Enum.with_index(0)
    |> Enum.map(fn {k, v} -> {v, k} end)
    |> Enum.sort_by(fn {index, _} -> index end)
    |> Map.new()
  end

  @doc """
  Function to create bitmap for fields 0-127. Takes a message `map` and creates a bitmap representing all fields 
  in the message. Filed 0 is turned on my default because every message must have a valid `MTI`.
  ## Examples

      iex> message = %{
      iex>"0": "1200",
      iex>"2": "4761739001010119",
      iex>"3": "000000",
      iex>"4": "000000005000",
      iex>"6": "000000005000",
      iex>"22": "051",
      iex>"23": "001",
      iex>"25": "00",
      iex>"26": "12",
      iex>"32": "423935",
      iex>"33": "111111111",
      iex>"35": "4761739001010119D22122011758928889",
      iex>"41": "12345678"
      iex>}
      %{
        "0": "1200",
        "2": "4761739001010119",
        "22": "051",
        "23": "001",
        "25": "00",
        "26": "12",
        "3": "000000",
        "32": "423935",
        "33": "111111111",
        "35": "4761739001010119D22122011758928889",
        "4": "000000005000",
        "41": "12345678",
        "6": "000000005000"
      }
      iex>Bitmap.fields_0_127_binary(message)
      "F40006C1A08000000000000000000000"

  """
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
    |> Enum.sort_by(fn {index, _} -> index end)
    |> Enum.map(fn {_index, value} -> value end)
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

  defp integer_to_atom(integer, field_extension) do
    field_extension
    |> Kernel.<>(Integer.to_string(integer))
    |> String.to_atom()
  end
end
