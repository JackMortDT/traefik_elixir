defmodule ParserTest do
  use ExUnit.Case

  alias Traefik.Parser

  test "parser the header from request into map" do
    header_string = ["Accept: */*", "Connection: keep-alive"]
    headers = Parser.parse_headers(header_string, %{})
    assert headers == %{"Accept" => "*/*", "Connection" => "keep-alive"}
  end

  test "parser the params from a request into a map" do
    params_string = "a=1&b=2&c=3"
    params = Parser.parse_params("application/x-www-form-urlencoded", params_string)
    assert params == %{"a" => "1", "b" => "2", "c" => "3"}
  end
end
