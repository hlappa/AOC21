defmodule SonarSweep do
  def part1 do
    input = input()

    Enum.with_index(input)
    |> Enum.reduce(0, fn {val, idx}, acc ->
      if idx == 0 && Enum.count(input) - 1 == idx do
        acc
      else
        case determine_direction(val, Enum.at(input, idx - 1)) do
          true -> acc + 1
          false -> acc
        end
      end
    end)
  end

  def part2 do
    vals = input() |> sum_values()

    Enum.with_index(vals)
    |> Enum.reduce(0, fn {v, idx}, acc ->
      if idx == 0 && Enum.count(vals) - 1 == idx do
        acc
      else
        case determine_direction(v, Enum.at(vals, idx - 1)) do
          true -> acc + 1
          false -> acc
        end
      end
    end)
  end

  defp determine_direction(current, previous) do
    current > previous
  end

  defp sum_values(values) do
    Enum.chunk(values, 3, 1) |> Enum.map(fn vals -> Enum.sum(vals) end)
  end

  defp input do
    case File.read("input.txt") do
      {:ok, content} ->
        content |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)

      {:err, error} ->
        IO.inspect(error)
    end
  end
end

IO.puts("Part 1:")
IO.puts(SonarSweep.part1())
IO.puts("part 2:")
IO.puts(SonarSweep.part2())
