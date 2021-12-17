defmodule Dive do
  def part1 do
    instructions = input() |> Enum.map(fn val -> String.split(val, " ") |> List.to_tuple() end)

    {x, depth} =
      Enum.reduce(instructions, {0, 0}, fn {dir, value}, acc ->
        x = elem(acc, 0)
        depth = elem(acc, 1)
        steps = String.to_integer(value)

        case dir do
          "forward" ->
            {x + steps, depth}

          "up" ->
            {x, depth + steps}

          "down" ->
            {x, depth - steps}
        end
      end)

    x * depth
  end

  def part2 do
    instructions = input() |> Enum.map(fn val -> String.split(val, " ") |> List.to_tuple() end)

    {x, depth, _} =
      Enum.reduce(instructions, {0, 0, 0}, fn {dir, value}, acc ->
        x = elem(acc, 0)
        depth = elem(acc, 1)
        aim = elem(acc, 2)
        steps = String.to_integer(value)

        case dir do
          "forward" ->
            if aim == 0 do
              {x + steps, depth, aim}
            else
              {x + steps, depth + aim * steps, aim}
            end

          "up" ->
            {x, depth, aim - steps}

          "down" ->
            {x, depth, aim + steps}
        end
      end)

    x * depth
  end

  defp input do
    case File.read("input.txt") do
      {:ok, content} ->
        content |> String.split("\n", trim: true)

      {:err, error} ->
        IO.inspect(error)
    end
  end
end

IO.puts("Part 1:")
Dive.part1() |> IO.inspect()
IO.puts("Part 2:")
Dive.part2() |> IO.inspect()
