defmodule Cards do
  @moduledoc """
  Provides methods for creating and handling cards
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Diamonds", "Hearts"]

    # List comprehension / "for every element of suits do:" THIS IS BASICALLY a MAP fn
    for suit <- suits, value <- values do
      "#{suit} of #{value}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def create_hand(hand_size) do
    Cards.create_deck
    |>Cards.shuffle
    |>Cards.deal(hand_size)
  end

end
