defmodule ConvexterWeb.ConvertView do
  use ConvexterWeb, :view
  alias ConvexterWeb.ConvertView

  def render("index.json", %{conversions: conversions}) do
    %{data: render_many(conversions, ConvertView, "convert.json")}
  end

  def render("show.json", %{convert: convert}) do
    %{data: render_one(convert, ConvertView, "convert.json")}
  end

  def render("convert.json", %{
        convert: %{target_value: target_value, conversion_tax: conversion_tax} = convert
      }) do
    total_value =
      target_value
      |> Decimal.mult(conversion_tax)
      |> Decimal.add(target_value)

    %{
      id: convert.id,
      id_user: convert.id_user,
      origin_value: convert.origin_value,
      origin_currency: convert.origin_currency,
      target_currency: convert.target_currency,
      conversion_tax: conversion_tax,
      target_value: target_value,
      conversion_date: convert.inserted_at,
      total_value: total_value
    }
  end
end
