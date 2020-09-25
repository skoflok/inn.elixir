defmodule InnWeb.TinView do
  use InnWeb, :view
  alias InnWeb.TinView

  def render("index.json", %{tins: tins, meta: meta}) do
    format render_many(tins, TinView, "tin.json"), true, "Ok", meta
  end

  def render("show.json", %{tin: tin, success: success, msg: msg}) do
    format render_one(tin, TinView, "tin.json")
  end

  def render("tin.json", %{tin: tin}) do
    %{id: tin.id, number: tin.number, ip: tin.ip, is_valid: tin.is_valid, inserted_at: tin.inserted_at}
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
