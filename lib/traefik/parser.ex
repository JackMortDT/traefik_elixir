defmodule Traefik.Parser do
  alias Traefik.Conn

  @doc """
  Parses a request and tranforms into a Traefik.Conn struct.
  """
  def parse(request) do
    [main, params_string] = String.split(request, "\n\n")

    [request_line | headers_string] = String.split(main, "\n")

    [method, path, _protocol] = String.split(request_line, " ")

    headers = parse_headers(headers_string, %{})
    params = parse_params(headers["Content-Type"], params_string)

    %Conn{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
    |> IO.inspect()
  end

  @doc """
  Parses the headers from a requst into a map

  ## Example

      iex> headers_string = ["Accept: */*", "Connection: keep-alive"]
      iex> Traefik.Parser.parse_headers(headers_string, %{})
      %{"Accept" => "*/*", "Connection" => "keep-alive"}
      iex> Traefik.Parser.parse_headers([], %{})
      %{}
  """
  def parse_headers([head | tail], headers) do
    [header_name, header_value] = String.split(head, ": ")
    headers = Map.put(headers, header_name, header_value)
    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers

  @doc """
  Parses the params from a request into a map.

  ## Example

      iex> params_string = "a=1&b=2&c=3"
      iex> Traefik.Parser.parse_params("application/x-www-form-urlencoded", params_string)
      %{"a" => "1", "b" => "2", "c" => "3"}
      iex> Traefik.Parser.parse_params("", params_string)
      %{}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    parse_params(params_string)
  end

  def parse_params(_, _), do: %{}

  defp parse_params(params_string) do
    params_string
    |> URI.decode_query()
    |> Map.new(fn {key, value} ->
      {key, String.replace(value, "\n", "")}
    end)
  end
end
