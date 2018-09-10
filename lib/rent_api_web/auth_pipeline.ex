defmodule RentApi.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :rent_api,
                              module: RentApi.Guardian,
                              error_handler: RentApiWeb.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
