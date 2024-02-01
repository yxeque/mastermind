# frozen_string_literal: true

class Code
  COLORS = %w[R G B Y O P].freeze

  def initialize(colors = [])
    @colors = colors.map(&:upcase)
  end

  def self.generate_random # Randomly generates code from given COLORS constant
    new(COLORS.sample(4))
  end

  attr_reader :colors # getter method for @colors

  def compare(player_code) # Compares player_code (guesser) to the randomly generated code from the computer (codemaker)
    black_pegs = 0
    white_pegs = 0

    @colors.each_with_index do |color, index|
      if color == player_code.colors[index] # if guess index is in the same positon of a secret code index increment black_pegs
        black_pegs += 1
      elsif player_code.colors.include?(color) # if any guess character matches with the secret code increment white_pegs
        white_pegs += 1
      end
    end

    [black_pegs, white_pegs]
  end

  def to_s # Convert to string for easier printing
    @colors.join
  end
end

class Feedback # Stores the number of black and white pegs
  attr_reader :black_pegs, :white_pegs # getter methods for black_pegs and white_pegs

  def initialize(black_pegs, white_pegs)
    @black_pegs = black_pegs
    @white_pegs = white_pegs
  end

  def self.calculate(secret_code, guess_code) # Calculates the feedback for the given secret code through Code.compare
    return nil if guess_code.nil?

    black_pegs, white_pegs = secret_code.compare(guess_code)
    new(black_pegs, white_pegs)
  end
end

class Player
  def initialize(role = 'guesser') # guesser is the only role (because I'm lazy) - kinda pointless *for now* to program a separate "human" codemaker so instead the codemaker is the computer and the secret code is randomly generated
    @role = role
  end

  attr_reader :role

  def make_guess
    return unless @role == 'guesser'

    puts 'Enter your guess (4 colors from R, G, B, Y, O, P):'
    guess_colors = gets.chomp.upcase.chars
    while guess_colors.length != 4 # Some issues with error handling that I could not fix - if length is 4 (even with integers and numbers other than the given COLORS) the code still goes through

      if guess_colors.any? { |c| !Code::COLORS.include?(c) }
        puts 'Invalid characters! Please only use R, G, B, Y, O, P.'
      else
        puts 'Invalid guess length. Please enter exactly 4 colors.'
      end

      guess_colors = gets.chomp.upcase.chars
    end
    Code.new(guess_colors)
  end
end

class Game
  def initialize(secret_code)
    @secret_code = secret_code
    @current_player = Player.new('guesser')
    @turn_number = 1
    @is_won = false
  end

  def play
    while !@is_won && @turn_number <= 10

      guess = @current_player.make_guess
      feedback = Feedback.calculate(@secret_code, guess)
      puts "Feedback: #{feedback.black_pegs} black pegs, #{feedback.white_pegs} white pegs"
      if feedback.nil?
        puts 'Invalid guess! Please enter exactly 4 colors from R, G, B, Y, O, P.'
        next
      end
    
      if feedback.black_pegs == 4
        puts "You guessed right! The secret code was #{@secret_code}."
        @is_won = true
      else
        @turn_number += 1
      end
    end
    
    puts "Looks like you lost this time. The secret code was #{@secret_code}" unless @is_won
  end
end

secret_code = Code.generate_random
game = Game.new(secret_code)
game.play