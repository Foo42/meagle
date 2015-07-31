defmodule RatesMeagle.StatusStore.Supervisor do
	use Supervisor
	require Logger

	def start_link(opts \\ []) do
		Supervisor.start_link(__MODULE__, :ok, opts)
	end

	#Implementation

	def init(:ok) do
		children = [
			worker(RatesMeagle.StatusStore, [])
		]
		Logger.info "RatesMeagle.StatusStore.Supervisor starting"
		result = supervise(children, strategy: :one_for_one)
		Logger.info "RatesMeagle.StatusStore.Supervisor started children #{inspect children}"
		result
	end
end
