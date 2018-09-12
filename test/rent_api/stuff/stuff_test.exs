defmodule RentApi.StuffTest do
  use RentApi.DataCase
  import RentApi.Factory
  alias RentApi.Stuff
  alias RentApi.Accounts.User

  @doc false

  def category_fixture(name \\ "Some category") do
    with nil <- RentApi.Repo.get_by(Stuff.Category, name: name),
         {:ok, %Stuff.Category{} = category} <- RentApi.Repo.insert(%Stuff.Category{
           name: name
         }) do
      category
    end
  end

  def user_fixture() do
    with nil <- RentApi.Repo.one(User),
         {:ok, %User{} = user} <- RentApi.Repo.insert(%User{
           email: "test@mail.com",
           password: "123123123"
         }) do
      user
    end
  end

  @doc false
  describe "categories" do
    test "get_categories_list/0 returns all categories" do
      category = category_fixture()
      category_2 = category_fixture("Test")
      assert Stuff.get_categories_list == [category, category_2]
    end
  end

  @doc false
  describe "items" do

    def item_fixture(name \\ "Some item") do
      {:ok, item} =
        RentApi.Repo.insert(%Stuff.Item{
          name: name,
          category_id: category_fixture().id,
          owner_id: user_fixture().id
        })
      item
    end

    test "get_items_list/0 returns all items" do
      item = item_fixture()
      assert Stuff.get_items_list == [item]
    end

    test "get_item/1 returns the item with given id" do
      item = item_fixture()
      assert Stuff.get_item(item.id) == Repo.preload(item, [:owner, :category])
    end

    test "create_item/2 creates the new item" do
      {name, category_id} = {"Test", category_fixture().id}

      assert {:ok, %Stuff.Item{} = item} = Stuff.create_item(user_fixture(), %{name: name, category_id: category_id})
      assert item.name == name
      assert Repo.preload(item, [:category]).category == category_fixture()
      assert Repo.preload(item, [:owner]).owner == user_fixture()
    end

    test "create_item/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Stuff.create_item(user_fixture(), %{})
    end

  end
end
