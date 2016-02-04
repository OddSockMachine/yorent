defmodule Yorent.LandlordTest do
  use Yorent.ModelCase

  alias Yorent.Landlord

  @valid_attrs %{average_rating: "120.5", name: "some content", type: "some content", website: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Landlord.changeset(%Landlord{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Landlord.changeset(%Landlord{}, @invalid_attrs)
    refute changeset.valid?
  end
end
