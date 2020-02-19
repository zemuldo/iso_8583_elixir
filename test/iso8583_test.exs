defmodule Iso8583Test do
  use ExUnit.Case
  import Iso8583.Test.Fixtures
  doctest Iso8583

  describe "Encoding message" do
    test "Encode 0100 message to binary" do
      encoded = Iso8583.encode(fixture_message(:"0100"))
      assert encoded |> byte_size() == 468
    end
  end
end
