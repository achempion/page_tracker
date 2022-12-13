defmodule PageTrackerWeb.PageALive do
  use PageTrackerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(page_title: "Page A")}
  end
end
