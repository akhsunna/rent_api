defmodule RentApi.Stuff do
  @moduledoc """
  The Stuff context.
  """

  import Ecto.Query, warn: false
  alias RentApi.Repo

  alias RentApi.Stuff.{Item, Category}

  def get_categories_list do
    Repo.all(Category)
  end

  def get_items_list do
    Repo.all(Item)
  end

  def get_item(id) do
    Repo.get(Item, id)
    |> Repo.preload([:owner, :category])
  end

  def create_item(user, attrs) do
    Ecto.build_assoc(user, :items)
    |> Item.changeset(attrs)
    |> Repo.insert()
  end
end
