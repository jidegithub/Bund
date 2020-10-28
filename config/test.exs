use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bund, BundWeb.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :bund, Bund.Repo,
  username: "postgres",
  password: "postgres",
  database: "bund_dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

  # configure chrome driver and hound
config :hound, driver: "chrome_driver"
config :bund, sql_sandbox: true
