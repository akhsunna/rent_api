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

  describe "available/2" do
    test "returns items available during some correct period" do
      item_1 = insert(:item)
      insert(:booking, %{item: item_1, start_date: ~D[2019-01-01], end_date: ~D[2019-05-01]})

      item_2 = insert(:item)
      insert(:booking, %{item: item_2, start_date: ~D[2019-03-01], end_date: ~D[2019-03-20]})

      item_3 = insert(:item)
      insert(:booking, %{item: item_3, start_date: ~D[2019-01-01], end_date: ~D[2019-03-01]})

      item_4 = insert(:item)
      insert(:booking, %{item: item_4, start_date: ~D[2019-03-01], end_date: ~D[2019-05-01]})

      available_item = insert(:item)
      insert(:booking, %{item: available_item, start_date: ~D[2019-01-01], end_date: ~D[2019-01-20]})

      answer = [available_item] |> Enum.map(& &1.id)

      result_1 = Repo.all(ItemFilter.available(Item, %{start_date: "2019-02-01", end_date: "2019-04-01"}))
               |> Enum.map(& &1.id)

      result_2 = Repo.all(ItemFilter.available(Item, %{start_date: "2019-04-01", end_date: "2019-02-01"}))
               |> Enum.map(& &1.id)

      assert result_1 == answer
      assert result_2 == answer
    end
  end
end
