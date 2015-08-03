defmodule Meagle.Router do
  use Meagle.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Meagle do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/status", Meagle do
    pipe_through :api
    get "/", StatusController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Meagle do
  #   pipe_through :api
  # end
end
