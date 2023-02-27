defmodule ParserTest do
  use ExUnit.Case

  alias Traefik.Parser

  test "parser the header from request into map" do
    header_string = ["Accept: */*", "Connection: keep-alive"]
    headers = Parser.parse_headers(header_string, %{})
    assert headers == %{"Accept" => "*/*", "Connection" => "keep-alive"}
  end
end
