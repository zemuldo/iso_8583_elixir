defmodule ISO8583.Test.DataTypesTest do
  @moduledoc false
  use ExUnit.Case

  alias ISO8583.DataTypes
  alias ISO8583.Formats

  doctest ISO8583.DataTypes

  describe "Data Types" do
    use ISO8583.Test.Setup

    test "should test unknown type" do
      assert DataTypes.valid?("2", "ABCD", Formats.format(:"2") |> Map.put(:content_type, "aa")) ==
               {:error, "Data type aa is not implemented"}
    end

    test "should test valid a type" do
      assert DataTypes.valid?("2", "ABCD", Formats.format(:"2") |> Map.put(:content_type, "a")) ==
               true
    end

    test "should test invalid valid a type" do
      assert DataTypes.valid?("2", "ABCD5", Formats.format(:"2") |> Map.put(:content_type, "a")) ==
               {:error, "While processing field 2 data provided is not of type 'a'"}
    end

    test "should test valid z test" do
      assert DataTypes.valid?("35", "4180875104555684D190522611950628", Formats.format(:"35")) ==
               true
    end

    test "should test valid n type " do
      assert DataTypes.valid?("22", "418", Formats.format(:"22")) == true
    end

    test "should test invalid n type " do
      assert DataTypes.valid?("22", "41R", Formats.format(:"22")) ==
               {:error, "While processing field 22 data provided is not of type 'n'"}
    end

    test "should test invalid length on field 22" do
      assert DataTypes.valid?("22", "4188", Formats.format(:"22")) ==
               {:error, "Invalid length of data on field 22, expected 3 , found 4"}
    end

    test "should test valid b type " do
      assert DataTypes.valid?("2", "4180875111950628", Formats.format(:"2")) == true
    end

    test "should test invalid b type " do
      assert DataTypes.valid?("127.25.1", "418087511195062Z", Formats.format(:"127.25.1")) ==
               {:error, "While processing field 127.25.1 data provided is not of type 'b'"}
    end

    test "should test valid p type # " do
      assert DataTypes.valid?("127", "#", Formats.format(:"127") |> Map.put(:content_type, "p")) ==
               true
    end

    test "should test valid p type * " do
      assert DataTypes.valid?("127", "*", Formats.format(:"127")) == true
    end

    test "should test valid x+n type 'x+n' " do
      assert DataTypes.valid?("22", "C44444477", Formats.format(:"29")) == true
    end

    test "should test valid anp " do
      assert DataTypes.valid?("38", "B1A2*#", Formats.format(:"38")) == true
    end

    test "should test invalid anp " do
      assert DataTypes.valid?("38", "4180875111950628R%", Formats.format(:"38")) ==
               {:error, "While processing field 38 data provided is not of type 'anp'"}
    end
  end
end
