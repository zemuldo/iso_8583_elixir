defmodule ISO8583.Message.StaticMeta do
  @moduledoc false

  def extract(message, static_meta)
      when byte_size(message) > byte_size(static_meta) do
    len = byte_size(static_meta)
    <<st_meta::binary-size(len), without_st_meta::binary>> = message

    {:ok, st_meta, without_st_meta}
  end

  def extract(message, _), do: {:ok, <<>>, message}

  def put(message, static_meta)
      when is_binary(message) and is_binary(static_meta) do
    {:ok, static_meta <> message}
  end

  def put(message, _), do: {:ok, message}
end
