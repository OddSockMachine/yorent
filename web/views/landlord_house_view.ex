defmodule Yorent.LandlordHouseView do
  use Yorent.Web, :view
  def view_price(p) do
    p_str = Integer.to_string(p)
    len = String.length(p_str)
    pounds = String.slice(p_str, 0,  len - 2)
    pence = String.slice(p_str, len - 2,  len)
    "£" <> pounds <> "." <> pence
  end

  def extract_features(house) do
    # Look at all the info about a house, and extract the most useful features
    # to show on the listing card
    house.name
  end
end
