defmodule Bund.Repo.Migrations.UpdatePowUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :first_name, :string
      add :surname, :string
      add :company_name, :string
      add :phone_number, :string
      add :no_of_employees, :string
    end
  end
end
