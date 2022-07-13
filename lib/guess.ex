defmodule Guess do
  use Application

  def start(_, _) do
    start_game()

    {:ok, self()}
  end

  def start_game() do
    IO.puts("Let's play Guess The Number!\n")

    IO.gets("Pick a difficult level (1 - 3): ")
    |> get_level()
    |> Enum.random()
    |> play_game()
  end

  # Get the parsed level and range of numbers.
  def get_level(level) do
    level
    |> get_parsed_input()
    |> get_level_range()
  end

  # Start the game with a ramdom number between the level range to be guessed.
  def play_game(number) do
    IO.gets("I have my number. What's your guess? ")
    |> get_parsed_input()
    |> get_guessing(number, 1, [])
  end

  # Here we define some patterns for the guess using guards.
  def get_guessing(input, number, count, tries) when input > number do
    get_tries = get_number_try_check(input, tries)

    IO.gets("Too high. Guess again: ")
    |> get_parsed_input()
    |> get_guessing(number, count + 1, get_tries)
  end

  def get_guessing(input, number, count, tries) when input < number do
    get_tries = get_number_try_check(input, tries)

    IO.gets("Too low. Guess again: ")
    |> get_parsed_input()
    |> get_guessing(number, count + 1, get_tries)
  end

  def get_guessing(_input, _number, count, _tries) do
    IO.puts("\nYou got it! #{count} tries \n")

    get_score(count)
  end

  # Here we define some patterns to check if the user already tried the number.
  def get_number_try_check(input, tries) do
    if length(tries) == 0 do
      [input]
    else
      if input in tries do
        IO.puts("\nYou already tried that number.\n")

        tries
      else
        Enum.concat(tries, [input])
      end
    end
  end

  # Here we define some patterns for returning the score.
  def get_score(count) when count > 6, do: IO.puts("Better luck next time!\n")
  def get_score(guesses) do
    {_, message} = %{
      1..1 => "You're a mind reader!",
      2..4 => "Very impressive!",
      3..6 => "You can do better than that!"
    }
    |> Enum.find(fn {range, _} -> Enum.member?(range, guesses) end)

    IO.puts(message)
  end


  # Here we define some patterns for parsing input.
  def get_parsed_input({num, _}), do: num
  def get_parsed_input(:error) do
    IO.puts("Invalid level.\n")
    start_game()
  end

  def get_parsed_input(input) do
    input
    |> Integer.parse()
    |> get_parsed_input()
  end

  # Here we define the function that returns the range of numbers to guess.
  def get_level_range(level) do
    case level do
      1 -> 1..10
      2 -> 1..100
      3 -> 1..1000
      _ ->
        IO.puts("Invalid level.\n")
        start_game()
    end
  end
end
