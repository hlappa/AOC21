defmodule BinaryDiagnostic do
  def part1 do
    cols = input() |> get_freqs()

    {gamma, epsilon} =
      Enum.reduce(cols, {"", ""}, fn map, acc ->
        gamma = elem(acc, 0)
        epsilon = elem(acc, 1)

        if map["1"] > map["0"] do
          {"#{gamma}1", "#{epsilon}0"}
        else
          {"#{gamma}0", "#{epsilon}1"}
        end
      end)

    gam = String.to_integer(gamma, 2)
    eps = String.to_integer(epsilon, 2)

    gam * eps
  end

  def part2 do
    values = input()
    length = List.first(values) |> String.length()

    oxygen_gen_rating =
      Enum.reduce_while(0..length, values, fn idx, acc ->
        freqs = get_freqs(acc)

        filtered =
          Enum.filter(acc, fn n -> String.at(n, idx) != most_common(Enum.at(freqs, idx)) end)

        if Enum.count(filtered) == 1, do: {:halt, Enum.at(filtered, 0)}, else: {:cont, filtered}
      end)
      |> String.to_integer(2)

    co2_scrubber =
      Enum.reduce_while(0..length, values, fn idx, acc ->
        freqs = get_freqs(acc)

        filtered =
          Enum.filter(acc, fn n -> String.at(n, idx) != least_common(Enum.at(freqs, idx)) end)

        if Enum.count(filtered) == 1, do: {:halt, Enum.at(filtered, 0)}, else: {:cont, filtered}
      end)
      |> String.to_integer(2)

    oxygen_gen_rating * co2_scrubber
  end

  defp most_common(map) do
    if map["1"] >= map["0"], do: "1", else: "0"
  end

  defp least_common(map) do
    if map["0"] <= map["1"], do: "0", else: "1"
  end

  defp get_freqs(binary_nums) do
    Enum.reduce(binary_nums, [], fn val, acc ->
      chars = String.graphemes(val) |> Enum.with_index()
      length = Enum.at(binary_nums, 0) |> String.length()

      arrays =
        Enum.map(0..length, fn bit_idx ->
          Enum.filter(chars, fn {_val, idx} ->
            bit_idx == idx
          end)
        end)
        |> List.flatten()

      [arrays | acc]
    end)
    |> List.flatten()
    |> Enum.map(fn {val, idx} -> {idx, val} end)
    |> Enum.sort()
    |> Enum.chunk_every(Enum.count(binary_nums))
    |> Enum.map(fn arr ->
      Enum.map(arr, fn {_idx, val} -> val end) |> Enum.frequencies()
    end)
  end

  def input do
    case File.read("input.txt") do
      {:ok, content} ->
        content |> String.split("\n", trim: true)

      {:err, error} ->
        IO.inspect(error)
    end
  end
end

IO.puts("Part 1:")
BinaryDiagnostic.part1() |> IO.inspect()
IO.puts("Part 2:")

BinaryDiagnostic.part2() |> IO.inspect()
