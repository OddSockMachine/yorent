defmodule Yorent.Repo.Migrations.CreateLandlord do
  use Ecto.Migration

  def change do
    create table(:landlords) do
      add :name, :string
      add :type, :string
      add :average_rating, :float
      add :website, :string
      add :city_id, references(:cities)

      timestamps
    end
    create index(:landlords, [:city_id])

  end
end
