defmodule BundWeb.Api.CountryController do
  use BundWeb, :controller

  alias Bund.Location
  alias Bund.Location.Country

  def index(conn, _params) do
    countries = Location.list_countries()
    conn
    |> json(countries)
  end

  def show(conn, %{"id" => id}) do
    country = Location.get_country!(id)
    conn
    |> json(country)
  end
end