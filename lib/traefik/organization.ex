defmodule Traefik.Organization do
  alias Traefik.Developer
  @devs_file Path.expand("./") |> Path.join("MOCK_DATA.csv")

  def list_developers do
    @devs_file
    |> File.read()
    |> elem(1)
    |> String.split("\n")
    |> Kernel.tl()
    |> Enum.map(&transform_row/1)
  end

  def get_developer(id) when is_binary(id) do
    id
    |> String.to_integer()
    |> get_developer()
  end

  def get_developer(id) when is_integer(id) do
    Enum.find(list_developers(), fn
      nil -> false
      dev -> dev.id == id
    end)
  end

  defp transform_row(row) do
    row
    |> String.split(",")
    |> transform_developer()
  end

  defp transform_developer([id, first_name, last_name, email, gender, ip_address]) do
    %Developer{
      id: String.to_integer(id),
      first_name: first_name,
      last_name: last_name,
      email: email,
      gender: gender,
      ip_address: ip_address
    }
  end

  defp transform_developer(_), do: nil
end
