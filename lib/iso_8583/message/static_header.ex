defmodule ISO8583.Message.SataticHeader do
  @moduledoc false

  def extract_meta_data(message, static_meta) when byte_size(message) > byte_size(static_meta) do
    len = byte_size(static_meta)
    <<st_meta::binary-size(len), without_st_meta::binary>> = message

    {:ok, st_meta, without_st_meta}
  end
end
