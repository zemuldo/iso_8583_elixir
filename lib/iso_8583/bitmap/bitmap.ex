defmodule Iso8583.Bitmap do
  @moduledoc """
  This module is for building the bitmaps. It supports both Primary, Secondary and Tertiary bitmaps for fields `0-127`. You can also 
  use the same module to build bitamps for extended fields like `127.0-63` and `127.25.0-63`
  """

  alias Iso8583.Utils

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

  # TODO: Configurable message format

  @message_format :map
  def fields_0_127_binary(message) do
    create_bitmap(message, 128)
    |> Enum.join()
    |> Utils.binary_to_hex()
  end

  def fields_127_0_63_binary(message) do
    create_bitmap(message, 64, "127.")
    |> Enum.join()
    |> Utils.binary_to_hex()
  end

  def fields_127_25_0_25_binary(message) do
    create_bitmap(message, 64, "127.25.")
    |> Enum.join()
    |> Utils.binary_to_hex()
  end

  def create_bitmap(message, length) do
    List.duplicate(0, length)
    |> List.replace_at(0, 1)
    |> comprehend(message, "", length)
  end

  def create_bitmap(message, length, field_extension) do
    List.duplicate(0, length)
    |> List.replace_at(0, 1)
    |> comprehend(message, field_extension, length)
  end

  defp comprehend(list, message, field_extension, length, iteration \\ 0)

  defp comprehend(list, _, _, length, iteration) when iteration == length do
    list
  end

  defp comprehend(list, message, field_extension, length, iteration) do
    field = build_field(field_extension, iteration + 1)

    case Map.get(message, field) do
      nil ->
        list
        |> comprehend(message, field_extension, length, iteration + 1)

      _ ->
        list
        |> List.replace_at(iteration, 1)
        |> comprehend(message, field_extension, length, iteration + 1)
    end
  end

  defp build_field(extension, field) do
    case @message_format do
      :map ->
        extension
        |> Kernel.<>(Integer.to_string(field))
        |> String.to_atom()

      :json ->
        extension <> Integer.to_string(field)
    end
  end
end
