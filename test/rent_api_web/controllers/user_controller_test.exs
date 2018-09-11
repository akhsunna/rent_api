defmodule RentApiWeb.UserControllerTest do
  use RentApiWeb.ConnCase

  alias RentApi.Guardian

  alias RentApi.Accounts
  alias RentApi.Accounts.User

  @create_attrs %{email: "create@mail.com", password: "123123123"}
  @update_attrs %{email: "update@mail.com"}
  @invalid_attrs %{email: nil, password: "123"}

  def user_fixture do
    with nil <- RentApi.Repo.get_by(User, email: @create_attrs.email),
         {:ok, %User{} = user} <- Accounts.create_user(@create_attrs) do
      user
    end
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show user" do
    setup [:add_auth_header]

    test "renders current user's information", %{conn: conn, current_user: current_user} do
      conn = get conn, user_path(conn, :show, :me)
      assert json_response(conn, 200)["user"] == %{
        "id" => current_user.id,
        "email" => current_user.email
      }
    end
  end

  describe "create user" do
    test "creates user when params are valid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @create_attrs
      assert %{"jwt" => jwt} = json_response(conn, 200)
    end

    test "renders errors when params are invalid", %{conn: conn} do
      conn = post conn, user_path(conn, :create), user: @invalid_attrs
      refute json_response(conn, 422)["errors"] == %{}
    end
  end

  describe "update user" do
    setup [:add_auth_header]

    test "updates user when params are valid", %{conn: conn, current_user: current_user} do
      conn = put conn, user_path(conn, :update, :me), user: @update_attrs
      assert json_response(conn, 200)["user"] == %{
        "id" => current_user.id,
        "email" => @update_attrs[:email]
      }
    end

    test "renders errors when params are invalid", %{conn: conn} do
      conn = put conn, user_path(conn, :update, :me), user: @invalid_attrs
      refute json_response(conn, 422)["errors"] == %{}
    end
  end

  defp add_auth_header %{conn: conn} do
    current_user = user_fixture()
    {:ok, token, _} = Guardian.encode_and_sign(current_user, %{}, token_type: :access)
    {:ok, conn: put_req_header(conn, "authorization", "bearer: " <> token), current_user: current_user}
  end
end
