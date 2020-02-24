defmodule ISO8583Test do
  use ExUnit.Case
  import ISO8583.Test.Fixtures
  doctest ISO8583

  describe "Encoding message" do
    test "Encode 0100 message to binary with TCP length header" do
      encoded =
        fixture_message(:"0100")
        |> ISO8583.encode()

      assert encoded |> byte_size() == 468
    end

    # test "Encode 0100 message to binary with utf8 encoded bitmap" do
    #   encoded =
    #     fixture_message(:"0100")
    #     |> ISO8583.encode(bitmap_encoding: :utf8)

    #   assert encoded |> byte_size() == 468
    # end

    # test "Encode 0100 message to binary without TCP length header" do
    #   encoded =
    #     fixture_message(:"0100")
    #     |> ISO8583.encode(tcp_len_header: false)

    #   assert encoded |> byte_size() == 466
    # end
  end
end
