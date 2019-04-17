defmodule Iso8583.DataTypes do
  def test?("a", character) do
    Regex.match?(~r/[a-z]/i, character)
  end

  def test?("n", character) do
    Regex.match?(~r/[0-9]/i, character)
  end

  def test?("b", character) do
    Regex.match?(~r/[0-9ABCDEF]/i, character)
  end

  def test?("p", character) do
    Regex.match?(~r/[*#]/i, character)
  end

  def test?("an", character) do
    Regex.match?(~r/[0-9a-z]/i, character)
  end

  def test?("ans", character) do
    Regex.match?(~r/[0-9a-z-!$%^&*()_+|~=`{}\[\]:";'<>?,.\/ ]/i, character)
  end

  def test?("ns", character) do
    Regex.match?(~r/[0-9-!$%^&*()_+|~=`{}\[\]:";'<>?,.\/ ]/i, character)
  end

  def test?("s", character) do
    Regex.match?(~r/[-!$%^&*()_+|~=`{}\[\]:";'<>?,.\/ ]/i, character)
  end

  def test?("anp", character) do
    Regex.match?(~r/[0-9a-z*#\x20]/i, character)
  end

  def test?("x+n", character) do
    Regex.match?(~r/[0-9a-z*#\x20]/i, character)
  end

  def test?(type, _) do
    {:error, "Data type #{type} is not implemented"}
  end

  def each(field, type, [head | tail]) do
    case test?(type, head) do
      true -> each(field, type, tail)
      false -> {:error, "While processing field #{field} data provided is not of type '#{type}'"}
      {:error, reason} -> {:error, reason}
    end
  end

  def each(_field, _type, []), do: true

  def valid?(field, type, string_data) do
    chars_list = String.graphemes(string_data)

    case String.graphemes(string_data) do
      [] -> false
      _ -> each(field, type, chars_list)
    end
  end
end
