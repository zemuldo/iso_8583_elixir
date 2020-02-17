defmodule MessageTest do
  use ExUnit.Case

  doctest Iso8583.Message

  alias Iso8583.Message

  test "should create new message" do
    message = Message.new(%{"0": "0100", "7": "0901105843", "12": "105843"})
    assert Map.get(message, :"7") == "0901105843"
  end

  test "should fail to create new message, raise ArgumentError" do
    assert_raise ArgumentError, fn ->
      Message.new(%{"0": "0100", "12": "105843"})
    end
  end

  test "should create new clean message" do
    message = Message.new(%{"0": "0100", "7": "0901105843", "12": "105843"})
    assert Map.get(message, :"7") == "0901105843"
  end

  test "should fail to create new clean message, raise ArgumentError" do
    assert_raise ArgumentError, fn ->
      Message.new(%{"0": "0100", "12": "105843"})
    end
  end
end
