defmodule PageTrackerWeb.PageCLive.Tab2Component do
  use PageTrackerWeb, :live_component

  def render(assigns) do
    ~H"""
    <div><.link navigate={~p"/page_a"} class="text-blue-500 underline ">Page A</.link></div>
    """
  end
end
