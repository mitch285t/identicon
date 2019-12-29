

defmodule Identicon do
  @moduledoc """
This program sets up a identicon or default profile image for the input you give it. 
"""
  def main(input) do 
    input 
    |> hash_input
    |> pick_color
    |> build_grid
  end 
@doc """
`build_grid` seperates the hex into sets of 3 and also calls the `mirror_row` function that adds two more values and mirrors the list. 
"""
  def build_grid(%Identicon.Image{hex: hex} = image) do 
    hex 
    |> Enum.chunk(3)
    |> Enum.map(&mirror_row/1)
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
