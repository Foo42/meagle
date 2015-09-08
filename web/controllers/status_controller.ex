defmodule Meagle.StatusController do
  use Meagle.Web, :controller

  def index(conn, _params) do
   all_status = Meagle.EnvironmentRegistry.get_environment("INT")
      |> Meagle.EnvironmentMonitor.get_status
      |> Enum.map(fn {service, instances} -> {service, Enum.map(instances, &format_instance_status(&1))} end)
      |> Enum.into(%{})

    json conn, %{status:  all_status}
  end

  defp format_instance_status(%{url: url, status: status}) do
    now = :calendar.datetime_to_gregorian_seconds(:calendar.universal_time())
    new_status = status |> Dict.update! :last_update, fn time_updated -> "#{now - :calendar.datetime_to_gregorian_seconds(time_updated)}s ago" end
    %{url: url, status: new_status}
  end
end
