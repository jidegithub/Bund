defmodule Bund.Repo.Migrations.CreateStates do
  use Ecto.Migration

   def change do
    create table(:states) do
      add :name, :string
      add :country_id, references(:countries, on_delete: :nothing)

      timestamps()
    end

    create index(:states, [:country_id])
  end
end
