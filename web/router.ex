defmodule Potion.Router do
  use Potion.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Potion.CurrentUserPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Potion do
    pipe_through :browser # Use the default browser stack

    # home
    get "/", PageController, :index

    # resources
    resources "/users", UserController do
      resources "/posts", PostController
    end

    resources "/posts", PostController, only: [] do
      resources "/comments", CommentController, only: [:create, :delete, :update]
    end

    resources "/login", SessionController, only: [:index, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Potion do
  #   pipe_through :api
  # end
end
