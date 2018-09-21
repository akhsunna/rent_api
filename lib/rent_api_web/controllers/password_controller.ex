defmodule RentApiWeb.PasswordController do
  use RentApiWeb, :controller

  alias RentApi.{Accounts, Accounts.User, Guardian}
  alias RentApi.Mailer

  action_fallback RentApiWeb.FallbackController

  def create(conn, %{"email" => email}) do
    with {:ok, %User{} = user} <- Accounts.get_by_email(email) do
      RentApiWeb.Emails.Auth.forgot_password(user) |> Mailer.deliver_now
      send_resp(conn, :ok, "")
    end

    send_resp(conn, :ok, "")
  end

  def update(conn, %{"token" => token}) do

  end
end
