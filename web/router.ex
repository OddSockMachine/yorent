defmodule Yorent.Router do
  use Yorent.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Yorent do
    pipe_through :browser # Use the default browser stack

    get       "/",          PageController, :index
    resources "/cities",    CityController do
      resources "/houses",    CityHouseController, only [:index]
      resources "/landlords", CityLandlordController, only [:index]
    end
    resources "/landlords", LandlordController do
      resources "/houses",    LandlordHouseController, only [:index]
    end
    resources "/houses",    HouseController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Yorent do
  #   pipe_through :api
  # end
end
