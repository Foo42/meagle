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
    :erlang.send_after(seconds * 1000, self(), :check_status_due)
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

  def handle_info(:check_status_due, state) do
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
      HTTPotion.get(state[:target], [timeout: 45_000]) |> extract_status_result
    rescue
      e in HTTPotion.HTTPError -> 
        %{summary: "Bad", detail: %{http_error: true}}
    end
  end

  def extract_status_result(%{status_code: 200, body: body}) do
    %{summary: "OK"} |> add_status_details(body)
  end

  def extract_status_result(%{status_code: status_code}) do
    %{summary: "Bad", detail: %{status_code: status_code}}
  end

  defp add_status_details(result, body) do
    case Poison.Parser.parse(body) do
      {:ok, json_body} -> result |> Dict.put(:detail, json_body)
      _ -> result
    end
  end
end
