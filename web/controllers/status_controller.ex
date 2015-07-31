defmodule RatesMeagle.StatusController do
  use RatesMeagle.Web, :controller

  def index(conn, _params) do
    status = RatesMeagle.ServiceInstanceMonitor.check_status()
    json conn, %{status: status}
  end
end
