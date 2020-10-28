defmodule Bund.Repo do
  use Ecto.Repo,
    otp_app: :bund,
    adapter: Ecto.Adapters.Postgres
end
