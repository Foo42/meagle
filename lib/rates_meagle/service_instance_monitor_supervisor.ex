defmodule RatesMeagle.ServiceInstanceMonitor.Supervisor do
	use Supervisor
	require Logger

	def start_link(opts \\ []) do
		Supervisor.start_link(__MODULE__, :ok, opts)
	end

	#Implementation

	def init(:ok) do
		children = build_workers
		Logger.info "RatesMeagle.ServiceInstanceMonitor.Supervisor starting"
		result = supervise(build_workers, strategy: :one_for_one)
		Logger.info "RatesMeagle.ServiceInstanceMonitor.Supervisor started children #{inspect children}"
		result
	end

	defp build_workers do
		RatesMeagle.ServiceInstance.Config.all |> Enum.map fn instance_config -> 
			worker(RatesMeagle.ServiceInstanceMonitor,[%{target: instance_config}], id: instance_config)
		end
	end
end
