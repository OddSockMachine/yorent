# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Yorent.Repo.insert!(%SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import String
import Ecto.Query
alias Yorent.Repo
alias Yorent.House
alias Yorent.Landlord
alias Yorent.City

# Starting city
# Repo.insert!(%City{name: "York"})
# york = Repo.one(from c in City, where: c.name == ^"York")
#
#
# # Create seed landlords
# landlords = [
#   %Landlord{:name => "Union Lets",
#             :type => "Letting Agent",
#             :website => "http://www.union-lets.co.uk/",
#             :city_id => york.id},
#   %Landlord{:name => "Sinclair Properties",
#             :type => "Letting Agent",
#             :website => "http://sinclair-properties.co.uk/",
#             :city_id => york.id},
#   %Landlord{:name => "Adam Bennet",
#             :type => "Letting Agent",
#             :website => "http://adambennett.co.uk/",
#             :city_id => york.id},
# ]
#
# Enum.each landlords, fn l -> IO.inspect l end
#
# for landlord <- landlords do
#   Repo.insert!(landlord)
# end

york = Repo.one(from c in City, where: c.name == ^"York")

union = Repo.one(from l in Landlord, where: l.name == ^"Union Lets")

IO.inspect union
IO.inspect york

{:ok, file} = File.read "./house_data/union_lets.json"
house_dict = Poison.decode! file
Enum.each house_dict, fn  {k, v} ->
  IO.puts(k)
  # detail = %{"available": v["available"],
  #            "bedrooms": v["num_bedrooms"],
  #            "parking": v["parking"],
  #            "price": v["pricepppw"],
  #          "website": k}
  # d = Poison.encode! detail
  h = %House{name: v["title"],
             postcode: v["postcode"],
             city_id: york.id,
             landlord_id: union.id,
             price: v["pricepppw"],
             }
  IO.inspect h
  Repo.insert!(h)
end
