use Mix.Config

# Configure your database
config :bund, Bund.Repo,
  username: "appuser",
  password: "Neue.P455",
  database: "testbund_repo",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# We don't run a server during test, but we need it for systemtest!
config :bund, BundWeb.Endpoint,
  http: [port: 5000],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn
