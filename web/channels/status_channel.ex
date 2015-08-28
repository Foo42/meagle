defmodule Meagle.StatusChannel do
  use Phoenix.Channel
  require Logger

  def join("status:updates", auth_msg, socket) do
	Logger.info "Connection joined channel"  	
    {:ok, socket}
  end
end
