defmodule PageTracker.Repo.Migrations.CreateTrackingSession do
  use Ecto.Migration

  def change do
    create table(:tracking_session) do
      add :browser_agent, :string
      add :session_id, :uuid

      timestamps()
    end

    create unique_index(:tracking_session, :session_id)
  end
end
