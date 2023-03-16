defmodule Discuss.Accounts.User do

  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.Accounts.User

  @derive {Jason.Encoder, only: [:email]}
  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string
    has_many :topics, Discuss.Discussions.Topic
    has_many :comments, Discuss.Discussions.Comment

    timestamps()
  end

  # iex -S mix -> Discuss.Repo.get(Discuss.Accounts.User. 1)

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end


end
