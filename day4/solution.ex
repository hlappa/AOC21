defmodule GiantSquid do
  def part1 do
    [head | tail] = input()

    numbers = String.split(head, ",") |> Enum.map(&String.to_integer/1)
    boards = build_boards(tail)

    Enum.map(jotain, fn n -> n + 1 end)

    {nums, board} =
      Enum.with_index(numbers)
      |> Enum.reduce_while({[], []}, fn {_val, idx}, _acc ->
        nums = Enum.take(numbers, idx + 1)
        {board, _} = check_board_bingo(boards, nums)

        if board == [], do: {:cont, {[], []}}, else: {:halt, {nums, board}}
      end)

    last_num = List.last(nums)

    board_sum =
      List.flatten(board) |> Enum.reject(fn n -> Enum.member?(nums, n) end) |> Enum.sum()

    last_num * board_sum
  end

  def part2 do
    [head | tail] = input()

    numbers = String.split(head, ",") |> Enum.map(&String.to_integer/1)
    boards = build_boards(tail)

    {nums, last_board, _} =
      Enum.with_index(numbers)
      |> Enum.reduce_while({[], [], boards}, fn {_val, idx}, {_, last_boards, acc_boards} ->
        nums = if idx < 5, do: Enum.take(numbers, 5), else: Enum.take(numbers, idx + 1)
        boards = check_all_winning_boards(acc_boards, nums)

        if boards == [] do
          {:cont, {nums, last_boards, acc_boards}}
        else
          new_boards =
            Enum.reduce(boards, acc_boards, fn b, acc ->
              List.delete(acc, b)
            end)

          if new_boards == [] do
            {:halt, {nums, boards, new_boards}}
          else
            {:cont, {nums, boards, new_boards}}
          end
        end
      end)

    last_num = Enum.at(nums, -1)

    board_nums =
      List.last(last_board)
      |> elem(0)
      |> List.flatten()

    remaining_nums =
      Enum.reduce(nums, board_nums, fn n, acc ->
        List.delete(acc, n)
      end)
      |> Enum.sum()

    last_num * remaining_nums
  end

  defp build_boards(input_boards) do
    boards_with_rows =
      Enum.map(input_boards, fn board_str ->
        String.replace(board_str, "  ", " ")
        |> String.trim()
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk_every(5)
      end)

    Enum.map(boards_with_rows, fn board_rows ->
      board_cols = get_board_columns(board_rows)

      {board_rows, board_cols}
    end)
  end

  defp get_board_columns(board) do
    Enum.reduce(board, [[], [], [], [], []], fn r, acc ->
      Enum.with_index(r) |> Enum.map(fn {val, idx} -> [val | Enum.at(acc, idx)] end)
    end)
  end

  defp check_all_winning_boards(boards, numbers) do
    Enum.reduce(boards, [], fn {board_rows, board_cols}, acc ->
      winning_row_board = check_board_arr(board_rows, numbers)
      winning_column_board = check_board_arr(board_cols, numbers)

      if winning_row_board || winning_column_board do
        [{board_rows, board_cols} | acc]
      else
        acc
      end
    end)
  end

  defp check_board_bingo(boards, numbers) do
    Enum.reduce_while(boards, {[], []}, fn {board_rows, board_cols}, _val ->
      winning_row_board = check_board_arr(board_rows, numbers)
      winning_column_board = check_board_arr(board_cols, numbers)

      case {winning_row_board, winning_column_board} do
        {true, _} -> {:halt, {board_rows, board_cols}}
        {_, true} -> {:halt, {board_rows, board_cols}}
        {_, _} -> {:cont, {[], []}}
      end
    end)
  end

  defp check_board_arr(board_arr, numbers) do
    Enum.reduce_while(board_arr, false, fn row, _acc ->
      res =
        Enum.all?(row, fn r ->
          Enum.member?(numbers, r)
        end)

      if res, do: {:halt, true}, else: {:cont, false}
    end)
  end

  defp input do
    case File.read("input.txt") do
      {:ok, contents} ->
        contents
        |> String.split("\n\n", trim: true)
        |> Enum.map(fn line -> String.replace(line, "\n", " ") end)

      {:error, reason} ->
        IO.puts(reason)
    end
  end
end

IO.puts("Part 1:")
GiantSquid.part1() |> IO.inspect()
IO.puts("Part 2:")
GiantSquid.part2() |> IO.inspect()
