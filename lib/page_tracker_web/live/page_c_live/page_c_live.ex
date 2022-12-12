defmodule PageTrackerWeb.PageCLive do
  use PageTrackerWeb, :live_view

  alias PageTrackerWeb.PageCLive.{Tab1Component, Tab2Component}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, socket |> assign(:tab, params["tab"])}
  end
end
