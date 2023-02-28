defmodule Traefik.SimpleServer do
  alias Traefik.Handler

  def start(request) do
    parent = self()
    pid = spawn(__MODULE__, :loop, [parent])
    send(pid, {parent, :call, request})
  end

  def loop(pid) do
    receive do
      {^pid, :call, request} ->
        request
        |> Handler.handle()
        |> IO.inspect(label: :response)
    end
  end
end
