defmodule RentApiWeb.ItemControllerTest do
  use RentApiWeb.ConnCase

  alias RentApi.{Stuff, Stuff.Item, Stuff.Category}
  alias RentApi.{Accounts, Accounts.User}
  alias RentApiWeb.ItemView

  @user_attrs %{email: "create@mail.com", password: "123123123"}

  @doc false

  def user_fixture do
    with nil <- RentApi.Repo.get_by(User, email: @user_attrs.email),
         {:ok, %User{} = user} <- Accounts.create_user(@user_attrs) do
      user
    end
  end

  def category_fixture do
    with nil <- RentApi.Repo.one(Category),
         {:ok, %Category{} = category} <- RentApi.Repo.insert!(%Category{name: "Test"}) do
      category
    end
  end

  def item_attrs(status \\ :create) do
    case status do
      :create ->
        %{name: "New Item", category_id: category_fixture().id}
      :update ->
        %{name: "Item", category_id: category_fixture().id}
      _ -> %{}
    end
  end

  @doc false

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show item" do
    test "renders particuler item", %{conn: conn} do
      {:ok, item} = Stuff.create_item(user_fixture(), item_attrs())
      item = RentApi.Repo.preload(item, [:owner, :category])
      conn = get conn, item_path(conn, :show, item.id)
      # TODO: improve it! (keys as strings vs keys as atoms)
      assert Poison.encode!(json_response(conn, 200)["item"]) == Poison.encode!(ItemView.render("item.json", item: item))
    end
  end
end
