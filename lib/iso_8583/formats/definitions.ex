defmodule Iso8583.Formats.Definitions do
  @moduledoc false
  # TODO: Configure default formats and merge.
  defmacro __using__(_) do
    quote do
      alias Iso8583.Utils
      @custom_formats %{}
      @formats_definitions %{
                             "0": %{
                               content_type: "n",
                               label: "Message Type Indicator",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "1": %{
                               content_type: "b",
                               label: "Bitmap",
                               len_type: "fixed",
                               max_len: 8
                             },
                             "2": %{
                               content_type: "n",
                               label: "Primary account number (PAN)",
                               len_type: "llvar",
                               max_len: 19,
                               min_len: 1
                             },
                             "3": %{
                               content_type: "n",
                               label: "Processing code",
                               len_type: "fixed",
                               max_len: 6
                             },
                             "4": %{
                               content_type: "n",
                               label: "Amount, transaction",
                               len_type: "fixed",
                               max_len: 12
                             },
                             "5": %{
                               content_type: "n",
                               label: "Amount, settlement",
                               len_type: "fixed",
                               max_len: 12
                             },
                             "6": %{
                               content_type: "n",
                               label: "Amount, cardholder billing",
                               len_type: "fixed",
                               max_len: 12
                             },
                             "7": %{
                               content_type: "n",
                               label: "Transmission date & time",
                               len_type: "fixed",
                               max_len: 10
                             },
                             "8": %{
                               content_type: "n",
                               label: "Amount, cardholder billing fee",
                               len_type: "fixed",
                               max_len: 8
                             },
                             "9": %{
                               content_type: "n",
                               label: "Conversion rate, settlement",
                               len_type: "fixed",
                               max_len: 8
                             },
                             "10": %{
                               content_type: "n",
                               label: "Conversion rate, cardholder billing",
                               len_type: "fixed",
                               max_len: 8
                             },
                             "11": %{
                               content_type: "n",
                               label: "System trace audit number",
                               len_type: "fixed",
                               max_len: 6
                             },
                             "12": %{
                               content_type: "n",
                               label: "Time, local transaction (hhmmss)",
                               len_type: "fixed",
                               max_len: 6
                             },
                             "13": %{
                               content_type: "n",
                               label: "Date, local transaction (MMDD)",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "14": %{
                               content_type: "n",
                               label: "Date, expiration",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "15": %{
                               content_type: "n",
                               label: "Date, settlement",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "16": %{
                               content_type: "n",
                               label: "Date, conversion",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "17": %{
                               content_type: "n",
                               label: "Date, capture",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "18": %{
                               content_type: "n",
                               label: "Merchant type",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "19": %{
                               content_type: "n",
                               label: "Acquiring institution country code",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "20": %{
                               content_type: "n",
                               label: "PAN extended, country code",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "21": %{
                               content_type: "n",
                               label: "Forwarding institution. country code",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "22": %{
                               content_type: "n",
                               label: "Point of service entry mode",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "23": %{
                               content_type: "n",
                               label: "Application PAN sequence number",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "24": %{
                               content_type: "n",
                               label: "Network International identifier (NII)",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "25": %{
                               content_type: "n",
                               label: "Point of service condition code",
                               len_type: "fixed",
                               max_len: 2
                             },
                             "26": %{
                               content_type: "n",
                               label: "Point of service capture code",
                               len_type: "fixed",
                               max_len: 2
                             },
                             "27": %{
                               content_type: "n",
                               label: "Authorizing identification response length",
                               len_type: "fixed",
                               max_len: 1
                             },
                             "28": %{
                               content_type: "x+n",
                               label: "Amount, transaction fee",
                               len_type: "fixed",
                               max_len: 9
                             },
                             "29": %{
                               content_type: "x+n",
                               label: "Amount, settlement fee",
                               len_type: "fixed",
                               max_len: 9
                             },
                             "30": %{
                               content_type: "x+n",
                               label: "Amount, transaction processing fee",
                               len_type: "fixed",
                               max_len: 9
                             },
                             "31": %{
                               content_type: "x+n",
                               label: "Amount, settlement processing fee",
                               len_type: "fixed",
                               max_len: 9
                             },
                             "32": %{
                               content_type: "n",
                               label: "Acquiring institution identification code",
                               len_type: "llvar",
                               max_len: 11
                             },
                             "33": %{
                               content_type: "n",
                               label: "Forwarding institution identification code",
                               len_type: "llvar",
                               max_len: 11
                             },
                             "34": %{
                               content_type: "ns",
                               label: "Primary account number, extended",
                               len_type: "llvar",
                               max_len: 28
                             },
                             "35": %{
                               content_type: "z",
                               label: "Track 2 data",
                               len_type: "llvar",
                               max_len: 37
                             },
                             "36": %{
                               content_type: "n",
                               label: "Track 3 data",
                               len_type: "lllvar",
                               max_len: 104
                             },
                             "37": %{
                               content_type: "anp",
                               label: "Retrieval reference number",
                               len_type: "fixed",
                               max_len: 12
                             },
                             "38": %{
                               content_type: "anp",
                               label: "Authorization identification response",
                               len_type: "fixed",
                               max_len: 6
                             },
                             "39": %{
                               content_type: "an",
                               label: "Response code",
                               len_type: "fixed",
                               max_len: 2
                             },
                             "40": %{
                               content_type: "n",
                               label: "Service restriction code",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "41": %{
                               content_type: "ans",
                               label: "Card acceptor terminal identification",
                               len_type: "fixed",
                               max_len: 8
                             },
                             "42": %{
                               content_type: "ans",
                               label: "Card acceptor identification code",
                               len_type: "fixed",
                               max_len: 15
                             },
                             "43": %{
                               content_type: "ans",
                               label: "Card acceptor name/location",
                               len_type: "fixed",
                               max_len: 40
                             },
                             "44": %{
                               content_type: "ans",
                               label: "Additional response data",
                               len_type: "llvar",
                               max_len: 25
                             },
                             "45": %{
                               content_type: "ans",
                               label: "Track 1 data",
                               len_type: "llvar",
                               max_len: 76
                             },
                             "46": %{
                               content_type: "ans",
                               label: "Additional data - ISO",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "47": %{
                               content_type: "ans",
                               label: "Additional data - national",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "48": %{
                               content_type: "ans",
                               label: "Additional data - private",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "49": %{
                               content_type: "n",
                               label: "Currency code, transaction",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "50": %{
                               content_type: "an",
                               label: "Currency code, settlement",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "51": %{
                               content_type: "n",
                               label: "Currency code, cardholder billing",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "52": %{
                               content_type: "b",
                               label: "Personal identification number data",
                               len_type: "fixed",
                               max_len: 16
                             },
                             "53": %{
                               content_type: "b",
                               label: "Security related control information",
                               len_type: "fixed",
                               max_len: 96
                             },
                             "54": %{
                               content_type: "an",
                               label: "Additional amounts",
                               len_type: "lllvar",
                               max_len: 120
                             },
                             "55": %{
                               content_type: "ans",
                               label: "Reserved ISO",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "56": %{
                               content_type: "ans",
                               label: "Message Reason Code",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "57": %{
                               content_type: "ans",
                               label: "Reserved national",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "58": %{
                               content_type: "n",
                               label: "Reserved national",
                               len_type: "llvar",
                               max_len: 11
                             },
                             "59": %{
                               content_type: "ans",
                               label: "Reserved national",
                               len_type: "lllvar",
                               max_len: 255
                             },
                             "60": %{
                               content_type: "ans",
                               label: "Reserved national",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "61": %{
                               content_type: "ans",
                               label: "Reserved private",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "62": %{
                               content_type: "ans",
                               label: "Reserved private",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "63": %{
                               content_type: "ans",
                               label: "Reserved private",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "64": %{
                               content_type: "b",
                               label: "Message authentication code (MAC)",
                               len_type: "fixed",
                               max_len: 8
                             },
                             "65": %{
                               content_type: "b",
                               label: "Bitmap, extended",
                               len_type: "fixed",
                               max_len: 1
                             },
                             "66": %{
                               content_type: "n",
                               label: "Settlement code",
                               len_type: "fixed",
                               max_len: 1
                             },
                             "67": %{
                               content_type: "n",
                               label: "Extended payment code",
                               len_type: "fixed",
                               max_len: 2
                             },
                             "68": %{
                               content_type: "n",
                               label: "Receiving institution country code",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "69": %{
                               content_type: "n",
                               label: "Settlement institution country code",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "70": %{
                               content_type: "n",
                               label: "Network management information code",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "71": %{
                               content_type: "n",
                               label: "Message number",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "72": %{
                               content_type: "n",
                               label: "Message number, last",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "73": %{
                               content_type: "n",
                               label: "Date, action (YYMMDD)",
                               len_type: "fixed",
                               max_len: 6
                             },
                             "74": %{
                               content_type: "n",
                               label: "Credits, number",
                               len_type: "fixed",
                               max_len: 10
                             },
                             "75": %{
                               content_type: "n",
                               label: "Credits, reversal number",
                               len_type: "fixed",
                               max_len: 10
                             },
                             "76": %{
                               content_type: "n",
                               label: "Debits, number",
                               len_type: "fixed",
                               max_len: 10
                             },
                             "77": %{
                               content_type: "n",
                               label: "Debits, reversal number",
                               len_type: "fixed",
                               max_len: 10
                             },
                             "78": %{
                               content_type: "n",
                               label: "Transfer number",
                               len_type: "fixed",
                               max_len: 10
                             },
                             "79": %{
                               content_type: "n",
                               label: "Transfer, reversal number",
                               len_type: "fixed",
                               max_len: 10
                             },
                             "80": %{
                               content_type: "n",
                               label: "Inquiries number",
                               len_type: "fixed",
                               max_len: 10
                             },
                             "81": %{
                               content_type: "n",
                               label: "Authorizations, number",
                               len_type: "fixed",
                               max_len: 10
                             },
                             "82": %{
                               content_type: "n",
                               label: "Credits, processing fee amount",
                               len_type: "fixed",
                               max_len: 12
                             },
                             "83": %{
                               content_type: "n",
                               label: "Credits, transaction fee amount",
                               len_type: "fixed",
                               max_len: 12
                             },
                             "84": %{
                               content_type: "n",
                               label: "Debits, processing fee amount",
                               len_type: "fixed",
                               max_len: 12
                             },
                             "85": %{
                               content_type: "n",
                               label: "Debits, transaction fee amount",
                               len_type: "fixed",
                               max_len: 12
                             },
                             "86": %{
                               content_type: "n",
                               label: "Credits, amount",
                               len_type: "fixed",
                               max_len: 16
                             },
                             "87": %{
                               content_type: "n",
                               label: "Credits, reversal amount",
                               len_type: "fixed",
                               max_len: 16
                             },
                             "88": %{
                               content_type: "n",
                               label: "Debits, amount",
                               len_type: "fixed",
                               max_len: 16
                             },
                             "89": %{
                               content_type: "n",
                               label: "Debits, reversal amount",
                               len_type: "fixed",
                               max_len: 16
                             },
                             "90": %{
                               content_type: "n",
                               label: "Original data elements",
                               len_type: "fixed",
                               max_len: 42
                             },
                             "91": %{
                               content_type: "an",
                               label: "File update code",
                               len_type: "fixed",
                               max_len: 1
                             },
                             "92": %{
                               content_type: "an",
                               label: "File security code",
                               len_type: "fixed",
                               max_len: 2
                             },
                             "93": %{
                               content_type: "an",
                               label: "Response indicator",
                               len_type: "fixed",
                               max_len: 5
                             },
                             "94": %{
                               content_type: "an",
                               label: "Service indicator",
                               len_type: "fixed",
                               max_len: 7
                             },
                             "95": %{
                               content_type: "an",
                               label: "Replacement amounts",
                               len_type: "fixed",
                               max_len: 42
                             },
                             "96": %{
                               content_type: "b",
                               label: "Message security code",
                               len_type: "fixed",
                               max_len: 8
                             },
                             "97": %{
                               content_type: "x+n",
                               label: "Amount, net settlement",
                               len_type: "fixed",
                               max_len: 17
                             },
                             "98": %{
                               content_type: "ans",
                               label: "Payee",
                               len_type: "fixed",
                               max_len: 25
                             },
                             "99": %{
                               content_type: "n",
                               label: "Settlement institution identification code",
                               len_type: "llvar",
                               max_len: 11
                             },
                             "100": %{
                               content_type: "n",
                               label: "Receiving institution identification code",
                               len_type: "llvar",
                               max_len: 11
                             },
                             "101": %{
                               content_type: "ans",
                               label: "File name",
                               len_type: "llvar",
                               max_len: 17
                             },
                             "102": %{
                               content_type: "ans",
                               label: "Account identification 1",
                               len_type: "llvar",
                               max_len: 28
                             },
                             "103": %{
                               content_type: "ans",
                               label: "Account identification 2",
                               len_type: "llvar",
                               max_len: 28
                             },
                             "104": %{
                               content_type: "ans",
                               label: "Transaction description",
                               len_type: "lllvar",
                               max_len: 100
                             },
                             "105": %{
                               content_type: "ans",
                               label: "Reserved for ISO use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "106": %{
                               content_type: "ans",
                               label: "Reserved for ISO use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "107": %{
                               content_type: "ans",
                               label: "Reserved for ISO use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "108": %{
                               content_type: "ans",
                               label: "Reserved for ISO use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "109": %{
                               content_type: "ans",
                               label: "Reserved for ISO use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "110": %{
                               content_type: "ans",
                               label: "Reserved for ISO use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "111": %{
                               content_type: "ans",
                               label: "Reserved for ISO use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "112": %{
                               content_type: "ans",
                               label: "Reserved for national use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "113": %{
                               content_type: "ans",
                               label: "Reserved for national use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "114": %{
                               content_type: "ans",
                               label: "Reserved for national use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "115": %{
                               content_type: "ans",
                               label: "Reserved for national use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "116": %{
                               content_type: "ans",
                               label: "Reserved for national use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "117": %{
                               content_type: "ans",
                               label: "Reserved for national use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "118": %{
                               content_type: "n",
                               label: "Reserved for national use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "119": %{
                               content_type: "n",
                               label: "Reserved for national use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "120": %{
                               content_type: "n",
                               label: "Reserved for private use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "121": %{
                               content_type: "n",
                               label: "Reserved for private use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "122": %{
                               content_type: "n",
                               label: "Reserved for private use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "123": %{
                               content_type: "an",
                               label: "Reserved for private use",
                               len_type: "lllvar",
                               max_len: 999,
                               min_len: 15
                             },
                             "124": %{
                               content_type: "ans",
                               label: "Reserved for private use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "125": %{
                               content_type: "ans",
                               label: "Reserved for private use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "126": %{
                               content_type: "ans",
                               label: "Reserved for private use",
                               len_type: "lllvar",
                               max_len: 999
                             },
                             "127": %{
                               content_type: "ans",
                               label: "Reserved for private use",
                               len_type: "llllllvar",
                               max_len: 999_999
                             },
                             "127.1": %{
                               content_type: "b",
                               label: "Bitmap",
                               len_type: "fixed",
                               max_len: 16
                             },
                             "127.2": %{
                               content_type: "n",
                               label: "Switch Key",
                               len_type: "llvar",
                               max_len: 32,
                               min_len: 12
                             },
                             "127.3": %{
                               content_type: "ans",
                               label: "Routing Information",
                               len_type: "fixed",
                               max_len: 48
                             },
                             "127.4": %{
                               content_type: "ans",
                               label: "POS Data",
                               len_type: "fixed",
                               max_len: 22
                             },
                             "127.5": %{
                               content_type: "ans",
                               label: "Service Station Data",
                               len_type: "fixed",
                               max_len: 73
                             },
                             "127.6": %{
                               content_type: "n",
                               label: "Authorization Profile",
                               len_type: "fixed",
                               max_len: 2
                             },
                             "127.7": %{
                               content_type: "ans",
                               label: "Check Data",
                               len_type: "llvar",
                               max_len: 50,
                               min_len: 10
                             },
                             "127.8": %{
                               content_type: "ans",
                               label: "Retention Data",
                               len_type: "lllvar",
                               max_len: 999,
                               min_len: 100
                             },
                             "127.9": %{
                               content_type: "ans",
                               label: "Additional Node Data",
                               len_type: "lllvar",
                               max_len: 255,
                               min_len: 100
                             },
                             "127.10": %{
                               content_type: "n",
                               label: "CVV2",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "127.11": %{
                               content_type: "ans",
                               label: "Original Key",
                               len_type: "llvar",
                               max_len: 32,
                               min_len: 10
                             },
                             "127.12": %{
                               content_type: "ans",
                               label: "Terminal Owner",
                               len_type: "llvar",
                               max_len: 25,
                               min_len: 10
                             },
                             "127.13": %{
                               content_type: "ans",
                               label: "POS Geographic Data",
                               len_type: "fixed",
                               max_len: 17
                             },
                             "127.14": %{
                               content_type: "ans",
                               label: "Sponsor Bank",
                               len_type: "fixed",
                               max_len: 8
                             },
                             "127.15": %{
                               content_type: "ans",
                               label: "Address Verification Data",
                               len_type: "llvar",
                               max_len: 29,
                               min_len: 10
                             },
                             "127.16": %{
                               content_type: "ans",
                               label: "Address Verification Result",
                               len_type: "fixed",
                               max_len: 1
                             },
                             "127.17": %{
                               content_type: "ans",
                               label: "Cardholder Information",
                               len_type: "llvar",
                               max_len: 50,
                               min_len: 10
                             },
                             "127.18": %{
                               content_type: "ans",
                               label: "Validation data",
                               len_type: "llvar",
                               max_len: 50,
                               min_len: 10
                             },
                             "127.19": %{
                               content_type: "ans",
                               label: "Bank details",
                               len_type: "fixed",
                               max_len: 31
                             },
                             "127.20": %{
                               content_type: "n",
                               label: "Originator / Authorizer date settlement",
                               len_type: "fixed",
                               max_len: 8
                             },
                             "127.21": %{
                               content_type: "ans",
                               label: "Record identification",
                               len_type: "llvar",
                               max_len: 12,
                               min_len: 10
                             },
                             "127.22": %{
                               content_type: "ans",
                               label: "Structured Data",
                               len_type: "lllllvar",
                               max_len: 99999,
                               min_len: 10000
                             },
                             "127.23": %{
                               content_type: "ans",
                               label: "Payee name and address",
                               len_type: "fixed",
                               max_len: 253
                             },
                             "127.24": %{
                               content_type: "ans",
                               label: "Payer account",
                               len_type: "llvar",
                               max_len: 28,
                               min_len: 10
                             },
                             "127.25": %{
                               content_type: "ans",
                               label: "Integrated circuit card (ICC) Data",
                               len_type: "llllvar",
                               max_len: 8000,
                               min_len: 1000
                             },
                             "127.25.1": %{
                               content_type: "b",
                               label: "Bitmap",
                               len_type: "fixed",
                               max_len: 16
                             },
                             "127.25.2": %{
                               content_type: "n",
                               label: "Amount Authorized",
                               len_type: "fixed",
                               max_len: 12
                             },
                             "127.25.3": %{
                               content_type: "n",
                               label: "Amount Other",
                               len_type: "fixed",
                               max_len: 12
                             },
                             "127.25.4": %{
                               content_type: "ans",
                               label: "Application Identifier",
                               len_type: "llvar",
                               max_len: 32,
                               min_len: 10
                             },
                             "127.25.5": %{
                               content_type: "ans",
                               label: "Application Interchange Profile",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "127.25.6": %{
                               content_type: "ans",
                               label: "Application Transaction Counter",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "127.25.7": %{
                               content_type: "ans",
                               label: "Application Interchange Profile",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "127.25.8": %{
                               content_type: "an",
                               label: "Authorization Response Code",
                               len_type: "fixed",
                               max_len: 2
                             },
                             "127.25.9": %{
                               content_type: "n",
                               label: "Card Authentication Reliability Indicator",
                               len_type: "fixed",
                               max_len: 1
                             },
                             "127.25.10": %{
                               content_type: "ans",
                               label: "Card Authentication Result Code",
                               len_type: "fixed",
                               max_len: 1
                             },
                             "127.25.11": %{
                               content_type: "n",
                               label: "Chip Condition Code",
                               len_type: "fixed",
                               max_len: 1
                             },
                             "127.25.12": %{
                               content_type: "ans",
                               label: "Cryptogram",
                               len_type: "fixed",
                               max_len: 16
                             },
                             "127.25.13": %{
                               content_type: "ans",
                               label: "Cryptogram Information Data",
                               len_type: "fixed",
                               max_len: 2
                             },
                             "127.25.14": %{
                               content_type: "ans",
                               label: "Cvm List",
                               len_type: "lllvar",
                               max_len: 504
                             },
                             "127.25.15": %{
                               content_type: "ans",
                               label: "Cvm Results",
                               len_type: "fixed",
                               max_len: 6
                             },
                             "127.25.16": %{
                               content_type: "an",
                               label: "Interface Device Name",
                               len_type: "fixed",
                               max_len: 8
                             },
                             "127.25.17": %{
                               content_type: "ans",
                               label: "Issuer Action Code",
                               len_type: "fixed",
                               max_len: 11
                             },
                             "127.25.18": %{
                               content_type: "ans",
                               label: "Issuer Application Data",
                               len_type: "llvar",
                               max_len: 64
                             },
                             "127.25.19": %{
                               content_type: "ans",
                               label: "Issuer Script Results",
                               len_type: "lllvar",
                               max_len: 507
                             },
                             "127.25.20": %{
                               content_type: "ans",
                               label: "Terminal Application Version Number",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "127.25.21": %{
                               content_type: "ans",
                               label: "Terminal Capabilities",
                               len_type: "fixed",
                               max_len: 6
                             },
                             "127.25.22": %{
                               content_type: "n",
                               label: "Terminal Country Code",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "127.25.23": %{
                               content_type: "n",
                               label: "Terminal Type",
                               len_type: "fixed",
                               max_len: 2
                             },
                             "127.25.24": %{
                               content_type: "ans",
                               label: "Terminal Verification Results",
                               len_type: "fixed",
                               max_len: 10
                             },
                             "127.25.25": %{
                               content_type: "ans",
                               label: "Transaction Category Code",
                               len_type: "fixed",
                               max_len: 1
                             },
                             "127.25.26": %{
                               content_type: "n",
                               label: "Transaction Currency Code",
                               len_type: "fixed",
                               max_len: 3
                             },
                             "127.25.27": %{
                               content_type: "n",
                               label: "Transaction Date",
                               len_type: "fixed",
                               max_len: 6
                             },
                             "127.25.28": %{
                               content_type: "n",
                               label: "Transaction Sequence Counter",
                               len_type: "lvar",
                               max_len: 8
                             },
                             "127.25.29": %{
                               content_type: "n",
                               label: "Transaction Type",
                               len_type: "fixed",
                               max_len: 2
                             },
                             "127.25.30": %{
                               content_type: "ans",
                               label: "Unpredicatable Number",
                               len_type: "fixed",
                               max_len: 8
                             },
                             "127.25.31": %{
                               content_type: "ans",
                               label: "Issuer Authentication Data",
                               len_type: "llvar",
                               max_len: 32
                             },
                             "127.25.32": %{
                               content_type: "ans",
                               label: "Issuer Script Template 1",
                               len_type: "llllvar",
                               max_len: 3354
                             },
                             "127.25.33": %{
                               content_type: "ans",
                               label: "Issuer Script Template 2",
                               len_type: "llllvar",
                               max_len: 3354
                             },
                             "127.26": %{
                               content_type: "ans",
                               label: "Original Node",
                               len_type: "llvar",
                               max_len: 12,
                               min_len: 10
                             },
                             "127.27": %{
                               content_type: "ans",
                               label: "Card Verification Result",
                               len_type: "fixed",
                               max_len: 1
                             },
                             "127.28": %{
                               content_type: "n",
                               label: "American Express Card Identifier (CID)",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "127.29": %{
                               content_type: "b",
                               label: "3D Secure Data",
                               len_type: "fixed",
                               max_len: 40
                             },
                             "127.30": %{
                               content_type: "ans",
                               label: "3D Secure Result",
                               len_type: "fixed",
                               max_len: 1
                             },
                             "127.31": %{
                               content_type: "ans",
                               label: "Issuer Network ID",
                               len_type: "llvar",
                               max_len: 11,
                               min_len: 10
                             },
                             "127.32": %{
                               content_type: "b",
                               label: "UCAF data",
                               len_type: "llvar",
                               max_len: 33,
                               min_len: 10
                             },
                             "127.33": %{
                               content_type: "n",
                               label: "Extended Transaction Type",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "127.34": %{
                               content_type: "n",
                               label: "Account Type Qualifiers",
                               len_type: "fixed",
                               max_len: 2
                             },
                             "127.35": %{
                               content_type: "ans",
                               label: "Acquirer Network ID",
                               len_type: "llvar",
                               max_len: 11,
                               min_len: 10
                             },
                             "127.36": %{
                               content_type: "ans",
                               label: "Customer ID",
                               len_type: "llvar",
                               max_len: 25,
                               min_len: 10
                             },
                             "127.37": %{
                               content_type: "an",
                               label: "Extended Response Code",
                               len_type: "fixed",
                               max_len: 4
                             },
                             "127.38": %{
                               content_type: "an",
                               label: "Additional POS Data Code",
                               len_type: "llvar",
                               max_len: 99,
                               min_len: 10
                             },
                             "127.39": %{
                               content_type: "an",
                               label: "Original Response Code",
                               len_type: "fixed",
                               max_len: 2
                             },
                             "128": %{
                               content_type: "b",
                               label: "Message authentication code",
                               len_type: "fixed",
                               max_len: 8
                             }
                           }
                           |> Utils.atomify_map()
      @doc false
      def formats_definitions,
        do: Map.merge(@formats_definitions, @custom_formats |> Utils.atomify_map())
    end
  end
end
