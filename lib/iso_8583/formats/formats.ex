defmodule Iso8583.Formats do
  @moduledoc """
  Formats defines the default ISO 8583 formats for all supported fields.
  """
  use Iso8583.Formats.Definitions

  def format(field) when is_integer(field) do
    field
    |> Integer.to_string()
    |> get_format()
  end

  def format(field) when is_atom(field) do
    field
    |> get_format()
  end

  def format(field) do
    field
    |> get_format()
  end

  def format(field, extension) do
    field
    |> Integer.to_string()
    |> join_fields(extension |> Integer.to_string())
    |> get_format
  end

  def format(field, sub_field, extension) do
    field
    |> Integer.to_string()
    |> join_fields(sub_field |> Integer.to_string())
    |> join_fields(extension |> Integer.to_string())
    |> get_format()
  end

  defp join_fields(pre, post) do
    pre <> "." <> post
  end

  defp get_format(field) when is_atom(field), do: default_formats()[field]
  defp get_format(field) when is_binary(field), do: default_formats()[field |> String.to_atom()]
end
