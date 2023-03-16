defmodule DiscussWeb.UserSocket do
  use Phoenix.Socket

  channel "comments:*", DiscussWeb.CommentsChannel


  # token: window.userToken from user_socket.js
  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "key", token) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}
      {:error, _error} ->
    end
  end



  def id(_socket), do: nil
end
