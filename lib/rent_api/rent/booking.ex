defmodule RentApi.Rent.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :start_date, :date
    field :end_date, :date

    belongs_to :item, RentApi.Stuff.Item
    belongs_to :user, RentApi.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:start_date, :end_date, :item_id, :user_id])
    |> validate_required([:start_date, :end_date, :item_id, :user_id])
    |> validate_dates()
  end

  defp validate_dates(changeset) do
    validate_dates(changeset, get_field(changeset, :start_date), get_field(changeset, :end_date))
  end
  defp validate_dates(changeset, start_date, end_date) when start_date > end_date do
    add_error(changeset, :start_date, "cannot be more than end date")
  end
  defp validate_dates(changeset, _, _), do: changeset
end
