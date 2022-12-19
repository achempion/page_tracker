defmodule PageTrackerWeb.PageCLive do
  use PageTrackerWeb, :live_view

  alias PageTrackerWeb.PageCLive.{Tab1Component, Tab2Component}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    tab = params["tab"] || if(connected?(socket), do: Enum.random(~w[tab_1 tab_2]))
    title_tab = (tab || "") |> String.capitalize() |> String.replace("_", " ")

    {:noreply,
     assign(
       socket,
       tab: tab,
       page_title: "Page C, #{title_tab}"
     )}
  end
end
