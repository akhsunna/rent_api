defmodule RentApi.Stuff do
  @moduledoc """
  The Stuff context.
  """

  import Ecto.Query, warn: false
  alias RentApi.Repo
  alias RentApi.Stuff.ItemFilter

  alias RentApi.Stuff.{Item, Category}

  def get_categories_list do
    Repo.all(Category)
  end

  def get_items_list(query \\ Item) do
    Repo.all(query)
  end

  def get_items_list_with_owners(query \\ Item) do
    Repo.all(query)
    |> Repo.preload([:owner])
  end

  def apply_item_filters(query, params) do
    query
    |> ItemFilter.by_name(params)
    |> ItemFilter.by_category(params)
    |> ItemFilter.available(params)
  end

  def get_item_with_owner(id) do
    Repo.get(Item, id)
    |> Repo.preload([:owner, :category])
  end

  def get_item(id) do
    Repo.get(Item, id)
  end

  def create_item(user, attrs) do
    Ecto.build_assoc(user, :items)
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  def delete_item(item) do
    Repo.delete(item)
  end
end
