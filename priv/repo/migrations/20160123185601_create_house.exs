defmodule Yorent.Repo.Migrations.CreateHouse do
  use Ecto.Migration

  def change do
    create table(:houses) do
      add :name, :string
      add :average_rating, :float
      add :postcode, :string
      add :price, :integer
      add :city_id, references(:cities)
      add :landlord_id, references(:landlords)

      timestamps
    end
    create index(:houses, [:city_id])
    create index(:houses, [:landlord_id])

  end
end
