defmodule Meagle.EnvironmentRegistry do
	require Logger

	def start_link do
		Agent.start_link(fn -> %{} end, name: __MODULE__)
	end

	def register_environment(environment_name, pid) do
		Logger.info "registered environment monitor for #{environment_name}"
		Agent.update(__MODULE__, &Dict.put(&1, environment_name, pid))
	end

	def get_environment(environment_name) do
		Agent.get(__MODULE__, &Dict.get(&1, environment_name))
	end
end
