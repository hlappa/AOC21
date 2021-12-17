defmodule TheThreacheryOfWhales do
  def part1 do
    nums = input() |> Enum.sort()
    idx = floor(div(Enum.count(nums), 2) - 1)
    mean = Enum.at(nums, idx)

    Enum.map(nums, fn n -> (mean - n) |> abs() end) |> Enum.sum()
  end

  def part2 do
    nums = input() |> Enum.sort()
    max_pos = Enum.max(nums)

    Enum.reduce(0..max_pos, :infinity, fn idx, acc ->
      total =
        Enum.map(nums, fn n ->
          base_num = abs(n - idx)
          div(abs(base_num * base_num + base_num), 2)
        end)
        |> IO.inspect()
        |> Enum.sum()

      case total < acc do
        true -> total
        false -> acc
      end
    end)
  end

  def input do
    case File.read("input.txt") do
      {:ok, content} ->
        content
        |> String.replace("\n", "")
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)

      {:err, error} ->
        IO.inspect(error)
    end
  end
end

IO.puts("Part 1:")
TheThreacheryOfWhales.part1() |> IO.inspect()
IO.puts("Part 2:")
TheThreacheryOfWhales.part2() |> IO.inspect()
