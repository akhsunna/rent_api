defmodule RentApi.ItemFilterTest do
  use RentApi.DataCase

  import RentApi.Factory

  alias RentApi.Stuff
  alias RentApi.Stuff.{Item, ItemFilter}
  alias RentApi.Repo

  @doc false
  describe "by_name/2" do
    test "returns items with names that includes given string" do
      insert(:item, %{name: "lol"})
      kek_item = insert(:item, %{name: "kek"})

      assert Repo.all(ItemFilter.by_name(Item, %{name: "kek"})) |> Enum.map(& &1.id) == [kek_item] |> Enum.map(& &1.id)
    end

    test "returns all items if param is blank" do
      items = insert_list(2, :item)

      assert Repo.all(ItemFilter.by_name(Item, %{})) |> Enum.map(& &1.id) == items |> Enum.map(& &1.id)
    end
  end

  describe "by_category/2" do

    # TODO

  end
end
