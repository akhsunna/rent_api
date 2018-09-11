defmodule RentApiWeb.UserView do
  use RentApiWeb, :view
  alias RentApiWeb.UserView

  def render("show.json", %{user: user}) do
    %{user: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email}
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end
