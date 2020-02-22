defmodule Iso8583.Formats do
  @moduledoc """
  Formats defines the default ISO 8583 formats for all supported fields.
  """
  use Iso8583.Formats.Definitions

  @doc """
  Get the format for a field using string.
  ## Examples

      iex>Formats.format("1")
      %{content_type: "b", label: "Bitmap", len_type: "fixed", max_len: 8}
      iex>Formats.format(1)
      %{content_type: "b", label: "Bitmap", len_type: "fixed", max_len: 8}
      iex>Formats.format(127, 25)
      %{
          min_len: 1000,
          content_type: "ans",
          label: "Integrated circuit card (ICC) Data",
          len_type: "llllvar",
          max_len: 8000
      }
      iex>Formats.format(127, 25, 20)
      %{
          content_type: "ans",
          label: "Terminal Application Version Number",
          len_type: "fixed",
          max_len: 4
      }
  """
  def format(field) when is_integer(field) do
    field
    |> Integer.to_string()
    |> get_format()
  end

   @doc """
  Get the format for a field, using atom.
  ## Examples

      iex>Formats.format(:"1")
      %{content_type: "b", label: "Bitmap", len_type: "fixed", max_len: 8}
  """

  def format(field) when is_atom(field) do
    field
    |> get_format()
  end

  def format(field) do
    field
    |> get_format()
  end

  @doc """
  Get the format for a sub field.
  ## Examples

      iex>Formats.format(127, 25)
      %{
          min_len: 1000,
          content_type: "ans",
          label: "Integrated circuit card (ICC) Data",
          len_type: "llllvar",
          max_len: 8000
      }
  """

  def format(field, extension) do
    field
    |> Integer.to_string()
    |> join_fields(extension |> Integer.to_string())
    |> get_format
  end

  @doc """
  Get the format for a child of a sub field.
  ## Examples

      iex>Formats.format(127, 25, 20)
      %{
          content_type: "ans",
          label: "Terminal Application Version Number",
          len_type: "fixed",
          max_len: 4
      }
  """

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

  defp get_format(field) when is_atom(field), do: formats_definitions()[field]
  defp get_format(field) when is_binary(field), do: formats_definitions()[field |> String.to_atom()]
end
