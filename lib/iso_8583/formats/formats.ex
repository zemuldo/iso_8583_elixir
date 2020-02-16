defmodule Iso8583.Formats do
  @moduledoc """
  Formats defines the default ISO 8583 formats for all supported fields.
  """
  defmacro __using__(_) do
    quote do
      use Iso8583.Formats.Definitions

      def format(field) do
        field
        |> Integer.to_string()
        |> get_format
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
        |> get_format
      end

      defp join_fields(pre, post) do
        pre <> "." <> post
      end

      defp get_format(field), do: default_formats()[field]
    end
  end
end
