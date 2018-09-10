defmodule RentApiWeb.HomeController do
  use RentApiWeb, :controller

  def index(conn, _params) do
    conn
    |> send_resp(201, "")
  end
end
