defmodule RentApiWeb.ItemControllerTest do
  use RentApiWeb.ConnCase

  import RentApi.Factory
  alias RentApi.Guardian

  alias RentApi.{Stuff}
  alias RentApiWeb.ItemView

  @doc false

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
    {:ok, conn: put_req_header(conn, "content-type", "application/json")}
  end

  describe "show item" do
    test "renders particuler item", %{conn: conn} do
      item = insert(:item)

      item = RentApi.Repo.preload(item, [:owner, :category])
      conn = get conn, item_path(conn, :show, item.id)
      # TODO: improve it! (keys as strings vs keys as atoms)
      assert Poison.encode!(json_response(conn, 200)["item"]) == Poison.encode!(ItemView.render("item.json", item: item))
    end
  end

  describe "list items" do
    test "renders list of all items", %{conn: conn} do
      insert(:item)

      conn = get conn, item_path(conn, :index)
      assert length(json_response(conn, 200)["items"]) == 1
    end

    test "renders list of filtered items", %{conn: conn} do
      insert(:item)

      conn = get conn, item_path(conn, :index, %{category_ids: [0], name: "test"})
      assert length(json_response(conn, 200)["items"]) == 0
    end
  end

  describe "create item" do
    setup [:add_auth_header]

    test "creates item when params are valid", %{conn: conn} do
      category = insert(:category)
      conn = post conn, item_path(conn, :create), item: %{name: "New Item", category_id: category.id}
      refute json_response(conn, 200)["item"] == nil
    end

    test "renders errors when params are invalid", %{conn: conn} do
      conn = post conn, item_path(conn, :create), item: %{name: "New Item"}
      refute json_response(conn, 422)["errors"] == %{}
    end
  end

  describe "delete item" do
    setup [:add_auth_header]

    test "deletes item when it belongs to current user", %{conn: conn, current_user: current_user} do
      item = insert(:item, %{owner: current_user})
      delete conn, item_path(conn, :delete, item)
      assert Stuff.get_item(item.id) == nil
    end

    test "renders error if item does not belong to current user", %{conn: conn} do
      item = insert(:item)
      conn = delete conn, item_path(conn, :delete, item)
      assert conn.status == 403
    end
  end

  defp add_auth_header %{conn: conn} do
    current_user = insert(:user)
    {:ok, token, _} = Guardian.encode_and_sign(current_user, %{}, token_type: :access)
    {:ok, conn: put_req_header(conn, "authorization", "bearer: " <> token), current_user: current_user}
  end
end
