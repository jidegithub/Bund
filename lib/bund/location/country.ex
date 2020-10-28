defmodule Bund.Location.Country do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:id, :name, :states]}

  alias Bund.Location.State

  schema "countries" do
    field :capital, :string
    field :currency, :string
    field :iso2, :string
    field :iso3, :string
    field :name, :string
    field :phonecode, :string
    has_many :states, State

    timestamps()
  end

  @doc false
  def changeset(country, attrs) do
    country
    |> cast(attrs, [:name, :iso3, :iso2, :phonecode, :capital, :currency])
    |> validate_required([:name, :iso3, :iso2, :phonecode, :capital, :currency])
  end
end