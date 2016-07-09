defmodule PadelChampionships.User do
  @moduledoc false

  use PadelChampionships.Web, :model
  alias Comeonin.Bcrypt

  @derive {Poison.Encoder, only: [:id, :email]}

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :encrypted_password, :string
    field :photo, :string
    field :telephone, :string
    field :level, :string
    field :password, :string, virtual: true

    timestamps
  end

  @validate_length_first_name [
    max: 50,
    message: "El nombre no puede ser superior a %{count} caracter(es)"
  ]

  @validate_length_telephone [
    min: 9,
    message: "El teléfono no puede ser menor a %{count} digitos"
  ]

  @validate_length_password [
    min: 5,
    message: "La contraseña no puede ser menor a %{count} caracter(es)"
  ]

  @required_fields ~w(first_name last_name email telephone level password)
  @optional_fields ~w(photo encrypted_password)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/@/, message: "El email no es valido")
    |> validate_length(:first_name, @validate_length_first_name)
    |> validate_length(:last_name, @validate_length_first_name)
    |> validate_length(:telephone, @validate_length_telephone)
    |> validate_length(:password, @validate_length_password)
    |> validate_confirmation(:password, message: "La contraseña no coinciden")
    |> unique_constraint(:email, message: "El email esta registrado")
    |> generate_encrypted_password
  end

  defp generate_encrypted_password(changeset) do
   case changeset do
     %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
       changeset
       |> put_change(:encrypted_password, Bcrypt.hashpwsalt(password))
     _ ->
       changeset
   end
 end
end
