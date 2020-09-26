defmodule Inn.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bcrypt
  alias Bcrypt.Base

  schema "users" do
    field(:email, :string)
    field(:is_admin, :boolean, default: false)
    field(:is_operator, :boolean, default: false)
    field(:name, :string)
    field(:password_hash, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    
    attrs = hash_password(attrs)

    user
    |> cast(attrs, [:email, :name, :password_hash, :is_admin, :is_operator])
    |> validate_required([:email, :name, :password_hash, :is_admin, :is_operator])
  end

  defp hash_password(attrs) do
    Map.put(attrs, :password_hash,Base.hash_password(attrs.password, Bcrypt.gen_salt(4, false)))
  end

end
