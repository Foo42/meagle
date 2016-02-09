defmodule Meagle.ServiceInstanceMonitor.Supervisor do
	use Supervisor
	require Logger

	def start_link(opts \\ []) do
		Supervisor.start_link(__MODULE__, :ok, opts)
	end

	#Implementation

	def init(:ok) do
		children = build_workers
		Logger.info "Meagle.ServiceInstanceMonitor.Supervisor starting"
		result = supervise(build_workers, strategy: :one_for_one)
		Logger.info "Meagle.ServiceInstanceMonitor.Supervisor started children #{inspect children}"
		result
	end

	defp build_workers do
		Meagle.Config.all |>
			Enum.map(fn {_service, instances} -> instances end) |>
			List.flatten |>
			Enum.map(fn instance_config ->
				worker(Meagle.ServiceInstanceMonitor,[instance_config], id: instance_config)
			end)
	end
end
