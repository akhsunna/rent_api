defmodule RentApi.Stuff.ItemFilter do
  import Ecto.Query

  alias RentApi.Repo

  def by_name(query, params) do
    (params["name"] || params[:name])
    |> case do
         nil -> query
         "" -> query
         name -> query |> where([i], ilike(i.name, ^("%#{name}%")))
       end
  end

  def by_category(query, params) do
    category_ids = params["category_ids"] || params[:category_ids]
    cond do
      category_ids == nil -> query
      category_ids == [""] -> query
      is_binary(category_ids) ->
        query |> where([i], i.category_id == ^category_ids)
      true ->
        query |> where([i], i.category_id in ^category_ids)
    end
  end
end
