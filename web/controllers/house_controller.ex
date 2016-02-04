defmodule Yorent.HouseController do
  use Yorent.Web, :controller

  alias Yorent.House

  plug :scrub_params, "house" when action in [:create, :update]

  def index(conn, _params) do
    houses = Repo.all(House)
    render(conn, "index.html", houses: houses)
  end

  def new(conn, _params) do
    changeset = House.changeset(%House{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"house" => house_params}) do
    changeset = House.changeset(%House{}, house_params)

    case Repo.insert(changeset) do
      {:ok, _house} ->
        conn
        |> put_flash(:info, "House created successfully.")
        |> redirect(to: house_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    house = Repo.get!(House, id)
    render(conn, "show.html", house: house)
  end

  def edit(conn, %{"id" => id}) do
    house = Repo.get!(House, id)
    changeset = House.changeset(house)
    render(conn, "edit.html", house: house, changeset: changeset)
  end

  def update(conn, %{"id" => id, "house" => house_params}) do
    house = Repo.get!(House, id)
    changeset = House.changeset(house, house_params)

    case Repo.update(changeset) do
      {:ok, house} ->
        conn
        |> put_flash(:info, "House updated successfully.")
        |> redirect(to: house_path(conn, :show, house))
      {:error, changeset} ->
        render(conn, "edit.html", house: house, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    house = Repo.get!(House, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(house)

    conn
    |> put_flash(:info, "House deleted successfully.")
    |> redirect(to: house_path(conn, :index))
  end
end
