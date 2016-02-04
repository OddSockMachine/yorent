defmodule Yorent.Landlord do
  use Yorent.Web, :model
  import Ecto.Query

  schema "landlords" do
    field :name, :string
    field :type, :string
    field :average_rating, :float
    field :website, :string
    belongs_to :city, Yorent.City
    has_many :houses, Yorent.House

    timestamps
  end

  @required_fields ~w(name type website)
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
