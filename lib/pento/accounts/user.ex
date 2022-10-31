defmodule Pento.Accounts.User do
  use Ecto.Schema

  schema "users" do
    field :email, :string
  end
end
