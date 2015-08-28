defmodule Meagle.StatusController do
  use Meagle.Web, :controller

  def index(conn, _params) do
    status = Meagle.StatusStore.get_all_status
    config = Meagle.Config.all()

    json conn, %{status:  combine_config_with_status(config, status)}
  end

  defp combine_config_with_status(config, status) do 
    config
      |> Enum.reduce(%{}, fn ({service_name, urls}, acc) -> Dict.put(acc, service_name, get_status_for_urls(urls, status)) end )
  end

  defp get_status_for_urls(urls, status) do
    urls |> Enum.map(fn url -> %{url: url, status: format_status(Dict.get(status, url, "unknown"))} end)
  end

  defp format_all_status(status) do
    status |> Enum.reduce(%{}, fn ({key,value}, acc) -> Dict.put(acc, key, format_status(value)) end)
  end

  defp format_status(status) do
    now = :calendar.datetime_to_gregorian_seconds(:calendar.universal_time())
    status |> Dict.update! :last_update, fn time_updated -> "#{now - :calendar.datetime_to_gregorian_seconds(time_updated)}s ago" end
  end
end
