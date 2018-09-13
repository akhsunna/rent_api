defmodule RentApi.Rent do
  @moduledoc """
  The Rent context.
  """

  import Ecto.Query, warn: false
  alias RentApi.Repo

  alias RentApi.Rent.Booking

  def get_bookings_list(query \\ Booking) do
    Repo.all(query)
  end

  def get_bookings_list_by_dates(from, to, query \\ Booking) do
    query
    |> where([b], b.start_date <= ^to and b.end_date >= ^from)
    |> Repo.all()
  end

  def filter_list_of_bookings_by_dates(from, to, bookings) do
    bookings
    |> Enum.filter(fn(b) -> b.start_date <= to and b.end_date >= from end)
  end

  def get_booking!(id), do: Repo.get!(Booking, id)

  # TODO: have to be refactored!!!
  def create_booking(attrs \\ %{}) do
    changeset = %Booking{} |> Booking.changeset(attrs)

    changeset =
      if changeset.valid? do
        item = Repo.get(RentApi.Stuff.Item, changeset.changes.item_id) |> Repo.preload([:bookings])
        bookings = filter_list_of_bookings_by_dates(
          changeset.changes.start_date,
          changeset.changes.end_date,
          item.bookings
        )
        if bookings != [] do
          %{changeset | valid?: false, errors: [dates: {"are not able", []} ]}
        else
          changeset
        end
      else
        changeset
      end

    Repo.insert(changeset)
  end

  def delete_booking(%Booking{} = booking) do
    Repo.delete(booking)
  end
end
