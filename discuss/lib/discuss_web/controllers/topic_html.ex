defmodule DiscussWeb.TopicHTML do
  use DiscussWeb, :html

  embed_templates "topic_html/*"

  @doc """
  Renders a topic form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def topic_form(assigns)
end

# def delete(conn, %{"id" => id}) do
#   topic = Discussions.get_topic!(id)
#   {:ok, _topic} = Discussions.delete_topic(topic)

#   conn
#   |> put_flash(:info, "Topic deleted successfully.")
#   |> redirect(to: ~p"/topics")
# end
