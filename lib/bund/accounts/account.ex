defmodule Bund.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset
@derive {Jason.Encoder, only: [:id, :company, :city, :contact_person, :country, :email_address, :note, :phone, :sector, :state, :status, :street, :inserted_at]}

  schema "accounts" do
    field :city, :string
    field :company, :string
    field :contact_person, :string
    field :country, :string
    field :email_address, :string
    field :note, :string
    field :phone, :string
    field :sector, :string
    field :state, :string
    field :status, :string
    field :street, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:company, :city, :contact_person, :country, :email_address, :note, :phone, :sector, :state, :status, :street])
    |> validate_required([:company, :city, :contact_person, :country, :email_address, :note, :phone, :sector, :state, :status, :street])
  end
end
