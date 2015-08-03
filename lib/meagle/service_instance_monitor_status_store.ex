defmodule Meagle.StatusStore do
  require Logger
  alias Meagle.StatusUpdates

  def start_link do
    Logger.info "in StatusStore start_link"
    result = Agent.start_link(fn -> %{} end, name: __MODULE__)

    spawn_link fn ->
      for {id, status} <- StatusUpdates.instance_status_stream do
        IO.puts "storing from stream..."
        store_status(:service_instance, id, status)
      end
    end

    result
  end

  def store_status(:service_instance, id, status) do
  	Logger.info "storing status update for #{inspect id}: #{inspect status}"
  	Agent.update(__MODULE__, &Dict.put(&1, id, %{last_status: status, last_update: :calendar.universal_time()}))
  end

  def get_all_status do
  	Agent.get(__MODULE__, fn state -> state end)
  end
end
