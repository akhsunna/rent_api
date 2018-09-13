defmodule RentApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :email, :string
    field :password_hash, :string

    has_many :items, RentApi.Stuff.Item, foreign_key: :owner_id, on_delete: :delete_all

    field :password, :string, virtual: true

    timestamps()
  end

  def changeset(user, attrs) do
    required_fields = if user.id, do: [:email], else: [:email, :password]

    user
    |> cast(attrs, [:email, :password])
    |> validate_required(required_fields)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}}
      ->
        put_change(changeset, :password_hash, hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
