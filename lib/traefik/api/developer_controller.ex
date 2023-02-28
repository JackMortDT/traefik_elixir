defmodule Traefik.Api.DeveloperController do
  alias Traefik.Conn
  alias Traefik.Organization

  def index(%Conn{} = conn, _params \\ %{}) do
    json =
      %{limit: 10, offset: 0}
      |> Organization.list_developers()
      |> Jason.encode!()

    %{conn | status: 200, response: json, content_type: "application/json"}
  end
end
