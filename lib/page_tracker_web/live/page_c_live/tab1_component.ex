defmodule PageTrackerWeb.PageCLive.Tab1Component do
  use PageTrackerWeb, :live_component

  def render(assigns) do
    ~H"""
    <div><.link navigate={~p"/page_b"} class="text-blue-500 underline ">Page B</.link></div>
    """
  end
end
