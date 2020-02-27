defmodule ISO8583Test do
  use ExUnit.Case
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

    test "Encode 0100 message to binary without TCP length header" do
      {:ok, encoded} =
        fixture_message(:"0100")
        |> ISO8583.encode(tcp_len_header: false)

      assert encoded |> byte_size() == 466
    end
  end

  describe "Decoding message" do
    test "decode 0100 message" do
      message = fixture_message(:"0100")
      {:ok, encoded} = message |> ISO8583.encode()
      {:ok, decoded} = encoded |> ISO8583.decode()
      assert MapSet.subset?(MapSet.new(message), MapSet.new(decoded))
      assert MapSet.subset?(MapSet.new(decoded), MapSet.new(message))
      assert message == decoded
      assert decoded == message
    end

    test "decode 0800 message" do
      message = fixture_message(:"0800")
      {:ok, encoded} = message |> ISO8583.encode()
      {:ok, decoded} = encoded |> ISO8583.decode()
      assert MapSet.subset?(MapSet.new(message), MapSet.new(decoded))
      assert MapSet.subset?(MapSet.new(decoded), MapSet.new(message))
      assert message == decoded
      assert decoded == message
    end
  end
end
