defmodule RentApi.Stuff.ItemFilter do
  import Ecto.Query

  alias RentApi.Repo

  def by_name(query, params) do
    (params["name"] || params[:name] || "")
    |> case do
         "" -> query
         name -> query |> where([i], ilike(i.name, ^("%#{name}%")))
       end
  end

  def by_category(query, params) do
    category_ids = params["category_ids"] || params[:category_ids] || [""]
    cond do
      category_ids == [""] -> query
      is_binary(category_ids) ->
        query |> where([i], i.category_id == ^category_ids)
      true ->
        query |> where([i], i.category_id in ^category_ids)
    end
  end

  # TODO: improve it
  def available(query, params) do
    start_date_param = params["start_date"] || params[:start_date] || ""
    end_date_param = params["end_date"] || params[:end_date] || ""

    today = Date.utc_today

    {{:ok, start_date}, {:ok, end_date}} =
      case {start_date_param, end_date_param} do
        {"", ""} -> {Ecto.Date.cast(today), Ecto.Date.cast(today)}
        {"", end_date_param} -> {Ecto.Date.cast(today), Date.from_iso8601(end_date_param)}
        {start_date_param, ""} -> {Date.from_iso8601(start_date_param), Ecto.Date.cast(today)}
        {start_date_param, end_date_param} -> {Date.from_iso8601(start_date_param), Date.from_iso8601(end_date_param)}
      end

    {start_date, end_date} = if start_date > end_date, do: {end_date, start_date}, else: {start_date, end_date}

    from(
      items in query,
      left_join: bookings in RentApi.Rent.Booking,
      on: items.id == bookings.item_id,
      where: bookings.start_date >= ^end_date or
             bookings.end_date < ^start_date or
             is_nil(bookings.start_date),
      order_by: items.name
    )
  end
end
