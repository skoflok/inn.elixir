defmodule Inn.Repo.Migrations.CreateTins do
  use Ecto.Migration

  def change do
    create table(:tins) do
      add :number, :bigserial, null: false
      add :ip, :string, null: false
      add :is_valid, :boolean, default: false, null: false

      timestamps()
    end

  end
end
