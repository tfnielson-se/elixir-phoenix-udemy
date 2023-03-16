defmodule Identicon do
#  run iex -S mix
# Identicon.main("text") to render Identicon

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |>save_image(input)
  end

  def save_image(image, input ) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn ({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {code, _index} ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      # passing a reference to fn
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      # return a tuple {hex, index_num}
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row(row) do
    #  [1, 2, 3]
    [first, second | _t] = row
    row ++ [second, first]
    #  [1, 2, 3, 2, 1]
  end

  # pattern matching a struct
  def pick_color(%Identicon.Image{hex: [r, g, b | _t]} = image) do
    # %Identicon.Image{hex: [r, g, b | _t]} = image
    # Map.put(image, :color, {r, g, b})
    %Identicon.Image{image | color: {r, g, b}}
  end

  # hashing the input
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
