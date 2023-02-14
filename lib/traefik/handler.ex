defmodule Traefik.Handler do
  @moduledoc """
  Handles all the HTTP requests.
  """

  @files_path Path.expand("../../pages", __DIR__)

  @doc """
  Handle a single request, transforms into response.
  """
  def handle(request) do
    request
    |> parse()
    |> rewrite_path()
    |> log()
    |> route()
    |> track()
    |> format_response()
  end

  def parse(request) do
    [method, path, _protocol] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, response: "", status: nil}
  end

  def rewrite_path(%{path: "/redirectme"} = conn) do
    %{conn | path: "/all"}
  end

  def rewrite_path(conn), do: conn

  def log(conn), do: IO.inspect(conn, label: "Logger")

  def route(conn) do
    route(conn, conn.method, conn.path)
  end

  def route(conn, "GET", "/hello") do
    %{conn | status: 200, response: "Hello World!!!"}
  end

  def route(conn, "GET", "/world") do
    %{conn | status: 200, response: "Hello MakingDevs and all devs"}
  end

  def route(conn, "GET", "/all") do
    %{conn | status: 200, response: "All developers greetings!!!"}
  end

  def route(conn, "GET", "/about") do
    @files_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conn)
  end

  def route(conn, _method, path) do
    %{conn | status: 404, response: "No #{path} found!!!"}
  end

  def handle_file({:ok, content}, conn),
    do: %{conn | status: 200, response: content}

  def handle_file({:error, reason}, conn),
    do: %{conn | status: 404, response: "File not found for #{inspect(reason)}"}

  # def route(conn, "GET", "/about") do
  #   Path.expand("../../pages", __DIR__)
  #   |> Path.join("about.html")
  #   |> File.read()
  #   |> case do
  #     {:ok, content} ->
  #       %{conn | status: 200, response: content}

  #     {:error, reason} ->
  #       %{conn | status: 404, response: "File not found for #{inspect(reason)}"}
  #   end
  # end

  def track(%{status: 404, path: path} = conn) do
    IO.inspect("Warn ✊ path #{path} not found")
    conn
  end

  def track(conn), do: conn

  def format_response(conn) do
    """
    HTTP/1.1 #{conn.status} #{status_reason(conn.status)}
    Host: some.com
    User-Agent: telnet
    Content-Lenght: #{String.length(conn.response)}
    Accept: */*

    #{conn.response}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }
    |> Map.get(code)
  end
end

request_1 = """
GET /hello HTTP/1.1
Accept: */*
Connection: keep-alive
User-Agent: telnet


"""

IO.puts(Traefik.Handler.handle(request_1))
IO.puts("-------------------------#")

request_2 = """
GET /world HTTP/1.1
Accept: */*
Connection: keep-alive
User-Agent: telnet


"""

IO.puts(Traefik.Handler.handle(request_2))
IO.puts("-------------------------#")

request_3 = """
GET /not-found HTTP/1.1
Accept: */*
Connection: keep-alive
User-Agent: telnet


"""

IO.puts(Traefik.Handler.handle(request_3))
IO.puts("-------------------------#")

request_4 = """
GET /redirectme HTTP/1.1
Accept: */*
Connection: keep-alive
User-Agent: telnet


"""

IO.puts(Traefik.Handler.handle(request_4))
IO.puts("-------------------------#")

request_5 = """
GET /about HTTP/1.1
Accept: */*
Connection: keep-alive
User-Agent: telnet


"""

IO.puts(Traefik.Handler.handle(request_5))
