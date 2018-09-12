defmodule RentApiWeb.ItemController do
  use RentApiWeb, :controller

  alias RentApi.{Stuff, Stuff.Item}

  action_fallback RentApiWeb.FallbackController

  def show(conn, %{"id" => id}) do
    item = Stuff.get_item(id)
    render(conn, "show.json", item: item)
  end

  def index(conn, params) do
    items = Item
            |> Stuff.apply_item_filters(params)
            |> Stuff.get_items_list_with_owners
    render(conn, "index.json", items: items)
  end
end
