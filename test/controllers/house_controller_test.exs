defmodule Yorent.HouseControllerTest do
  use Yorent.ConnCase

  alias Yorent.House
  @valid_attrs %{average_rating: "120.5", name: "some content", postcode: "some content", price: 42}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, house_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing houses"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, house_path(conn, :new)
    assert html_response(conn, 200) =~ "New house"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, house_path(conn, :create), house: @valid_attrs
    assert redirected_to(conn) == house_path(conn, :index)
    assert Repo.get_by(House, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, house_path(conn, :create), house: @invalid_attrs
    assert html_response(conn, 200) =~ "New house"
  end

  test "shows chosen resource", %{conn: conn} do
    house = Repo.insert! %House{}
    conn = get conn, house_path(conn, :show, house)
    assert html_response(conn, 200) =~ "Show house"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, house_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    house = Repo.insert! %House{}
    conn = get conn, house_path(conn, :edit, house)
    assert html_response(conn, 200) =~ "Edit house"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    house = Repo.insert! %House{}
    conn = put conn, house_path(conn, :update, house), house: @valid_attrs
    assert redirected_to(conn) == house_path(conn, :show, house)
    assert Repo.get_by(House, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    house = Repo.insert! %House{}
    conn = put conn, house_path(conn, :update, house), house: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit house"
  end

  test "deletes chosen resource", %{conn: conn} do
    house = Repo.insert! %House{}
    conn = delete conn, house_path(conn, :delete, house)
    assert redirected_to(conn) == house_path(conn, :index)
    refute Repo.get(House, house.id)
  end
end
