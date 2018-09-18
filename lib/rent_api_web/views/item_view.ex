defmodule RentApiWeb.ItemView do
  use RentApiWeb, :view
  alias RentApiWeb.{ItemView, UserView}

  def render("index.json", %{items: items}) do
    %{items: render_many(items, ItemView, "item.json")}
  end

  def render("show.json", %{item: item}) do
    %{item: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{id: item.id,
      name: item.name,
      category_name: (if Ecto.assoc_loaded?(item.category), do: item.category.name, else: nil),
      owner: (if Ecto.assoc_loaded?(item.owner), do: render_one(item.owner, UserView, "user.json"), else: nil),
    }
  end
end
