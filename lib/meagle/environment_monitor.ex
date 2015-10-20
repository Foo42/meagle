defmodule Meagle.EnvironmentMonitor do
    require Logger
    use GenServer

    def start_link(environment_name) do
        Logger.info "Staring EnvironmentMonitor for #{environment_name}"
        GenServer.start_link(__MODULE__, environment_name, [name: via_name(environment_name)])
    end

    def init(environment_name) do
        Logger.info "init EnvironmentMonitor for #{environment_name}"
        config = Meagle.Config.all

        initaliseInstanceStatus = &(%{url: &1, status: %{}})

        # setup dictionary of services, to service instances with unknown statuses
        initial_state = config
            |> Enum.map(fn {serviceName,instances} -> {serviceName, Enum.map(instances,initaliseInstanceStatus)} end)
            |> Enum.into %{}

        # pull service instance status from status store (for the ones we have in there)
        initial_state = Meagle.StatusStore.get_all_status
            |> Enum.reduce(initial_state, &(update_with_status(&1, &2)))

        # subscribe to status updates and update from them
        subscribe_to_status_instance_updates(environment_name)

        # more things?
        {:ok, initial_state}
    end

    def get_status(environment) do
        GenServer.call(via_name(environment), {:get_status})
    end

    defp update_with_status(state, %{id: updated_instance_url, status: new_instance_status}) do
        services_using_instance = get_services_using_instance(state, updated_instance_url)
        services_using_instance
            |> Enum.map(&%{service_name: &1, instance_url: updated_instance_url, status: new_instance_status})
            |> Enum.each(&Meagle.StatusUpdates.notify_status_update/1)

        update_instance_with_status = fn
            instance ->
                case instance[:url] do
                    ^updated_instance_url -> %{url: updated_instance_url, status: %{last_status: new_instance_status, last_update: :calendar.universal_time()}}
                    _ -> instance
                end
        end

        state
            |> Enum.map(fn {service_name, instances} -> {service_name, Enum.map(instances, update_instance_with_status)} end)
            |> Enum.into %{}
    end


    defp subscribe_to_status_instance_updates(environment) do
        spawn_link fn ->
          for update <- Meagle.StatusUpdates.instance_status_stream do
            store_status(environment, update)
          end
        end
    end

    defp get_services_using_instance(state, instance_url) do
        has_instance = fn {_,v} ->
            Enum.any?(v,&(&1[:url] == instance_url))
        end

        to_service_name = fn {k,_} -> k end

         state |> Enum.filter_map(has_instance, to_service_name)
    end

    defp store_status(target_environment, update) do
        GenServer.call(via_name(target_environment), {:status_update, update})
    end

    def handle_call({:status_update, update = {id,status}}, _from, state) do
        state = update_with_status(state,%{id: id, status: status})

        {:reply, :ok, state}
    end

    def handle_call({:get_status}, _from, state), do: {:reply, state, state}

	  defp via_name(name), do: {:via, :gproc, {:n, :l, name}}
end
