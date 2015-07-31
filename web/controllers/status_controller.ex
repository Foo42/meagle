defmodule RatesMeagle.StatusController do
  use RatesMeagle.Web, :controller

  def index(conn, _params) do
    status = RatesMeagle.StatusStore.get_all_status |> format_all_status

    json conn, %{status: status, hello: "world"}
  end

  defp format_all_status(status) do
  	status |> Enum.reduce(%{}, fn ({key,value}, acc) -> Dict.put(acc, key, format_status(value)) end)
  end

  defp format_status(status) do
  	now = :calendar.datetime_to_gregorian_seconds(:calendar.universal_time())
  	status |> Dict.update! :last_update, fn time_updated -> "#{now - :calendar.datetime_to_gregorian_seconds(time_updated)}s ago" end
  end
end
