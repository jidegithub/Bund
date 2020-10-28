# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Bund.Repo.insert!(%Bund.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Bund.Repo
alias Bund.Users.User
alias NimbleCSV.RFC4180, as: CSV
alias Bund.Accounts.Account
alias Bund.Location.{Country, State}



# Repo.insert!(%User
#   {
#     id: "1",
#   email: "admin@gmail.com",
#   # password: "1234567890",
#   # confirm_password: "1234567890",
#   password_hash: Pow.Ecto.Schema.Password.pbkdf2_hash("1234567890"),
#   first_name: "Ad",
#   #last_name: "Min",
#   phone_number:  "076854225445",
#   company_name: "Lopworks",
#   current_password: "1234567890"
#   }
# )   
    
   
# for data <- 1..100 do
#   account_data = %{
#     company: Faker.Name.company(),
#     contact_person: Faker.Name.name(),
#     city: Faker.Address.city(),
#     email_address: Faker.Internet.email(),
#     sector: Faker.Industry.super_sector(),
#     note: Faker.Lorem.paragraph(1..2),
#     status: Enum.random(["Well Engaged", "Pending", "Inactive"]),
#     phone: Faker.Phone.EnGb.number(),
#     street: Faker.Address.street_address(),    
#     state: Faker.Address.state(),
#     country: Faker.Address.country()    
#   }

#   %Bund.Accounts.Account{}
#   |> Bund.Accounts.Account.changeset(account_data)
#   |> Repo.insert!()
# end


"priv/seed_data/accounts.csv"
|> File.read!
|> CSV.parse_string
|> Enum.each(fn [city, company, contact_person, country, email_address, note, phone, sector, state, status, street]->
  %Account{city: city, company: company, contact_person: contact_person, country: country, email_address: email_address, note: note, phone: phone, sector: sector, state: state, status: status, street: street}
  |> Repo.insert()
end)

"priv/seed_data/countries.csv"
|> File.read!
|> CSV.parse_string
|> Enum.each(fn [name,iso3,iso2,phonecode,capital,currency]->
  %Country{name: name,iso3: iso3, iso2: iso2, phonecode: phonecode, capital: capital,currency: currency}
  |> Repo.insert
end)

"priv/seed_data/states.csv"
|> File.read!
|> CSV.parse_string
|> Enum.each(fn [name,country_id]->
  %State{name: name,country_id: String.replace(country_id,"\r", "") |> String.to_integer()}
  |> Repo.insert
end)


