defmodule Meagle.EventRouter do
    require Logger
    use GenServer

    def start_link() do
    	Logger.info "starting EventRouter"
    	GenServer.start_link(__MODULE__, {})
    end

    def init(_args) do
    	Logger.info "initialising EventRouter"
    	worker = spawn_link(&send_structured_status_to_websockets/0)
    	{:ok, worker}
    end

    defp send_structured_status_to_websockets() do
    	Logger.info "Beginning to broadcast structured status updates to websocket listeners"
    	for update <- Meagle.StatusUpdates.structured_status_stream() do
	        Meagle.Endpoint.broadcast! "status:updates", "update", update
      	end
    end
end
