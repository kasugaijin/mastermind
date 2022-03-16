# Code range comprised of strings so user-entered values can be directly
# compared with computer selected values from this range
module CodeRange
  RANGE = ['1','2','3','4','5','6']
end

# board class creates maker board and contains methods to compare breaker with maker
class Board
  include CodeRange
  @@turn_count = 1
  @@winner = false
  @@match = ''
  @@partial = ''

  attr_accessor :maker_board, :breaker_board

  def initialize
    @maker_board = Array.new
  end

  # computer creates code in maker array
  def computer_maker(range)
    i = 1
    while i <=4 do
      value = range.sample
      @maker_board << value
      i += 1
    end
  end

  def check_winner
    if @maker_board == player.input_code
      @@turn_count = 13
      @@winner = true
    end
  end

  def check_match
    @maker_board.each_with_index do |a, i|
      player.input_code.each_with_index do |b, j|
        if a == b && i == j
          @@match += 1
        end
      end
    end
  end

  def check_partial
    @maker_board.each_with_index do |a, i|
      player.input_code.each_with_index do |b, j|
        if a == b && i != j
          @@partial += 1
        end
      end
    end
  end

  def result(result)
    if result == true
      puts 'congratulations, you solved it!'
    else
      puts 'better luck next time!'
    end
  end

  def play_again(answer)
    case answer
    when "Y"
      # Board.new
      # Player.new
      # play_game
    else
      # puts 'thanks for playing'
    end
  end
end

# player class creates instance for the player and validates player input
class Player
attr_accessor :input_code, :name, :choice

  def initialize
    @name = gets.chomp
    @choice = gets.chomp
    @input_code
  end

  # prompt user to enter code and validate: 4 characters from ASCII 1 to 6
  # add validated input to @input_code 
  def get_values
    puts "#{@name}, enter your code: four numbers in a row on one line"
    input = gets.chomp
    input_ascii = input.each_byte.to_a
    until input.length == 4 && input_ascii.all? { |e| e >= 49 && e <= 54}
      puts 'make sure you have entered a valid code!'
      input = gets.chomp
      input_ascii = input.each_byte.to_a
    end
    @input_code = input.split('')
  end 

class AI
  include CodeRange
end

def playgame
  # board.computer_maker(CodeRange::RANGE)
  # loop 12 times
    # puts 'breaker, enter your four values'
    # gets values - make sure they are valid
    # add values to board - breaker_array
    # compare breaker array to maker array
      # if maker = breaker
        # turn count = 12, winner = true
      # elsif match 
        # += match
      # elsif partial
        # += partial
      # else 
        # match = '' and partial = ''
    # turn_count += 1

# board.winner(@@winner)
  # if player.winner = true
    # puts 'congrats you did it!'
  # else 
    # puts 'better luck next time'
end

# instructions
puts 'Welcome to Mastermind: a code breaking game between you and the computer.'
puts 'You can choose to be either the code maker, or code breaker.'
puts 'The code maker creates a 4 digit code using numbers from 1 to 6. Duplicates are allowed.'
puts 'The code breaker has to guess the exact code in under 12 turns, receiving hints each turn.'
puts 'Hints: "match" = correct value and position; "partial" = correct value, incorrect position.'
puts 'Can you beat the machine? Good luck!'

game = Board.new
player = Player.new
play_game