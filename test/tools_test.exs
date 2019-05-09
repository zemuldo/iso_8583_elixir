defmodule ToolsTest do
  use ExUnit.Case
  doctest Tools
  test "should convert hexadecimal to binary" do
    assert Tools.hex_to_binary("0123456789ABCDEF") == "100100011010001010110011110001001101010111100110111101111"
  end

  test "should convert hexadecimal to binary, ignore last characters that are invalid" do
    assert Tools.hex_to_binary("FKKKK%") == "1111"
  end

  test "should fail to convert hexadecimal to binary" do
    assert Tools.hex_to_binary("K2343ABCE") == {:error, "Hexadecimal string is not valid"}
  end

  test "should convert binary to hexadecimal" do
    assert Tools.binary_to_hex("100100011010001010110011110001001101010111100110111101111") == "123456789ABCDEF"
  end

  test "should fail to convert binary to hexadecimal" do
    assert Tools.binary_to_hex("K2343ABCE") == {:error, "Binary string is not valid"}
  end

  test "should append the right timestamp to message" do
    timestamp = DateTime.from_naive!(~N[2018-11-15 11:01:30], "Etc/UTC")
    message = %{
      "0": "1200",
      "2": "4761739001010119",
      "3": "000000",
      "4": "000000005000",
      "6": "000000005000",
      "22": "051",
      "23": "001",
      "25": "00",
      "26": "12",
      "32": "423935",
      "33": "111111111",
      "35": "4761739001010119D22122011758928889",
      "41": "12345678"
    }

    assert Tools.attach_timestamps(message, timestamp) == Map.merge(message,%{"7": "1115110130", "12": "110130"})
  end
end
