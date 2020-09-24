defmodule Inn.Checker.Tin do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:number, :ip, :is_valid, :inserted_at]}

  schema "tins" do
    field :ip, :string,  null: false
    field :is_valid, :boolean, default: false,  null: false
    field :number, :integer,  null: false

    timestamps()
  end

  @doc false
  def changeset(tin, attrs) do
    tin
    |> cast(attrs, [:number, :ip, :is_valid])
    |> validate_required([:number, :ip, :is_valid])
  end
end
