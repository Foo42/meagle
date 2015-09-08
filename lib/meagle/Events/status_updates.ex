defmodule Meagle.StatusUpdates do
	def start_link() do
		GenEvent.start_link name: __MODULE__
	end

	def notify_status_update(what, status) do
		GenEvent.notify __MODULE__, {what, status}
	end

	def notify_status_update(update) do
		GenEvent.notify __MODULE__, update
	end

	def instance_status_stream do
		GenEvent.stream(__MODULE__) |> Stream.filter(&is_instance_update?/1)
	end

	def structured_status_stream do
		GenEvent.stream(__MODULE__) |> Stream.filter(&is_structured_status_update?/1)
	end

	defp is_instance_update?({what, status}), do: true
	defp is_instance_update?(_), do: false

	defp is_structured_status_update?(%{service_name: _}), do: true
	defp is_structured_status_update?(_), do: false
end
