defmodule Yorent.CityLandlordController do
  use Yorent.Web, :controller

  alias Yorent.Landlord
  alias Yorent.House
  alias Yorent.City
  import Ecto.Query

  plug :scrub_params, "landlord" when action in [:create, :update]

  def index(conn, %{"city_id" => city_id}) do
    # Get landlords, preload city for name
    city = Repo.get!(City, city_id)
    landlords = Repo.all(Landlord) #|> where([c] c.city_id == city_id)
    # Get a map of landlord_id to number of houses
    num_houses = (Repo.all from l in Landlord, left_join: h in assoc(l, :houses), select: {l.id, count(h.id)}, group_by: l.id)
                  |> Enum.into(%{})
    # Merge num_houses into Landlord struct (creating a new map that looks like Landlord)
    landlords = Enum.map(landlords, fn(l) -> Map.merge(l, %{"num_houses": num_houses[l.id]}) end)

    render(conn, "index.html", landlords: landlords)
  end

  def new(conn, _params) do
    changeset = Landlord.changeset(%Landlord{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"landlord" => landlord_params}) do
    changeset = Landlord.changeset(%Landlord{}, landlord_params)

    case Repo.insert(changeset) do
      {:ok, _landlord} ->
        conn
        |> put_flash(:info, "Landlord created successfully.")
        |> redirect(to: landlord_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"city_id" => city_id, "id" => id}) do
    city = Repo.get!(City, city_id)
    landlord = Repo.get!(Landlord, id) |> Repo.preload(:houses) |> Repo.preload(:city)
    # num_houses = House |> where([h], h.landlord_id == ^id) |> select([h], count(h.id)) |> Repo.one!
    # IO.inspect num_houses
    render(conn, "show.html", landlord: landlord)
  end

  def edit(conn, %{"id" => id}) do
    landlord = Repo.get!(Landlord, id)
    changeset = Landlord.changeset(landlord)
    render(conn, "edit.html", landlord: landlord, changeset: changeset)
  end

  def update(conn, %{"id" => id, "landlord" => landlord_params}) do
    landlord = Repo.get!(Landlord, id)
    changeset = Landlord.changeset(landlord, landlord_params)

    case Repo.update(changeset) do
      {:ok, landlord} ->
        conn
        |> put_flash(:info, "Landlord updated successfully.")
        |> redirect(to: landlord_path(conn, :show, landlord))
      {:error, changeset} ->
        render(conn, "edit.html", landlord: landlord, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    landlord = Repo.get!(Landlord, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(landlord)

    conn
    |> put_flash(:info, "Landlord deleted successfully.")
    |> redirect(to: landlord_path(conn, :index))
  end
end
