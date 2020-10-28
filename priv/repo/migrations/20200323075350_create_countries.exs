defmodule Bund.Repo.Migrations.CreateCountries do
  use Ecto.Migration

  def change do
 create table(:countries) do
      add :name, :string
      add :iso3, :string
      add :iso2, :string
      add :phonecode, :string
      add :capital, :string
      add :currency, :string

      timestamps()
  end
end
end





