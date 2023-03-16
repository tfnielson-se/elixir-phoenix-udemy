# this is the equivalent to a Model in RoR
defmodule Discuss.Discussions.Topic do
  # AppName.Context.Model
  use Ecto.Schema
  import Ecto.Changeset

  alias Discuss.Discussions.Topic

  schema "topics" do
    field :title, :string
    belongs_to :user, Discuss.Accounts.User
    has_many :comments, Discuss.Discussions.Comment

    timestamps()
  end

  # validation
  # struct = record in db
  # params = new properties we are updating struct with
  def changeset(struct, params \\ %{}) do
    struct
    # produces a changeset
    |> cast(params, [:title])
    # validators
    |> validate_required([:title])
  end
end

# enter intertactive shell  iex -S mix
# iex()> alias Discuss.Discussions.Topic
# iex()> struct = %Topic{}
# iex()> params = %{title: "XYZ"}
# iex()> Topic.changeset(struct, params)
# #Ecto.Changeset<
#   action: nil,
#   changes: %{title: "the best"},
#   errors: [],
#   data: #Discuss.Discussions.Topic<>,
#   valid?: true
# >

#   iex(9)> Topic.changeset(struct, %{})
# Ecto.Changeset<
#   action: nil,
#   changes: %{},
#   errors: [title: {"can't be blank", [validation: :required]}], <--------
#   data: #Discuss.Discussions.Topic<>,
#   valid?: false
# >

# @doc false
# def changeset(topic, attrs) do
#   topic
#   |> cast(attrs, [:title])
#   |> validate_required([:title])
# end
