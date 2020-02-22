defmodule ISO8583.Bitmap do
  alias ISO8583.Utils

  @message_format :map
  @moduledoc """
  This module is for building the bitmaps. It supports both Primary, Secondary and Tertiary bitmaps for fields `0-127`. You can also 
  use the same module to build bitamps for extended fields like `127.0-39` and `127.25.0-33`
  """

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
      iex>Bitmap.fields_0_127(message)
      "F40006C1A08000000000000000000000"

  """
  def fields_0_127(message) do
    create_bitmap(message, 128)
    |> List.replace_at(0, 1)
    |> ensure_127(message)
    |> Enum.join()
    |> Utils.pad_string(0, 128)
    |> Utils.binary_to_hex()
    |> Utils.pad_string("0", 32)
  end

  @doc """
  Function to create bitmap for fields 127.0-39 Takes a message `map` and creates a bitmap representing all
  the 127 extension fields 
  in the message.
  ## Examples

      iex>message = %{
      iex>"127.25": "7E1E5F7C0000000000000000200000000000000014A00000000310107C0000C2FF004934683D9B5D1447800280000000000000000410342031F024103021406010A03A42002008CE0D0C84042100000488004041709018000003276039079EDA",
      iex>}
      %{
        "127.25": "7E1E5F7C0000000000000000200000000000000014A00000000310107C0000C2FF004934683D9B5D1447800280000000000000000410342031F024103021406010A03A42002008CE0D0C84042100000488004041709018000003276039079EDA",
      }
      iex>Bitmap.fields_0_127_0_39(message)
      "0000008000000000"
  """
  def fields_0_127_0_39(message) do
    create_bitmap(message, 64, "127.")
    |> List.replace_at(0, 0)
    |> Enum.join()
    |> Utils.binary_to_hex()
    |> Utils.pad_string("0", 16)
  end

  @doc """
  Function to create bitmap for fields 127.25.0-39 Takes a message `map` and creates a bitmap representing all
  the 127.25 extension fields in the message.
  ## Examples

      iex>message = %{
      iex>"127.25.1": "7E1E5F7C00000000",
      iex>"127.25.12": "4934683D9B5D1447",
      iex>"127.25.13": "80",
      iex>"127.25.14": "0000000000000000410342031F02",
      iex>"127.25.15": "410302",
      iex>"127.25.18": "06010A03A42002",
      iex>"127.25.2": "000000002000",
      iex>"127.25.20": "008C",
      iex>"127.25.21": "E0D0C8",
      iex>"127.25.22": "404",
      iex>"127.25.23": "21",
      iex>"127.25.24": "0000048800",
      iex>"127.25.26": "404",
      iex>"127.25.27": "170901",
      iex>"127.25.28": "00000327",
      iex>"127.25.29": "60",
      iex>"127.25.3": "000000000000",
      iex>"127.25.30": "39079EDA",
      iex>"127.25.4": "A0000000031010",
      iex>"127.25.5": "7C00",
      iex>"127.25.6": "00C2",
      iex>"127.25.7": "FF00"
      iex> }
      %{
        "127.25.1": "7E1E5F7C00000000",
        "127.25.12": "4934683D9B5D1447",
        "127.25.13": "80",
        "127.25.14": "0000000000000000410342031F02",
        "127.25.15": "410302",
        "127.25.18": "06010A03A42002",
        "127.25.2": "000000002000",
        "127.25.20": "008C",
        "127.25.21": "E0D0C8",
        "127.25.22": "404",
        "127.25.23": "21",
        "127.25.24": "0000048800",
        "127.25.26": "404",
        "127.25.27": "170901",
        "127.25.28": "00000327",
        "127.25.29": "60",
        "127.25.3": "000000000000",
        "127.25.30": "39079EDA",
        "127.25.4": "A0000000031010",
        "127.25.5": "7C00",
        "127.25.6": "00C2",
        "127.25.7": "FF00"
        }
      iex>Bitmap.fields_0_127_25_0_33(message)
      "7E1E5F7C00000000"
  """
  def fields_0_127_25_0_33(message) do
    create_bitmap(message, 64, "127.25.")
    |> List.replace_at(0, 0)
    |> Enum.join()
    |> Utils.binary_to_hex()
    |> Utils.pad_string("0", 16)
  end

  defp create_bitmap(message, length) do
    List.duplicate(0, length)
    |> comprehend(message, "", length)
  end

  defp create_bitmap(message, length, field_extension) do
    List.duplicate(0, length)
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

  defp ensure_127(bitmap, %{"127.1": _}) do
    bitmap |> List.replace_at(126, 1)
  end

  defp ensure_127(bitmap, _), do: bitmap
end
