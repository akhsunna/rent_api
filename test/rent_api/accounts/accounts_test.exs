defmodule RentApi.AccountsTest do
  use RentApi.DataCase

  alias RentApi.Accounts
  alias RentApi.Accounts.User

  @doc false
  describe "users" do

    def user_fixture() do
      with nil <- RentApi.Repo.one(User),
           {:ok, %User{} = user} <- RentApi.Repo.insert(%User{
             email: "test@mail.com",
             password: "123123123"
           }) do
        user
      end
    end

    test "get_users_list/0 returns all users" do
      user_fixture()
      refute length(Accounts.get_users_list) == 0
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id).email == user.email
    end

    test "create_user/1 creates the new user" do
      {email, password} = {"create@mail.com", "123123123"}

      assert {:ok, %User{} = user} = Accounts.create_user(%{email: email, password: password})
      assert user.email == email
    end

    test "create_user/2 with invalid password returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{email: "create@mail.com", password: "123"})
    end

    test "create_user/2 with invalid email returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(%{email: "mail", password: "123123123"})
    end

  end
end
