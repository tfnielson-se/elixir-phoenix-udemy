defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel
  import Ecto

  alias Discuss.Repo
  alias Discuss.Discussions.Topic
  alias Discuss.Discussions.Comment

  def join("comments:" <> topic_id, _message, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
      |> Repo.get(topic_id)
      |> Repo.preload(comments: [:user]) #loading all comments assoc with topic and the user assoc with the comment

    # {:ok, %{hey: "there"}, socket} #check in browser console there is a conn
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  # def join("comments:" <> _private_room_id, _params, _socket) do
  #   {:error, %{reason: "unauthorized"}}
  # end

  def handle_in(name, %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    changeset = topic
    |> build_assoc(:comments, user_id: user_id)
    |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end

    {:reply, :ok, socket}
  end

end
