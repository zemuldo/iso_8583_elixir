defmodule Iso8583.AccountTypes do

  alias Iso8583.AccountTypes,  as: Self

  def all do
    %{
      "00": "Default – unspecified",
      "10": "Savings account",
      "20": "Check account",
      "30": "Credit account",
      "40": "Universal account",
      "50": "Investment account",
      "60": "Electronic purse account (default)",
      "91": "Mortgage loan",
      "92": "Instalment loan"
    }
  end

  def one(k) do
    acc_types = Self.all()
    acc_types[String.to_atom(k)]
  end
end
