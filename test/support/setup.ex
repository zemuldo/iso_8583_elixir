defmodule ISO8583.Test.Setup do
  defmacro __using__(_) do
    quote do
      use ExUnit.Case

      setup do
        %{}
      end
    end
  end
end
