defmodule Meagle.PageController do
  use Meagle.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
