# Script for populating the database.
# You can run it as: mix run priv/repo/seeds.exs

category = RentApi.Repo.insert!(%RentApi.Stuff.Category{name: "Bicycle"})

user = RentApi.Repo.insert!(%RentApi.Accounts.User{
  email: "anna@mail.com",
  password: "123123123",
})

RentApi.Repo.insert!(%RentApi.Stuff.Item{
  name: "ukraine",
  category_id: category.id,
  owner_id: user.id
})
