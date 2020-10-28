defmodule Bund.AccountsTest do
  use Bund.DataCase

  alias Bund.Accounts

  describe "accounts" do
    alias Bund.Accounts.Account

    @valid_attrs %{city: "some city", company: "some company", contact_person: "some contact_person", country: "some country", email_address: "some email_address", note: "some note", phone: "some phone", sector: "some sector", state: "some state", status: "some status", street: "some street"}
    @update_attrs %{city: "some updated city", company: "some updated company", contact_person: "some updated contact_person", country: "some updated country", email_address: "some updated email_address", note: "some updated note", phone: "some updated phone", sector: "some updated sector", state: "some updated state", status: "some updated status", street: "some updated street"}
    @invalid_attrs %{city: nil, company: nil, contact_person: nil, country: nil, email_address: nil, note: nil, phone: nil, sector: nil, state: nil, status: nil, street: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Accounts.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Accounts.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Accounts.create_account(@valid_attrs)
      assert account.city == "some city"
      assert account.company == "some company"
      assert account.contact_person == "some contact_person"
      assert account.country == "some country"
      assert account.email_address == "some email_address"
      assert account.note == "some note"
      assert account.phone == "some phone"
      assert account.sector == "some sector"
      assert account.state == "some state"
      assert account.status == "some status"
      assert account.street == "some street"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Accounts.update_account(account, @update_attrs)
      assert account.city == "some updated city"
      assert account.company == "some updated company"
      assert account.contact_person == "some updated contact_person"
      assert account.country == "some updated country"
      assert account.email_address == "some updated email_address"
      assert account.note == "some updated note"
      assert account.phone == "some updated phone"
      assert account.sector == "some updated sector"
      assert account.state == "some updated state"
      assert account.status == "some updated status"
      assert account.street == "some updated street"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_account(account, @invalid_attrs)
      assert account == Accounts.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Accounts.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Accounts.change_account(account)
    end
  end
end
