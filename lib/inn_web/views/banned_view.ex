defmodule InnWeb.BannedView do
  use InnWeb, :view
  alias InnWeb.BannedView

  def render("index.json", %{list: list, meta: meta}) do
    format render_many(list, BannedView, "banned.json"), true, "Ok", meta
  end

  def render("show.json", %{banned: banned, success: success, msg: msg}) do
    format render_one(banned, BannedView, "banned.json")
  end

  def render("banned.json", %{banned: banned}) do
    %{ip: banned.ip, time: banned.time}
  end

  defp format(data, success \\ true, msg \\ "", meta \\ %{}) do
    %{
      success: success,
      data: data,
      msg: msg,
      meta: meta
    }
  end
end
