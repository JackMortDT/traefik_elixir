defmodule Traefik.SimpleServer do
  alias Traefik.HttpServer

  def start(socket) do
    spawn(HttpServer, :serve, [socket])
  end
end
