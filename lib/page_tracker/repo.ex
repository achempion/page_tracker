defmodule PageTracker.Repo do
  use Ecto.Repo,
    otp_app: :page_tracker,
    adapter: Ecto.Adapters.Postgres
end
