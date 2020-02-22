defmodule ISO8583Test do
  use ExUnit.Case
  import ISO8583.Test.Fixtures
  doctest ISO8583

  describe "Encoding message" do
    test "Encode 0100 message to binary" do
      encoded = ISO8583.encode(fixture_message(:"0100"))
      assert encoded |> byte_size() == 468
    end
  end
end
