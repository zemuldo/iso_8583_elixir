defmodule DataTypes do
  @moduledoc """
  This module provides utilities for validation ISO 8583 field data types based the description below pulled
  from a postilion interface documentation. Each character gets validated against the regex that defines each fata type.

  - a - Alphabetic characters, A through Z and a through z
  - n - Numeric digits, 0 through 9
  - p - Pad character, space
  - s - Special characters, i.e. other printable
  - an - Alphabetic and numeric characters
  - as - Alphabetic and special characters
  - ns - Numeric and special characters
  - anp - Alphabetic, numeric and pad characters
  - ans - Alphabetic, numeric and special characters
  - x C for credit, D for debit, always associated with a numeric amount field, i.e. x+n16 means a prefix of C or D followed by 16
  numeric characters.
  - b - Binary representation of data
  - z - Track 2 as defined in ISO 7813
  """

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
    Regex.match?(~r/[0-9a-z*#\x20]/i, character)
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

  @doc """

  ## Examples

      iex> DataTypes.valid?("67", "x+n", "cAAAssdsd")
      true
      iex> DataTypes.valid?("67", "x+n", "AAAs&sdsd")
      {:error, "Data type x+n must be presceeded with c or d"}
      iex> DataTypes.valid?("67", "x+n", "c%%")
      {:error, "While processing field 67 data provided is not of type 'x+n'"}

  """

  def valid?(field, "x+n", string_data) do
    case Regex.match?(~r/[c,d]/i, String.at(string_data, 0)) do
      true -> run_validation(field, "x+n", string_data)
      false -> {:error, "Data type x+n must be presceeded with c or d"}
    end
  end

  def valid?(field, type, string_data) do
    run_validation(field, type, string_data)
  end
end
