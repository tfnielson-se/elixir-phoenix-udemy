defmodule Discuss.Discussions.Comment do
  # use DiscussWeb, :model
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:content, :user]}

  alias Discuss.Discussions.Comment

  schema "comments" do
    field :content, :string
    belongs_to :user, Discuss.Accounts.User
    belongs_to :topic, Discuss.Discussions.Topic

    timestamps()
    end

    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:content])
      |> validate_required([:content])
    end
end
