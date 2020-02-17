defmodule Iso8583.Test.FormatsTest do
  use ExUnit.Case

  alias Iso8583.Formats

  describe "Field Formats 0 to 128" do
    Enum.each(Enum.to_list(0..128), fn field ->
      @field field
      @filed_string field |> Integer.to_string() |> String.to_atom()
      test "Get default format field #{@filed_string}" do
        field_format = Formats.format(@field)
        assert field_format.label == Formats.default_formats()[@filed_string].label
        assert field_format.content_type == Formats.default_formats()[@filed_string].content_type
        assert field_format.len_type == Formats.default_formats()[@filed_string].len_type
        assert field_format.max_len == Formats.default_formats()[@filed_string].max_len
      end
    end)
  end

  describe "Field Formats 127.0 to 127.39" do
    Enum.each(Enum.to_list(1..39), fn field ->
      @field field
      @filed_string ("127." <> Integer.to_string(field)) |> String.to_atom()
      test "Get default format field #{@filed_string}" do
        field_format = Formats.format(127, @field)
        assert field_format.label == Formats.default_formats()[@filed_string].label
        assert field_format.content_type == Formats.default_formats()[@filed_string].content_type
        assert field_format.len_type == Formats.default_formats()[@filed_string].len_type
        assert field_format.max_len == Formats.default_formats()[@filed_string].max_len
      end
    end)
  end

  describe "Field Formats 127.25.0 to 127.25.33" do
    Enum.each(Enum.to_list(1..33), fn field ->
      @field field
      @filed_string ("127.25." <> Integer.to_string(field)) |> String.to_atom()
      test "Get default format field #{@filed_string}" do
        field_format = Formats.format(127, 25, @field)
        assert field_format.label == Formats.default_formats()[@filed_string].label
        assert field_format.content_type == Formats.default_formats()[@filed_string].content_type
        assert field_format.len_type == Formats.default_formats()[@filed_string].len_type
        assert field_format.max_len == Formats.default_formats()[@filed_string].max_len
      end
    end)
  end
end
