defmodule Traefik.Plugs do
  @moduledoc """
  Some functions for extra information about requests
  """

  alias Traefik.Conn

  def rewrite_path(%Conn{path: "/redirectme"} = conn) do
    %{conn | path: "/all"}
  end

  def rewrite_path(%Conn{} = conn), do: conn

  def log(%Conn{} = conn) do
    show_log(conn, Mix.env())
    conn
  end

  def track(%Conn{status: 404} = conn) do
    show_track(conn, Mix.env())
    conn
  end

  def track(%Conn{} = conn), do: conn

  defp show_log(conn, :dev), do: IO.inspect(conn)
  defp show_log(_conn, _), do: :ok

  defp show_track(_conn, :test), do: :ok
  defp show_track(conn, _), do: IO.inspect(conn)
end
