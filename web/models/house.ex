defmodule Yorent.House do
  use Yorent.Web, :model

  schema "houses" do
    field :name, :string
    field :average_rating, :float
    field :postcode, :string
    field :price, :integer
    belongs_to :city, Yorent.City
    belongs_to :landlord, Yorent.Landlord

    timestamps
  end

  @required_fields ~w(name average_rating postcode price, city, landlord)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
