defmodule BundWeb.Api.AccountView do
    use BundWeb, :view
  
    def render("index.json", %{accounts: accounts, total: total}) do
      %{
        total: total,
        accounts: render_many(accounts, BundWeb.Api.AccountView, "account.json")
      }
    end
  
    def render("show.json", %{account: account}) do
      %{data: render_one(account, BundWeb.Api.AccountView, "account.json")}
    end
  
    def render("account.json", %{account: account}) do
      %{
        id: account.id,
        company: account.company,
        city: account.city,
        contact_person: account.contact_person,
        country: account.country, 
        email_address: account.email_address,
        note: account.note, 
        phone: account.phone,
        sector: account.sector, 
        state: account.state,
        status: account.status, 
        street: account.street, 
        inserted_at: account.inserted_at       
      }
    end
  
  
  end
  