defmodule RentApiWeb.Emails.Auth do
  use Bamboo.Phoenix, view: RentApiWeb.EmailView

  @from "support@rentapi.com"

  def forgot_password(user) do
    # TODO: correct token
    token = ""
    url_with_token = "#{token}"

    new_email
      |> to(user.email)
      |> from(@from)
      |> subject("Reset your password")
      |> put_header("Reply-To", @from)
      |> assign(:user, user)
      |> assign(:url_with_token, url_with_token)
      |> render("forgot_password.html")
  end
end
