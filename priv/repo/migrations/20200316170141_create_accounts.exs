defmodule Bund.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :company, :string
      add :city, :string
      add :contact_person, :string
      add :country, :string
      add :email_address, :string
      add :note, :text
      add :phone, :string
      add :sector, :string
      add :state, :string
      add :status, :string
      add :street, :string

      timestamps()
    end

  end
end
