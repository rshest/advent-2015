import String
import Enum

defmodule Solution do

  def is_on(c), do: c == "#"

  def count_on(grid) do
    grid 
      |> join 
      |> graphemes
      |> count(&Solution.is_on/1) 
  end

  def reduce_cell(grid3x3) do
    cells = grid3x3 
      |> map(&Tuple.to_list/1) 
      |> List.flatten

    on = is_on(Enum.at(cells, 4))
    num_on = cells
      |> List.delete_at(4)
      |> count(&Solution.is_on/1)
    
    case on do
      true when num_on == 2 or num_on == 3 -> "#"
      false when num_on == 3 -> "#"
      _ -> "."
    end
  end

  def pad_border(grid, symbol) do
    w = Kernel.length(List.first(grid))

    vpad = List.duplicate(symbol, w + 2)
    prows = grid 
      |> map(&([symbol | &1] ++ [symbol]))

    [vpad | prows] ++ [vpad] 
  end

  def step(grid) do
    grid 
      |> pad_border(".")
      |> chunk(3, 1)
      |> map(&List.zip/1)
      |> map(&(chunk(&1, 3, 1)))
      |> map(&(&1 |> map(fn(c) -> reduce_cell(c) end)))
  end

  def switch_on_sides(line) do
    line 
      |> List.replace_at(0, "#")
      |> Enum.reverse 
      |> List.replace_at(0, "#")
      |> Enum.reverse 
  end

  def switch_on_corners(grid) do
    grid
      |> List.replace_at(0, switch_on_sides(hd(grid)))
      |> Enum.reverse
      |> List.replace_at(0, switch_on_sides(List.last(grid)))
      |> Enum.reverse
  end

  def solve1(grid, steps) do
    gridl = grid |> map(&graphemes/1) 
    reduce(1..steps, gridl, fn(_, g) -> step(g) end)
  end

  def solve2(grid, steps) do
    gridl = grid |> map(&graphemes/1) |> switch_on_corners
    reduce(1..steps, gridl, 
      fn(_, g) -> switch_on_corners(step(g)) end) 
  end

end

{fname, num_steps} = case System.argv do
  [str, n] -> {str, elem(Integer.parse(n), 0)}
  [str] -> {str, 100}
  _ -> {"input.txt", 100}
end

{:ok, input} = File.read(fname)
lines = input 
  |> String.split("\n")
  |> filter(&(String.length(&1) > 0))

res1 = Solution.solve1(lines, num_steps)
num_on1 = Solution.count_on(res1)
IO.puts "Number of lights on 1: #{num_on1}"

res2 = Solution.solve2(lines, num_steps)
num_on2 = Solution.count_on(res2)
IO.puts "Number of lights on 2: #{num_on2}"
