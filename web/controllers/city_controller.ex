defmodule Yorent.CityController do
  use Yorent.Web, :controller

  alias Yorent.City
  alias Yorent.Landlord
  alias Yorent.House
  plug :scrub_params, "city" when action in [:create, :update]

  def index(conn, _params) do
    cities = Repo.all(City)

    num_houses = (Repo.all from c in City, left_join: h in assoc(c, :houses), select: {c.id, count(h.id)}, group_by: c.id)
                  |> Enum.into(%{})
    cities = Enum.map(cities, fn(c) -> Map.merge(c, %{"num_houses": num_houses[c.id]}) end)

    num_landlords = (Repo.all from c in City, left_join: l in assoc(c, :landlords), select: {c.id, count(l.id)}, group_by: c.id)
                  |> Enum.into(%{})
    cities = Enum.map(cities, fn(c) -> Map.merge(c, %{"num_landlords": num_landlords[c.id]}) end)

    render(conn, "index.html", cities: cities)
  end

  def new(conn, _params) do
    changeset = City.changeset(%City{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"city" => city_params}) do
    changeset = City.changeset(%City{}, city_params)

    case Repo.insert(changeset) do
      {:ok, _city} ->
        conn
        |> put_flash(:info, "City created successfully.")
        |> redirect(to: city_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    city = Repo.get!(City, id)
    num_landlords = Repo.all(from l in Landlord, where: l.city_id == ^id, select: count(l.id))
    num_houses = Repo.all(from h in House, where: h.city_id == ^id, select: count(h.id))
    # Returns char array, need to convert to string/int instead of byte
    [num_houses | _] = num_houses
    [num_landlords | _] = num_landlords
    render(conn, "show.html", city: city,
                              num_landlords: num_landlords,
                              num_houses: num_houses)
  end

  def edit(conn, %{"id" => id}) do
    city = Repo.get!(City, id)
    changeset = City.changeset(city)
    render(conn, "edit.html", city: city, changeset: changeset)
  end

  def update(conn, %{"id" => id, "city" => city_params}) do
    city = Repo.get!(City, id)
    changeset = City.changeset(city, city_params)

    case Repo.update(changeset) do
      {:ok, city} ->
        conn
        |> put_flash(:info, "City updated successfully.")
        |> redirect(to: city_path(conn, :show, city))
      {:error, changeset} ->
        render(conn, "edit.html", city: city, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    city = Repo.get!(City, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(city)

    conn
    |> put_flash(:info, "City deleted successfully.")
    |> redirect(to: city_path(conn, :index))
  end
end
