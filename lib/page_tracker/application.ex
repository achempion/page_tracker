defmodule PageTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PageTrackerWeb.Telemetry,
      # Start the Ecto repository
      PageTracker.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: PageTracker.PubSub},
      # Start Finch
      {Finch, name: PageTracker.Finch},
      # Start the Endpoint (http/https)
      PageTrackerWeb.Endpoint
      # Start a worker by calling: PageTracker.Worker.start_link(arg)
      # {PageTracker.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PageTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PageTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
