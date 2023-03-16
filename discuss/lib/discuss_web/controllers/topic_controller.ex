defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  import Ecto

  alias Discuss.Repo
  # alias Discuss.Discussions
  alias Discuss.Discussions.Topic

  plug(DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete])
  # fn plug
  plug(:check_topic_owner when action in [:update, :edit, :delete])

  # def changeset(struct, params \\ %{}) do
  #   struct
  #   |> cast(params, [:title])
  #   |> validate_required([:title])
  # end

  def index(conn, _params) do
    # IO.inspect("------>")
    # IO.inspect(conn.assigns.user)
    topics = Repo.all(Topic)
    render(conn, :index, topics: topics)
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    render(conn, :show, topic: topic)
  end

  # see form for new topic
  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, :new, changeset: changeset)
  end

  # struct = %Topic{}
  # params = %{}
  # changeset = Topic.change_topic(struct, params)

  # create a new topic
  # def create(conn, params) do
  def create(conn, %{"topic" => topic}) do
    # conn.assigns[:user] OR conn.assigns.user = current user
    # changeset = Topic.changeset(%Topic{}, topic)
    changeset =
      conn.assigns[:user]
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      # if post okay, redirecrt to index
      {:ok, _topic} ->
        conn
        # shows created message created to user
        |> put_flash(:info, "Topic Created)")
        |> redirect(to: ~p"/topics")

      # if post not okay, redirect stay in form
      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render(conn, :edit, changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic, Updated")
        |> redirect(to: ~p"/topics")

      {:error, changeset} ->
        render(conn, :edit, changeset: changeset, topic: old_topic)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id) |> Repo.delete!()

    conn
    |> put_flash(:info, "Topic Deleted!")
    |> redirect(to: ~p"/topics")
  end

  def check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    # fetch topic out of db IF user_id == to current user let through -> conn
    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You are not allowed to edit this topic")
      |> redirect(to: ~p"/topics")
      |> halt()
    end
  end
end

# def index(conn, _params) do
#   topics = Discussions.list_topics()
#   render(conn, :index, topics: topics)
# end

# def new(conn, _params) do
#   changeset = Discussions.change_topic(%Topic{})
#   render(conn, :new, changeset: changeset)
# end

# def create(conn, %{"topic" => topic_params}) do
#   case Discussions.create_topic(topic_params) do
#     {:ok, topic} ->
#       conn
#       |> put_flash(:info, "Topic created successfully.")
#       |> redirect(to: ~p"/topics/#{topic}")

#     {:error, %Ecto.Changeset{} = changeset} ->
#       render(conn, :new, changeset: changeset)
#   end
# end

# def show(conn, %{"id" => id}) do
#   topic = Discussions.get_topic!(id)
#   render(conn, :show, topic: topic)
# end

# def edit(conn, %{"id" => id}) do
#   topic = Discussions.get_topic!(id)
#   changeset = Discussions.change_topic(topic)
#   render(conn, :edit, topic: topic, changeset: changeset)
# end

# def update(conn, %{"id" => id, "topic" => topic_params}) do
#   topic = Discussions.get_topic!(id)

#   case Discussions.update_topic(topic, topic_params) do
#     {:ok, topic} ->
#       conn
#       |> put_flash(:info, "Topic updated successfully.")
#       |> redirect(to: ~p"/topics/#{topic}")

#     {:error, %Ecto.Changeset{} = changeset} ->
#       render(conn, :edit, topic: topic, changeset: changeset)
#   end
# end

# def delete(conn, %{"id" => id}) do
#   topic = Discussions.get_topic!(id)
#   {:ok, _topic} = Discussions.delete_topic(topic)

#   conn
#   |> put_flash(:info, "Topic deleted successfully.")
#   |> redirect(to: ~p"/topics")
# end
