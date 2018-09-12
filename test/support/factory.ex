defmodule RentApi.Factory do
  use ExMachina.Ecto, repo: RentApi.Repo

  def category_factory do
    %RentApi.Stuff.Category{
      name: sequence(:category, &"Category #{&1}")
    }
  end

  def user_factory do
    %RentApi.Accounts.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "123123123",
    }
  end

  def item_factory do
    name = sequence(:name, &"Bicycle #{&1})")
    %RentApi.Stuff.Item{
      name: name,
      category: build(:category),
      owner: build(:user),
    }
  end
end
