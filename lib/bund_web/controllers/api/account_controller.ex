defmodule BundWeb.Api.AccountController do
    use BundWeb, :controller
    alias Bund.Accounts
    #alias Bund.Accounts.Account
  
       def index(conn, params) do
      #     account = Accounts.list_accounts()
      #     json(conn, account)
     
      %{"insert_time" => insert_time} = params    

      cond do
        insert_time == "" ->
        account = Accounts.list_accounts()
        json(conn, account)
        true ->       
          account =  Accounts.list_accounts_by_insertedDate(insert_time)
          json(conn, account) 
        # true ->
        #   render(conn, "index.json", accounts: [], total: [])
      end
    end
  
    @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
    def show(conn, %{"id" => id}) do
      account = Accounts.get_account!(id)
      json(conn, account)
      # render(conn, "show.json", account: account)
    end
  
    @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
    def create(conn, %{"account" => account_params}) do
      case Accounts.create_account(account_params) do
        {:ok, account} ->         
          json(conn, %{account: account})  
        {:error, %Ecto.Changeset{} = changeset} ->
          # render(conn, "new.html", changeset: changeset)
          json(conn, %{changeset: changeset.errors[:title]})
      end
    end
  
    def update(conn, %{"id" => id, "account" => account_params}) do
      # id = Map.get(account_params, "id")
      account = Accounts.get_account!(id)
  
      case Accounts.update_account(account, account_params) do
        {:ok, account} ->
          json(conn, %{account: account})
  
        {:error, %Ecto.Changeset{} = changeset} ->
          json(conn, %{changeset: changeset.errors[:title]})
          # render(conn, "edit.html", account: account, changeset: changeset)
      end
    end
  
end
  