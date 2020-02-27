defmodule ISO8583Test do
  use ExUnit.Case
  alias ISO8583.Errors
  import ISO8583.Test.Fixtures
  doctest ISO8583

  describe "Encoding message" do
    test "Encode 0100 message to binary with TCP length header" do
      {:ok, encoded} =
        fixture_message(:"0100")
        |> ISO8583.encode()

      assert encoded |> byte_size() == 468
    end

    test "Encode 0100 message to binary with utf8 encoded bitmap" do
      {:ok, encoded} =
        fixture_message(:"0100")
        |> ISO8583.encode(bitmap_encoding: :utf8)

      assert encoded |> byte_size() == 484
    end

    test "Encode 0100 message to binary with ascii encoded bitmap" do
      {:ok, encoded} =
        fixture_message(:"0100")
        |> ISO8583.encode(bitmap_encoding: :ascii)

      assert encoded |> byte_size() == 484
    end

    test "Encode 0100 message to binary with unknown bitmap" do
      {:error, error} =
        fixture_message(:"0100")
        |> ISO8583.encode(bitmap_encoding: :asciii)

      assert error == Errors.unknown_bitmap_encoding(:asciii)
    end

    test "Encode 0100 message to binary without TCP length header" do
      {:ok, encoded} =
        fixture_message(:"0100")
        |> ISO8583.encode(tcp_len_header: false)

      assert encoded |> byte_size() == 466
    end
  end
end
