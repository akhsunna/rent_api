defmodule RentApi.Stuff.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string

    belongs_to :owner, RentApi.Accounts.User
    belongs_to :category, RentApi.Stuff.Category

    has_many :bookings, RentApi.Rent.Booking, on_delete: :delete_all

    timestamps()
  end

  def changeset(item, attrs) do
    item
    |> cast(attrs, [:name, :owner_id, :category_id])
    |> validate_required([:name, :owner_id, :category_id])
  end
end
