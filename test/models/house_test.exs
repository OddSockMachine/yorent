defmodule Yorent.HouseTest do
  use Yorent.ModelCase

  alias Yorent.House

  @valid_attrs %{average_rating: "120.5", name: "some content", postcode: "some content", price: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = House.changeset(%House{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = House.changeset(%House{}, @invalid_attrs)
    refute changeset.valid?
  end
end
