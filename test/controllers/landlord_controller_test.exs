defmodule Yorent.LandlordControllerTest do
  use Yorent.ConnCase

  alias Yorent.Landlord
  @valid_attrs %{average_rating: "120.5", name: "some content", type: "some content", website: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, landlord_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing landlords"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, landlord_path(conn, :new)
    assert html_response(conn, 200) =~ "New landlord"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, landlord_path(conn, :create), landlord: @valid_attrs
    assert redirected_to(conn) == landlord_path(conn, :index)
    assert Repo.get_by(Landlord, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, landlord_path(conn, :create), landlord: @invalid_attrs
    assert html_response(conn, 200) =~ "New landlord"
  end

  test "shows chosen resource", %{conn: conn} do
    landlord = Repo.insert! %Landlord{}
    conn = get conn, landlord_path(conn, :show, landlord)
    assert html_response(conn, 200) =~ "Show landlord"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, landlord_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    landlord = Repo.insert! %Landlord{}
    conn = get conn, landlord_path(conn, :edit, landlord)
    assert html_response(conn, 200) =~ "Edit landlord"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    landlord = Repo.insert! %Landlord{}
    conn = put conn, landlord_path(conn, :update, landlord), landlord: @valid_attrs
    assert redirected_to(conn) == landlord_path(conn, :show, landlord)
    assert Repo.get_by(Landlord, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    landlord = Repo.insert! %Landlord{}
    conn = put conn, landlord_path(conn, :update, landlord), landlord: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit landlord"
  end

  test "deletes chosen resource", %{conn: conn} do
    landlord = Repo.insert! %Landlord{}
    conn = delete conn, landlord_path(conn, :delete, landlord)
    assert redirected_to(conn) == landlord_path(conn, :index)
    refute Repo.get(Landlord, landlord.id)
  end
end
