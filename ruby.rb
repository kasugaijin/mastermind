# module containing possible code values and player input/validation
module Common
  RANGE = ['1','2','3','4','5','6']

  def player_input
    puts 'Enter your code: four numbers (1 through 6) in a row on one line'
    input = gets.chomp
    input_ascii = input.each_byte.to_a
    until input.length == 4 && input_ascii.all? { |e| e >= 49 && e <= 54 }
      puts 'make sure you have entered a valid code!'
      input = gets.chomp
      input_ascii = input.each_byte.to_a
    end
    @player_input_code = input.split('')
  end
end

# Game class allows for continuous replay function, istantiates Board class.
class Game
  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def play_again
    puts 'Enter Y to play again or N to end.'
    answer = gets.chomp
    case answer
    when 'Y' || 'y'
      @board = Board.new
      @board.decide_play_method
      play_again
    else
      puts 'Thanks for playing!'
    end
  end
end

# board class instantiates PlayerMaker and PlayerBreaker classes
# and has methods for setting instance variables, evaluating guesses, winners and executing the game
class Board
  include Common
  attr_accessor :maker_board, :turn_count, :breaker

  def initialize
    @maker_board = []
    @breaker_board = []
    @winner = false
    @match = 0
    @partial = 0
    @player_breaker = PlayerBreaker.new
    @player_maker = PlayerMaker.new
    puts 'Enter 1 to be the code breaker or 2 to be the code maker.'
    @player_choice = gets.chomp
    @turn_count = 1
  end

  # if player is breaker, set instance variables
  def player_is_breaker
    @breaker_board = @player_breaker.player_input_code
  end

  # if player is maker, set instance variables
  def player_is_maker
    @maker_board = @player_maker.player_input_code
    @breaker_board = @player_maker.ai_input_code
  end

  # computer generated code
  def computer_maker
    i = 1
    while i <= 4 do
      value = Common::RANGE.sample
      @maker_board << value
      i += 1
    end
  end

  # check if there is a correct code guess
  def check_winner
    if @maker_board == @breaker_board
      @turn_count = 13
      @winner = true
    end
  end

  # check it any matches or partials
  def check_match_partial
    @match = 0
    @partial = 0
    @maker_board.each_with_index do |a, i|
      @breaker_board.each_with_index do |b, j|
        if a == b && i == j
          @match += 1
        elsif a == b && i != j
          @partial += 1
        end
      end
    end
    puts "Match: #{@match}"
    puts "Partial: #{@partial}"
    puts "\r\n"
  end

  # determine if there is a winner
  def result
    case @player_choice
    when '1'
      if @winner == true
        puts 'congratulations, you solved it!'
      else
        puts "The code was #{@maker_board.join}. Better luck next time!"
      end
    else
      if @winner == true
        puts 'The machine figured out your code!'
      else
        puts 'You beat the machine!'
      end
    end
  end

  # determine which play method to execute
  def decide_play_method
    case @player_choice
    when '1'
      play_player_breaker
    else
      play_player_maker
    end
  end

  # execute if player is code maker
  def play_player_breaker
    computer_maker
    until @turn_count >= 13
      puts "Turn: #{@turn_count}"
      @player_breaker.player_input
      player_is_breaker
      check_winner
      check_match_partial
      @turn_count += 1
    end
    result
  end

  # execute if player is code maker
  def play_player_maker
    @player_maker.player_input
    @player_maker.first_guess
    check_match_partial
    @turn_count += 1
    until @turn_count >= 13
      puts "Turn: #{@turn_count}"
      @player_maker.solve
      player_is_maker
      check_winner
      check_match_partial
      @turn_count += 1
      sleep(1)
    end
    result
  end
end

# Player is the code breaker
class PlayerBreaker
  include Common
  attr_accessor :player_input_code

  def initialize
    @player_input_code = []
  end
end

# player is the code maker
class PlayerMaker
  include Common
  attr_accessor :player_input_code, :ai_input_code

  def initialize
    @player_input_code = []
    @ai_input_code = []
  end

  # first guess - all four values are the same
  def first_guess
    value = Common::RANGE.sample
    i = 1
    while i <= 4 do
      @ai_input_code << value
      i += 1
    end
    puts "Computer guessed: #{@ai_input_code}"
  end

  # keeps matches and picks a new random number for non-matches
  def solve
    new_guess = []
    i = 0
    while i <= 3
      if @player_input_code[i] == @ai_input_code[i]
        new_guess << @player_input_code[i]
      else
        value = Common::RANGE.sample
        new_guess << value
      end
      i += 1
    end
    @ai_input_code = new_guess
    puts "Computer guessed: #{@ai_input_code}"
  end
end

# instructions
puts 'Welcome to Mastermind: a code breaking game between you and the computer.'
puts 'You can choose to be either the code maker, or code breaker.'
puts 'The code maker creates a 4 digit code using numbers from 1 to 6. Duplicates are allowed.'
puts 'The code breaker has to guess the exact code in under 12 turns, receiving hints each turn.'
puts 'Hints: "match" = correct value and position; "partial" = correct value, incorrect position.'
puts 'Can you beat the machine? Good luck!'
puts "\r\n"

game = Game.new
game.board.decide_play_method
game.play_again
