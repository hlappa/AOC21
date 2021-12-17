defmodule SevenSegmentSearch do
  def part1 do
    input()
    |> List.flatten()
    |> Enum.filter(fn d -> String.length(d) in [2, 3, 4, 7] end)
    |> Enum.count()
  end

  def part2 do
    input2()
    |> IO.inspect()

    # |> Enum.map(fn s -> Enum.map(s, &String.graphemes/1) end)

    # |> Enum.map(&check_number/1)
  end

  # defp check_number(graphs) do
  #   Enum.reduce(graphs, [], fn seg, acc ->
  #     num =
  #       Enum.reduce_while(0..9, "", fn num, _acc ->
  #         match =
  #           Enum.all?(seg, fn g ->
  #             Enum.member?(num_str, g)
  #           end)
  #
  #         if match, do: {:halt, Integer.to_string(num)}, else: {:cont, ""}
  #       end)
  #
  #     [num | acc]
  #   end)
  # end

  def input do
    case File.read("input.txt") do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> Enum.map(fn s -> String.split(s, " | ") |> List.last() end)
        |> Enum.map(fn s -> String.split(s, " ") end)

      {:err, error} ->
        IO.inspect(error)
    end
  end

  defp input2 do
    case File.read("input.txt") do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> Enum.map(fn s -> String.split(s, " | ") end)

      # |> Enum.map(fn n ->
      #   String.split(n, " ") |> Enum.sort_by(&bit_size/1)
      # end)

      {:err, error} ->
        IO.inspect(error)
    end
  end
end

IO.puts("Part 1:")
SevenSegmentSearch.part1() |> IO.inspect()
IO.puts("Part 2:")
SevenSegmentSearch.part2()
