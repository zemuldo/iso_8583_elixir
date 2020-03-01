defmodule ISO8583.Guards do
    defguard has_mti(encoded_message) when byte_size(encoded_message) >= 4
    defguard has_tcp_length_indicator(encoded_message) when byte_size(encoded_message) >= 2
end