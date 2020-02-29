defmodule ISO8583.DataTypes do
  @moduledoc """
  This module provides utilities for validation `ISO 8583` field data types based the description below pulled
  from a postilion interface documentation. Each character gets validated against the regex that defines each fata type.

  - `a` - Alphabetic characters, `A` through `Z` and a through `z`
  - `n` - Numeric digits, `0` through `9`
  - `p` - Pad character, space
  - `s` - Special characters, i.e. other printable
  - `an` - Alphabetic and numeric characters
  - `as` - Alphabetic and special characters
  - `ns` - Numeric and special characters
  - `anp` - Alphabetic, numeric and pad characters
  - `ans` - Alphabetic, numeric and special characters
  - `x` `C` for credit, `D` for debit, always associated with a numeric amount field, i.e. `x+n16` means a prefix of `C` or `D` followed by `16`
  numeric characters.
  - `b` - Binary representation of data
  - `z` - `Track 2` as defined in `ISO 7813`
  """

  alias ISO8583.Formats

  defp test?("a", character) do
    Regex.match?(~r/[a-z]/i, character)
  end

  defp test?("n", character) do
    Regex.match?(~r/[0-9]/i, character)
  end

  defp test?("b", character) do
    Regex.match?(~r/[0-9ABCDEF]/i, character)
  end

  defp test?("p", character) do
    Regex.match?(~r/[*#]/i, character)
  end

  defp test?("an", character) do
    Regex.match?(~r/[0-9a-z]/i, character)
  end

  defp test?("ans", character) do
    Regex.match?(~r/[0-9a-z-!$%^&*()_+|~=`{}\[\]:";'<>?,.\/ ]/i, character)
  end

  defp test?("ns", character) do
    Regex.match?(~r/[0-9-!$%^&*()_+|~=`{}\[\]:";'<>?,.\/ ]/i, character)
  end

  defp test?("s", character) do
    Regex.match?(~r/[-!$%^&*()_+|~=`{}\[\]:";'<>?,.\/ ]/i, character)
  end

  defp test?("anp", character) do
    Regex.match?(~r/[0-9a-z*#\x20]/i, character)
  end

  defp test?("x+n", character) do
    Regex.match?(~r/[0-9CDcd*#]/i, character)
  end

  defp test?("z", _) do
    true
  end

  defp test?(type, _) do
    {:error, "Data type #{type} is not implemented"}
  end

  defp each(field, type, [head | tail]) do
    case test?(type, head) do
      true -> each(field, type, tail)
      false -> {:error, "While processing field #{field} data provided is not of type '#{type}'"}
      {:error, reason} -> {:error, reason}
    end
  end

  defp each(_field, _type, []), do: true

  defp run_validation(field, type, string_data) do
    chars_list = String.graphemes(string_data)

    case String.graphemes(string_data) do
      [] -> false
      _ -> each(field, type, chars_list)
    end
  end

  def check_data_length(field, data, %{len_type: "fixed"} = format) do
    case byte_size(data) == format.max_len do
      true ->
        true

      false ->
        {:error,
         "Invalid length of data on field #{field}, expected #{format.max_len} , found #{
           byte_size(data)
         }"}
    end
  end

  def check_data_length(field, data, %{len_type: _} = format) do
    case byte_size(data) <= format.max_len do
      true ->
        true

      false ->
        {:error,
         "Invalid length of data on field #{field}, expected maximum of #{format.max_len} , found #{
           byte_size(data)
         }"}
    end
  end

  @doc """
  Function to validate the data type in a field, returns `true` if all characters in a field matches the type otherwize return false
  ## Examples

      iex> DataTypes.valid?("2", "440044444444444", ISO8583.Formats.format(:"2"))
      true
      iex> DataTypes.valid?("2", "440044444444444R", ISO8583.Formats.format(:"2"))
      {:error, "While processing field 2 data provided is not of type 'n'"}
      iex> DataTypes.valid?("2", "44004444444444499999999", ISO8583.Formats.format(:"2"))
      {:error, "Invalid length of data on field 2, expected maximum of 19 , found 23"}

  """

  def valid?(field,string_data, %{content_type: "x+n"} = format) do
    with true <- Regex.match?(~r/[c,d]/i, String.at(string_data, 0)),
         true <- run_validation(field, "x+n", string_data),
         true <- check_data_length(field, string_data, format) do
      true
    else
      error ->
        case error do
          false -> {:error, "Data type x+n must be presceeded with c or d"}
          _ -> error
        end
    end
  end

  def valid?(field, string_data, format) do
    with true <- run_validation(field, format.content_type, string_data),
         true <- check_data_length(field, string_data, format) do
      true
    else
      error -> error
    end
  end

  @doc false
  def valid?(message, opts) do
    for {key, value} <- message do

      case valid?(key, value, opts[:formats][key]) do
        true -> true
        error -> throw(error)
      end
    end

    {:ok, message}
  catch
    error -> error
  end
end
