defmodule Lanternfish do
  @days 256

  def part1 do
    fishes = input()

    Enum.reduce(1..@days, fishes, fn _idx, acc ->
      Enum.reduce(acc, [], fn fish, acc_fish ->
        new = fish - 1

        if new == -1 do
          [6, 8 | acc_fish]
        else
          [new | acc_fish]
        end
      end)
    end)
    |> Enum.count()
  end

  def part2 do
    initial_fishes = for n <- 0..8, into: %{}, do: {n, 0}
    fish_freqs = input() |> Enum.frequencies()
    fishes = Map.merge(initial_fishes, fish_freqs)

    Enum.reduce(1..@days, fishes, fn _, acc ->
      existing_news = Map.get(acc, 0)
      timer_six = Map.get(acc, 7) + existing_news

      %{
        0 => Map.get(acc, 1),
        1 => Map.get(acc, 2),
        2 => Map.get(acc, 3),
        3 => Map.get(acc, 4),
        4 => Map.get(acc, 5),
        5 => Map.get(acc, 6),
        6 => timer_six,
        7 => Map.get(acc, 8),
        8 => existing_news
      }
    end)
    |> Map.values()
    |> Enum.sum()
  end

  def input do
    case File.read("input.txt") do
      {:ok, contents} ->
        contents
        |> String.trim()
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)

      {:error, reason} ->
        IO.puts(reason)
    end
  end
end

defmodule Benchmark do
  def measure(function) do
    function
    |> :timer.tc()
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end

IO.puts("Part 1 & 2:")
Lanternfish.part1() |> IO.inspect()
IO.puts("Part 2:")
Lanternfish.part2() |> IO.inspect()
