defmodule RentApiWeb.ItemView do
  use RentApiWeb, :view
  alias RentApiWeb.{ItemView, UserView}

  def render("show.json", %{item: item}) do
    %{item: render_one(item, ItemView, "item.json")}
  end

  def render("item.json", %{item: item}) do
    %{id: item.id,
      name: item.name,
      category_name: item.category.name,
      owner: render_one(item.owner, UserView, "user.json")
    }
  end
end
