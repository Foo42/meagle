defmodule Meagle.StatusControllerTests do
  use Meagle.ConnCase

  test "GET /status" do
    conn = conn()
      |> put_req_header("accept", "application/json")
      |> get("/status")
    assert  %{"status" => _} = json_response(conn, 200)
  end
end
