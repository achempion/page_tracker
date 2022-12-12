defmodule PageTracker.TrackingSession.UseCase do
  import Ecto.Query

  alias PageTracker.{Repo, TrackingSession}

  def create(user_agent) do
    TrackingSession.changeset(%TrackingSession{}, %{
      "browser_agent" => user_agent,
      "session_id" => Ecto.UUID.generate()
    })
    |> Repo.insert()
  end
end
