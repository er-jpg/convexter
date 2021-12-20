defmodule ConvexterWeb.ConvertView do
  use ConvexterWeb, :view
  alias ConvexterWeb.ConvertView

  def render("index.json", %{conversions: conversions}) do
    %{data: render_many(conversions, ConvertView, "convert.json")}
  end

  def render("show.json", %{convert: convert}) do
    %{data: render_one(convert, ConvertView, "convert.json")}
  end

  def render("convert.json", %{convert: convert}) do
    %{
      id: convert.id,
      id_user: convert.id_user,
      origin_value: convert.origin_value,
      conversion_tax: convert.conversion_tax
    }
  end
end
