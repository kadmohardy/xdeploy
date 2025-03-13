defmodule XdeployWeb.HealthController do
  use XdeployWeb, :controller

  def show(conn, _params) do
    conn
    |> put_view(json: XdeployWeb.HealthJSON)
    |> render(response: :ok)
  end
end
