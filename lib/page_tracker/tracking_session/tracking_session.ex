defmodule PageTracker.TrackingSession do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tracking_session" do
    field :browser_agent, :string
    field :session_id, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(tracking_session, attrs) do
    tracking_session
    |> cast(attrs, [:browser_agent, :session_id])
    |> validate_required([:browser_agent, :session_id])
  end
end
