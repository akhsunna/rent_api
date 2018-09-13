defmodule RentApi.Repo.Migrations.CreateBookings do
  use Ecto.Migration

  def change do
    create table(:bookings) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :item_id, references(:items, on_delete: :delete_all), null: false
      add :start_date, :date, null: false
      add :end_date, :date, null: false

      timestamps()
    end
  end
end
