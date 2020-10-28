defmodule Bund.Users.User do
  use Ecto.Schema
  import Ecto.Changeset
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema,
    extensions: [PowResetPassword]

  schema "users" do
    pow_user_fields()
    field :first_name, :string
    field :surname, :string
    field :company_name, :string
    field :phone_number, :string
    field :no_of_employees, :string

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> cast(attrs, [:first_name, :surname, :company_name, :phone_number, :no_of_employees])
    |> pow_extension_changeset(attrs)
  end
end
