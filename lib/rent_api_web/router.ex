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

     resources "/users", UserController, only: [:create]
     post "/auth_token", UserController, :auth
   end

   scope "/api/v1", RentApiWeb do
     pipe_through [:api, :jwt_authenticated]

     resources "/users", UserController, only: [:show, :update]
   end
end
