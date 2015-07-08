defmodule RatesMeagle.StatusController do
  use RatesMeagle.Web, :controller

  def index(conn, _params) do
    json conn, %{status: "unknown"}
  end
end
