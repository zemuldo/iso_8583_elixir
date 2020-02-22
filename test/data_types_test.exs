defmodule ISO8583.Test.DataTypesTest do
  @moduledoc false
  use ExUnit.Case

  alias ISO8583.DataTypes

  doctest ISO8583.DataTypes

  describe "Data Types" do
    use ISO8583.Test.Setup

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
      assert DataTypes.valid?("22", "n", "418") == true
    end

    test "should test invalid n type " do
      assert DataTypes.valid?("22", "n", "41R") ==
               {:error, "While processing field 22 data provided is not of type 'n'"}
    end

    test "should test invalid length on field 22" do
      assert DataTypes.valid?("22", "n", "4188") ==
               {:error, "Invalid length of data on field 22, expected 3 , found 4"}
    end

    test "should test valid b type " do
      assert DataTypes.valid?("2", "b", "4180875111950628") == true
    end

    test "should test invalid b type " do
      assert DataTypes.valid?("2", "b", "418087511195062Z") ==
               {:error, "While processing field 2 data provided is not of type 'b'"}
    end

    test "should test valid p type # " do
      assert DataTypes.valid?("127", "p", "#") == true
    end

    test "should test valid p type * " do
      assert DataTypes.valid?("127", "p", "*") == true
    end

    test "should test valid x+n type 'x+n' " do
      assert DataTypes.valid?("22", "x+n", "C4#") == true
    end

    test "should test valid anp " do
      assert DataTypes.valid?("38", "anp", "B1A2*#") == true
    end

    test "should test invalid anp " do
      assert DataTypes.valid?("38", "anp", "4180875111950628R%") ==
               {:error, "While processing field 38 data provided is not of type 'anp'"}
    end
  end
end
