

defmodule Identicon do
  @moduledoc """
This program sets up a identicon or default profile image for the input you give it. 
"""
  def main(input) do 
    input 
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    
  end 

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
   pixel_map = Enum.map grid, fn({_code, index }) -> 
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50
      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end
    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    # this could also be written as Enum.filter(grid, fn(square) -> end)
    Enum.filter grid, fn({code, _index}) -> 
      rem(code, 2) == 0 
  
    end

    %Identicon.Image{image | grid: grid}
  end
@doc """
`build_grid` seperates the hex into sets of 3 and also calls the `mirror_row` function that adds two more values and mirrors the list. 
"""
  def build_grid(%Identicon.Image{hex: hex} = image) do 
  grid = hex 
    |> Enum.chunk(3)
    |> Enum.map(&mirror_row/1)
    |> List.flatten
    |> Enum.with_index
    %Identicon.Image{image | grid: grid}
    end
  
  def mirror_row(row) do
    # row = [1,4,5]
    [first, second, _tail ] = row


    row ++ [second, first]
    #end result [1,4,5,4,1]
  end

@doc """
`pick_color` sets up the values of the RGB color that will be your identicon's color.
"""
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do 
   %Identicon.Image{image | color: {r, g, b}}
  end 

  @doc """
  `hash_input(input)` hashes your input into a series of unique numbers and creates a hex list. 
  Also sends the data to the Image struct. 
  This struct will hold the data of our application.
  """
  def hash_input(input) do 
  hex = :crypto.hash(:md5, input)
  |> :binary.bin_to_list
  
  %Identicon.Image{hex: hex}
  end 

 
end
