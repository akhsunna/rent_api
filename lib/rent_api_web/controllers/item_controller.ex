defmodule RentApiWeb.ItemController do
  use RentApiWeb, :controller

  alias RentApi.{Stuff, Stuff.Item}

  action_fallback RentApiWeb.FallbackController

  def show(conn, %{"id" => id}) do
    item = Stuff.get_item(id)
    render(conn, "show.json", item: item)
  end
end
