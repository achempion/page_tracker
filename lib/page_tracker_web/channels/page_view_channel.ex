defmodule PageTrackerWeb.PageViewChannel do
  use PageTrackerWeb, :channel

  alias PageTracker.PageView

  @impl true
  def join("page_view:presence", payload, socket) do
    with {:ok, session_uuid} <- authorize(payload["session_uuid"]) do
      {:ok, assign(socket, session_uuid: session_uuid)}
    else
      _ -> {:error, %{reason: "unauthorized"}}
    end
  end

  # %{
  #   "presence_ms" => 42724,
  #   "url" => "http://localhost:4000/page_c/tab_1",
  #   "uuid" => "069e28dc-93d7-4642-b975-203526ac862a"
  # }
  @impl true
  def handle_in("sync", presence, socket) do
    with {:liveview, liveview} <- detect_module(presence["url"]) do
      %{
        "session_id" => socket.assigns.session_uuid,
        "page" => liveview,
        "duration_ms" => presence["presence_ms"],
        "uuid" => presence["uuid"]
      }
      |> PageView.UseCase.ingest()
    end

    {:noreply, socket}
  end

  defp authorize(signed_session_uuid),
    do:
      Plug.Crypto.verify(
        PageTrackerWeb.Endpoint.config(:secret_key_base),
        "session-uuid_cookie",
        signed_session_uuid,
        keys: Plug.Keys
      )

  defp detect_module(url) do
    %{host: host, path: path} = URI.parse(url)

    Phoenix.Router.route_info(PageTrackerWeb.Router, "GET", path, host)
    |> case do
      %{phoenix_live_view: _, log_module: name} -> {:liveview, to_string(name)}
      _ -> :not_liveview
    end
  end
end
