class Code
  def generate_random
  end
end

class Feedback
  def calculate
  end

  def black_pegs
  end

  def white_pegs
  end
end

class Player
  def make_guess
end

secret_code = Code.generate_random
current_player = Player.new("guesser")
turn_number = 1
is_won = false

while !is_won && turn_number <= 10
  guess = current_player.make_guess
  feedback = Feedback.calculate(secret_code, guess)
  puts "Feedback: #{feedback.black_pegs} black pegs, #{feedback.white_pegs} white pegs"

  if feedback.black_pegs == 4
    puts "Congratulations, you guessed the code!"
    is_won = true
  else
    turn_number += 1
    current_player = current_player.opponent
  end
end

if !is_won
  puts "Sorry, you couldn't guess the code. The secret code was: #{secret_code}"
end
