defmodule RentApi.RentTest do
  use RentApi.DataCase

  import RentApi.Factory

  alias RentApi.Rent

  describe "bookings" do
    alias RentApi.Rent.Booking

    test "create_booking/1 creates the bookings if attributes are valid" do
      user = insert(:user)
      item = insert(:item)

      attrs = %{item_id: item.id, user_id: user.id, start_date: ~D[2019-01-01], end_date: ~D[2019-02-01]}

      assert {:ok, %Rent.Booking{} = booking} = Rent.create_booking(attrs)
      assert booking.user_id == user.id
      assert booking.item_id == item.id
    end

    test "create_booking/1 returns an error if date-attributes are not valid" do
      user = insert(:user)
      item = insert(:item)
      booking = insert(:booking, %{item: item})

      attrs = %{item_id: item.id, user_id: user.id, start_date: booking.start_date, end_date: booking.end_date}

      assert {:error, %Ecto.Changeset{}} = Rent.create_booking(attrs)
    end
  end
end
