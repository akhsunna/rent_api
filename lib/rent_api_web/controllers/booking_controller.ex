defmodule RentApiWeb.BookingController do
  use RentApiWeb, :controller

  alias RentApi.{Rent, Rent.Booking}

  action_fallback RentApiWeb.FallbackController
end
