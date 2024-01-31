class Code
  COLORS = %w[R G B Y O P]

  def initialize(colors = [])
    @colors = colors.map(&:upcase)
  end

  def self.generate_random
    new(COLORS.sample(4))
  end

  def compare(player_code)
    black_pegs = 0
    white_pegs = 0

    @colors.each_with_index do |color, index|
      if color == player_code.colors[index]
        black_pegs += 1
      elsif player_code.colors.include?(color)
        white_pegs += 1
      end
    end

    [black_pegs, white_pegs]
  end

  def to_s
    @colors.join
  end
end

class Feedback
  attr_reader :black_pegs, :white_pegs

  def initialize(black_pegs, white_pegs)
    @black_pegs = black_pegs
    @white_pegs = white_pegs
  end

  def self.calculate(secret_code, guess_code)
    black_pegs, white_pegs = secret_code.compare(guess_code)
    new(black_pegs, white_pegs)
  end
end

class Player
  def initialize(role = "guesser")
    @role = role
  end

  def role
    @role
  end

  def opponent
    @role == "guesser" ? "codemaker" : "guesser"
  end

  def make_guess
    if @role == "guesser"
      puts "Enter your guess (4 colors from R, G, B, Y, O, P):"
      guess_colors = gets.chomp.upcase.chars
      Code.new(guess_colors)
    end

  end
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

secret_code = Code.new(["R", "B", "O", "Y"])    # Create a test code manually
guess_code = Code.new(['Y', 'B', 'R', 'O'])

feedback = Feedback.calculate(secret_code, guess_code)
puts "Feedback: #{feedback.black_pegs} black pegs, #{feedback.white_pegs} white pegs"