defmodule ISO8583Test do
  use ExUnit.Case
  import ISO8583.Test.Fixtures
  doctest ISO8583

  # Encoding message
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
        |> ISO8583.encode(static_meta: "BITCOIN-INTERCHANGE")

      assert encoded |> byte_size() == 487
    end

    test "Encode 0100 message to binary with Static meta data" do
      {:ok, encoded} =
        fixture_message(:"0100")
        |> ISO8583.encode(tcp_len_header: false)

      assert encoded |> byte_size() == 466
    end

    test "Encode 0100 message to binary custom formats" do
      custome_format = %{
        "2": %{
          content_type: "n",
          label: "Primary account number (PAN)",
          len_type: "llvar",
          max_len: 30,
          min_len: 1
        }
      }

      {:ok, encoded} =
        fixture_message(:"0100")
        |> Map.put(:"2", "444466668888888888888888")
        |> ISO8583.encode(formats: custome_format)

      assert encoded |> byte_size() == 476
    end

    test "Encode 0100 message to binary invalid data" do
      {:error, message} =
        fixture_message(:"0100")
        |> Map.put(:"2", "444466668888888888888888")
        |> ISO8583.encode()

      assert message == "Invalid length of data on field 2, expected maximum of 19, but got 24"
    end
  end

  # Decoding message
  describe "Decoding message" do
    test "fail to decode invalid message no length indicatpor" do
      {:error, message} = "" |> ISO8583.decode()
      assert message == "Error while extracting message length indicator, Not encoded"
    end

    test "fail to decode invalid message no MTI" do
      {:error, message} = <<0, 49>> |> ISO8583.decode()
      assert message == "Error while extracting MTI, Not encoded"
    end

    test "fail to decode invalid MTI" do
      {:error, message} = (<<0, 49>> <> "3200") |> ISO8583.decode()
      assert message == "Unknow MTI 3200"
    end

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

    test "decode 0800 message static meta" do
      message = fixture_message(:"0800")
      {:ok, encoded} = message |> ISO8583.encode(static_meta: "BITCOIN-INTERCHANGE")
      {:ok, decoded} = encoded |> ISO8583.decode(static_meta: "BITCOIN-INTERCHANGE")
      assert MapSet.subset?(MapSet.new(message), MapSet.new(decoded))
      assert MapSet.subset?(MapSet.new(decoded), MapSet.new(message))
      assert message == decoded
      assert decoded == message
    end

    test "decode 0800 message with no tcp length header" do
      message = fixture_message(:"0800")
      {:ok, encoded} = message |> ISO8583.encode(tcp_len_header: false)
      {:ok, decoded} = encoded |> ISO8583.decode(tcp_len_header: false)
      assert MapSet.subset?(MapSet.new(message), MapSet.new(decoded))
      assert MapSet.subset?(MapSet.new(decoded), MapSet.new(message))
      assert message == decoded
      assert decoded == message
    end

    test "decode 0100 message to binary custom formats" do
      custome_format = %{
        "2": %{
          content_type: "n",
          label: "Primary account number (PAN)",
          len_type: "llvar",
          max_len: 30,
          min_len: 1
        }
      }

      message = fixture_message(:"0100") |> Map.put(:"2", "444466668888888888888888")
      {:ok, encoded} = message |> ISO8583.encode(formats: custome_format)
      {:ok, decoded} = encoded |> ISO8583.decode(formats: custome_format)

      assert MapSet.subset?(MapSet.new(message), MapSet.new(decoded))
      assert MapSet.subset?(MapSet.new(decoded), MapSet.new(message))
      assert message == decoded
      assert decoded == message
    end
  end

  # Validate message
  describe "Validate message" do
    test "Valid message" do
      assert fixture_message(:"0100") |> ISO8583.valid?()
    end

    test "Invalid message, invalid length of data, boolean" do
      refute fixture_message(:"0100")
             |> Map.put(:"2", "444466668888888888888888")
             |> ISO8583.valid?()
    end

    test "Invalid message, wrong type of data, boolean" do
      refute fixture_message(:"0100") |> Map.put(:"2", "4444666688888R") |> ISO8583.valid?()
    end

    test "Invalid message, invalid length of data, error" do
      error =
        fixture_message(:"0100") |> Map.put(:"2", "444466668888888888888888") |> ISO8583.valid()

      assert error ==
               {:error, "Invalid length of data on field 2, expected maximum of 19 , found 24"}
    end

    test "Invalid message, wrong type of data, error" do
      error = fixture_message(:"0100") |> Map.put(:"2", "4444666688888R") |> ISO8583.valid()
      assert error == {:error, "While processing field 2 data provided is not of type 'n'"}
    end

    test "Valid encoded message, " do
      {:ok, message} = fixture_message(:"0100") |> ISO8583.encode()
      assert ISO8583.valid?(message)
    end

    test "Invalid encoded message, invalid length of data, boolean" do
      custome_format = %{
        "2": %{
          content_type: "n",
          label: "Primary account number (PAN)",
          len_type: "llvar",
          max_len: 30,
          min_len: 1
        }
      }

      {:ok, message} =
        fixture_message(:"0100")
        |> Map.put(:"2", "444466668888888888888888")
        |> ISO8583.encode(formats: custome_format)

      refute message |> ISO8583.valid?()
    end

    test "Invalid encoded message, invalid length of data, error" do
      custome_format = %{
        "2": %{
          content_type: "n",
          label: "Primary account number (PAN)",
          len_type: "llvar",
          max_len: 30,
          min_len: 1
        }
      }

      {:ok, message} =
        fixture_message(:"0100")
        |> Map.put(:"2", "444466668888888888888888")
        |> ISO8583.encode(formats: custome_format)

      assert message |> ISO8583.valid() ==
               {:error, "Invalid length of data on field 2, expected maximum of 19 , found 24"}
    end
  end
end
