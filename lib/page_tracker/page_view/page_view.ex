defmodule PageTracker.PageView do
  use Ecto.Schema
  import Ecto.Changeset

  schema "page_views" do
    field :data, :map
    field :duration_ms, :integer
    field :page, :string
    field :session_id, Ecto.UUID
    field :uuid, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(page_view, attrs) do
    page_view
    |> cast(attrs, [:session_id, :page, :duration_ms, :uuid])
    |> validate_required([:session_id, :page, :duration_ms, :uuid])
  end
end
