# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bund,
  ecto_repos: [Bund.Repo]

# Configures the endpoint
config :bund, BundWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "oQabdS7jlSVMkgaomiTAWd0BbjrtGSPy0Hiw5sxVe9hXVIarRt7qzXFmjOtzTbCp",
  render_errors: [view: BundWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bund.PubSub, adapter: Phoenix.PubSub.PG2]


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :hound, driver: "chrome_driver"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
import_config "smtp.exs"

# Pow configuration
config :bund, :pow,
    user: Bund.Users.User,
    repo: Bund.Repo,
    extensions: [PowResetPassword],
    controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
    web_module: BundWeb,
    routes_backend: BundWeb.Pow.Routes,
    mailer_backend: BundWeb.PowMailer,
    web_mailer_module: BundWeb


#Bamboo Mailer Config
config :bund, Bund.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.gmail.com",
  port: 465,
  tls: :if_available, # can be `:always` or `:never`
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"], # or {:system, "ALLOWED_TLS_VERSIONS"} w/ comma seprated values (e.g. "tlsv1.1,tlsv1.2")
  ssl: true, # can be `true`
  retries: 1,
  no_mx_lookups: false, # can be `true`
  auth: :if_available # can be `:always`. If your smtp relay requires authentication set it to `:always`. 
  
  config :bund, BundWeb.PowMailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.gmail.com",
  port: 465,
  username: "olajide.o@ng.lopworks.com", # or {:system, "SMTP_USERNAME"}
  password: "jidegmail", # or {:system, "SMTP_PASSWORD"}
  tls: :if_available,
  allowed_tls_versions: [:tlsv1, :"tlsv1.1", :"tlsv1.2"],
  ssl: true,
  retries: 1,
  no_mx_lookups: false

  

