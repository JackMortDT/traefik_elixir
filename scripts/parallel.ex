defmodule Parallel do
  def pmap(collection, fun) do
    collection
    |> Enum.map(fn data ->
      data
      |> spawn_process(self(), fun)
      |> await()
    end)
  end

  defp spawn_process(n, parent, fun) do
    spawn(fn ->
      send(parent, {self(), fun.(n)})
    end)
  end

  defp await(pid) do
    receive do
      {^pid, result} -> result
    end
  end
end
