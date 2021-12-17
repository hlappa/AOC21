defmodule HydrothermalVenture do
  def part1 do
    input()
    |> Enum.filter(fn {{x1, y1}, {x2, y2}} -> x1 == x2 or y1 == y2 end)
    |> calc_occurrences()
  end

  def part2 do
    input()
    |> calc_occurrences()
  end

  defp calc_occurrences(coords) do
    Enum.map(coords, &spread/1)
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.filter(fn {_k, v} -> v >= 2 end)
    |> Enum.count()
  end

  defp spread({{x1, y1}, {x2, y2}}) when x1 == x2 or y1 == y2 do
    for x <- x1..x2, y <- y1..y2 do
      {x, y}
    end
  end

  defp spread({{x1, y1}, {x2, y2}}) do
    cond do
      x1 == x2 ->
        for y <- y1..y2, do: {x1, y}

      y1 == y2 ->
        for x <- x1..x2, do: {y1, x}

      true ->
        Enum.zip(x1..x2, y1..y2)
    end
  end

  defp input do
    case File.read("input.txt") do
      {:ok, contents} ->
        contents
        |> String.split("\n", trim: true)
        |> Enum.map(fn pair ->
          String.split(pair, " -> ")
          |> Enum.map(fn p -> String.split(p, ",") |> Enum.map(&String.to_integer/1) end)
        end)
        |> List.flatten()
        |> Enum.chunk_every(4)
        |> Enum.map(fn [x1, y1, x2, y2] -> {{x1, y1}, {x2, y2}} end)

      {:error, reason} ->
        IO.puts(reason)
    end
  end
end

IO.puts("Part 1:")
HydrothermalVenture.part1() |> IO.inspect()
IO.puts("Part 2:")
HydrothermalVenture.part2() |> IO.inspect()
