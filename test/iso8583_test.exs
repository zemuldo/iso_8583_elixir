defmodule Iso8583Test do
  use ExUnit.Case
  doctest Iso8583

  test "greets the world" do
    assert Iso8583.main() == :iso_8583_coming_soon
  end
end
