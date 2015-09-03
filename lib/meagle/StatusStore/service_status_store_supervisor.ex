defmodule Meagle.StatusStore.Supervisor do
	use Supervisor
	require Logger

	def start_link(opts \\ []) do
		Supervisor.start_link(__MODULE__, :ok, opts)
	end

	#Implementation

	def init(:ok) do
		children = [
			worker(Meagle.StatusStore, [])
		]
		Logger.info "Meagle.StatusStore.Supervisor starting"
		result = supervise(children, strategy: :one_for_one)
		Logger.info "Meagle.StatusStore.Supervisor started children #{inspect children}"
		result
	end
end
