defmodule Iso8583 do
  @moduledoc """
  ISO 8583 messaging library for Elixir. This library has utilities validate, encode and decode message 
  between systems using ISO 8583 regadless of the language the other system is written in. 
  """

  import Iso8583.Encode
  alias Iso8583.Utils

  @doc """
  Function to encode json or Elixir map into ISO 8583 encoded binary. Use this to encode all fields that are supported.
  See the formats module for details.
  ## Examples
      iex> message = %{
      iex>   "0": "0800",
      iex>   "7": "0818160244",
      iex>   "11": "646465",
      iex>   "12": "160244",
      iex>   "13": "0818",
      iex>   "70": "001"
      iex> }
      %{
      "0": "0800",
      "11": "646465",
      "12": "160244",
      "13": "0818",
      "7": "0818160244",
      "70": "001"
      }
      iex>Iso8583.encode(message)
      <<0, 49, 48, 56, 48, 48, 130, 56, 0, 0, 0, 0, 
      0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 48, 56, 49, 56, 
      49, 54, 48, 50, 52, 52, 54, 52, 54, 52, 54, 53, 
      49, 54, 48, 50, 52, 52, 48, 56, 49, 56, 48, 48, 
      49>>
  """

  def encode(message) do
    message
    |> Utils.atomify_map()
    |> encode_0_127()
  end
end
