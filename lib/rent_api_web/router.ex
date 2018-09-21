defmodule RentApiWeb.Router do
  use RentApiWeb, :router

  alias RentApi.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

   scope "/api/v1", RentApiWeb do
     pipe_through :api

     get "/", HomeController, :index

     post "/auth_token", UserController, :auth
     resources "/users", UserController, only: [:create]
     resources "/items", ItemController, only: [:show, :index]
     resources "/passwords", PasswordController, only: [:create, :update], param: "token"
   end

   scope "/api/v1", RentApiWeb do
     pipe_through [:api, :jwt_authenticated]

     resources "/users", UserController, only: [:show, :update]
     resources "/items", ItemController, only: [:create, :delete]
   end
end
