# Script for populating the database.
# You can run it as: mix run priv/repo/seeds.exs

RentApi.Repo.insert!(%RentApi.Staff.Category{name: "Bicycle"})

RentApi.Repo.insert!(%RentApi.Accounts.User{
  email: "anna@mail.com",
  password: "123123123",
  password_confirmation: "123123123"
})
