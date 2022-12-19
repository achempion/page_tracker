defmodule PageTracker.PageView.UseCase do
  import Ecto.Query

  require Logger

  alias PageTracker.{PageView, Repo}

  def ingest(page_view) do
    PageView
    |> where(uuid: ^page_view["uuid"])
    |> update(set: [duration_ms: ^page_view["duration_ms"]])
    |> Repo.update_all([])
    |> case do
      {1, _} ->
        :ok

      {0, _} ->
        PageView.changeset(%PageView{}, page_view)
        |> Repo.insert()
        |> case do
          {:ok, _} ->
            :ok

          error = {:error, _} ->
            Logger.error(message: "Can't track view", error: error)
            :error
        end
    end
  end
end
