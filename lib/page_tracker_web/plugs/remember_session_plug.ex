defmodule PageTrackerWeb.RememberSessionPlug do
  import Plug.Conn
  require Logger

  alias PageTracker.TrackingSession

  # 400 days
  # https://httpwg.org/http-extensions/draft-ietf-httpbis-rfc6265bis.html#attribute-max-age
  @max_age 34_560_000

  def init(default), do: default

  def call(conn, default) do
    case fetch_cookies(conn, signed: ~w(session-uuid)).cookies do
      %{"session-uuid" => uuid} ->
        set_cookie(conn, uuid)

      _ ->
        with {:ok, %{session_id: uuid}} <- create_session(conn) do
          set_cookie(conn, uuid)
        else
          error ->
            Logger.error(message: "Session can't be created", error: error)

            conn
        end
    end
  end

  defp create_session(conn),
    do:
      get_req_header(conn, "user-agent")
      |> Enum.join(", ")
      |> TrackingSession.UseCase.create()

  defp set_cookie(conn, uuid),
    do: put_resp_cookie(conn, "session-uuid", uuid, sign: true, max_age: @max_age)
end
