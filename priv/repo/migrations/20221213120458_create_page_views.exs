defmodule PageTracker.Repo.Migrations.CreatePageViews do
  use Ecto.Migration

  def change do
    create table(:page_views) do
      add :session_uuid, :uuid
      add :page, :string
      add :duration_ms, :integer
      add :data, :map
      add :uuid, :uuid

      timestamps()
    end

    create unique_index(:page_views, :uuid)
  end
end
