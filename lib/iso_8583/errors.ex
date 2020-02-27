defmodule ISO8583.Errors do
  def unknown_bitmap_encoding(encoding) do
    "Unknown bitmpa encoding #{encoding}"
  end
end
