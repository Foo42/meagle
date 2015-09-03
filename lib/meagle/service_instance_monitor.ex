defmodule Meagle.ServiceInstanceMonitor do
  use GenServer
  require Logger
  alias Meagle.StatusUpdates

  def start_link(args) do
    %{target: target} = args
    Logger.info "#{inspect self()} target = #{target}"
    GenServer.start_link(__MODULE__,%{supervisor: self(), target: target})
  end

  defp schedule_status_check(seconds) do
    :erlang.send_after(seconds * 1000, self(), :check_status_timeout_elapsed)
  end

  #Server Implementation
  def init(args) do
    GenServer.cast self(), {:begin_checking} 
    {:ok, args}
  end

  def handle_cast({:begin_checking}, state) do
    schedule_status_check 1
    {:noreply, state}
  end

  def handle_info(:check_status_timeout_elapsed, state) do
    Logger.info "in handle info, checking status..."
    result = try_check_status(state)
    target = state[:target]
    StatusUpdates.notify_status_update target, result 
    Logger.info "result is #{inspect result}"
    schedule_status_check 10
    {:noreply, state |> Dict.put(:last_status, result)}
  end

  def handle_info({_some_reference, {:error, :req_timedout}}, state) do
    Logger.info "got some sort of timeout"
    {:noreply, state}
  end

  def handle_info(message, state) do
    Logger.info "recieved other info message: #{inspect message}"
    {:noreply, state}
  end

  defp try_check_status(state) do
    try do
      result = HTTPotion.get state[:target], [timeout: 45_000]
      IO.puts "HTTP GET: #{inspect result}"
      %{status_code: status_code} = result 
      status_code
    rescue
      e in HTTPotion.HTTPError -> :http_error
    end
  end
end
