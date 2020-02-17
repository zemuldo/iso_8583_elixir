defmodule Iso8583.Test.DataTypesTest do
  use ExUnit.Case

  alias Iso8583.DataTypes

  doctest Iso8583.DataTypes

  describe "Data Types" do
    test "should test unknown type" do
      assert DataTypes.valid?("2", "aa", "ABCD") == {:error, "Data type aa is not implemented"}
    end

    test "should test valid a type" do
      assert DataTypes.valid?("2", "a", "ABCD") == true
    end

    test "should test valid z test" do
      assert DataTypes.valid?("35", "z", "4180875104555684D190522611950628") == true
    end

    test "should test valid n type " do
      assert DataTypes.valid?("22", "n", "4180875111950628") == true
    end

    test "should test invalid n type " do
      assert DataTypes.valid?("22", "n", "4180875111950628R") ==
               {:error, "While processing field 22 data provided is not of type 'n'"}
    end

    test "should test valid b type " do
      assert DataTypes.valid?("22", "b", "4180875111950628") == true
    end

    test "should test invalid b type " do
      assert DataTypes.valid?("22", "b", "4180875111950628R") ==
               {:error, "While processing field 22 data provided is not of type 'b'"}
    end

    test "should test valid p type # " do
      assert DataTypes.valid?("22", "p", "#") == true
    end

    test "should test valid p type * " do
      assert DataTypes.valid?("22", "p", "*") == true
    end

    test "should test invalid p type " do
      assert DataTypes.valid?("22", "p", "4180875111950628R") ==
               {:error, "While processing field 22 data provided is not of type 'p'"}
    end

    test "should test valid x+n type * " do
      assert DataTypes.valid?("22", "x+n", "C43656456") == true
    end

    test "should test valid anp " do
      assert DataTypes.valid?("22", "anp", "C43656456") == true
    end

    test "should test invalid anp " do
      assert DataTypes.valid?("22", "anp", "4180875111950628R%") ==
               {:error, "While processing field 22 data provided is not of type 'anp'"}
    end
  end
end
