defmodule Meagle.StatusUpdates do
	def start_link() do
		GenEvent.start_link name: __MODULE__
	end

	def notify_status_update(what, status) do
		GenEvent.notify __MODULE__, {what, status}
	end

	def instance_status_stream do
		GenEvent.stream __MODULE__
	end
end
