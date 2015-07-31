defmodule RatesMeagle.ServiceInstanceMonitor.StatusStore do
  require Logger

  def start_link do
    Logger.info "=====================  in StatusStore"
    Agent.start_link(fn -> HashDict.new end)
  end
end
