use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rent_api, RentApiWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :rent_api, RentApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "rent_api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
