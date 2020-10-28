defmodule Bund.Location.State do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :country_id]}

  alias Bund.Location.Country

  schema "states" do
    field :name, :string
    belongs_to :country, Country

    timestamps()
  end

  @doc false
  def changeset(state, attrs) do
    state
    |> cast(attrs, [:name, :country_id])
    |> validate_required([:name])
  end
end
