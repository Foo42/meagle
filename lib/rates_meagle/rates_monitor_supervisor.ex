defmodule RatesMeagle.Monitor.Supervisor do
	use Supervisor
	require Logger

	def start_link(opts \\ []) do
		Supervisor.start_link(__MODULE__, :ok, opts)
	end

	#Implementation

	def init(:ok) do
		children = [
		]
		Logger.info "RatesMeagle.Monitor.Supervisor starting"
		supervise(children, strategy: :one_for_one)
	end
end
