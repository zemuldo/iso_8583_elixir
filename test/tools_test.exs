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
end
