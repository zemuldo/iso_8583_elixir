defmodule Iso8583.Test.FormatsTest do
  use ExUnit.Case

  describe "Field Formats 0 to 128" do
    Enum.each(Enum.to_list(0..128), fn field ->
      @field field
      @filed_string field |> Integer.to_string()
      test "Get default format field #{@filed_string}" do
        field_0 = Iso8583.format(@field)
        assert field_0[:label] == Iso8583.default_formats()[@filed_string].label
        assert field_0[:content_type] == Iso8583.default_formats()[@filed_string].content_type
        assert field_0[:len_type] == Iso8583.default_formats()[@filed_string].len_type
        assert field_0[:max_len] == Iso8583.default_formats()[@filed_string].max_len
      end
    end)
  end

  describe "Field Formats 127.0 to 127.39" do
    Enum.each(Enum.to_list(1..39), fn field ->
      @field field
      @filed_string "127." <> Integer.to_string(field)
      test "Get default format field #{@filed_string}" do
        field_0 = Iso8583.format(127, @field)
        assert field_0[:label] == Iso8583.default_formats()[@filed_string].label
        assert field_0[:content_type] == Iso8583.default_formats()[@filed_string].content_type
        assert field_0[:len_type] == Iso8583.default_formats()[@filed_string].len_type
        assert field_0[:max_len] == Iso8583.default_formats()[@filed_string].max_len
      end
    end)
  end

  describe "Field Formats 127.25.0 to 127.25.33" do
    Enum.each(Enum.to_list(1..33), fn field ->
      @field field
      @filed_string "127.25." <> Integer.to_string(field)
      test "Get default format field #{@filed_string}" do
        field_0 = Iso8583.format(127, 25, @field)
        assert field_0[:label] == Iso8583.default_formats()[@filed_string].label
        assert field_0[:content_type] == Iso8583.default_formats()[@filed_string].content_type
        assert field_0[:len_type] == Iso8583.default_formats()[@filed_string].len_type
        assert field_0[:max_len] == Iso8583.default_formats()[@filed_string].max_len
      end
    end)
  end
end
