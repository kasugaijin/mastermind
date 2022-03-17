# Code range comprised of strings so user-entered values can be directly
# compared with computer selected values from this range
module CodeRange
  RANGE = ['1','2','3','4','5','6']
end

# board class creates maker board and contains methods to compare breaker with maker
class Board
  include CodeRange
  attr_accessor :maker_board, :turn_count, :breaker

  def initialize
    @maker_board = []
    @winner = false
    @match = 0
    @partial = 0
    @player = Player.new
    @ai = AI.new
    @turn_count = 1
    @breaker = nil
  end

  def select_breaker
    if @player.choice == '2'
      @breaker = @ai.input_code
      @maker_board = @player.input_code
    elsif @player.choice == '1'
      @breaker = @player.input_code
    end
  end

  # computer creates code in maker array
  def computer_maker
    i = 1
    while i <= 4 do
      value = CodeRange::RANGE.sample
      @maker_board << value
      i += 1
    end
  end

  def check_winner
    if @maker_board == @breaker
      @turn_count = 13
      @winner = true
    end
  end

  def check_match
    @match = 0
    @maker_board.each_with_index do |a, i|
      @breaker.each_with_index do |b, j|
        if a == b && i == j
          @match += 1
        end
      end
    end
    puts "Match: #{@match}"
  end

  def check_partial
    @partial = 0
    @maker_board.each_with_index do |a, i|
      @breaker.each_with_index do |b, j|
        if a == b && i != j
          @partial += 1
        end
      end
    end
    puts "Partial: #{@partial}"
  end

  def result
    if @player.choice == '1'
      if @winner == true
        puts 'congratulations, you solved it!'
      else
      puts "The code was #{@maker_board.join}"
      puts 'Better luck next time!'
      end
    elsif @player.choice == '2'
      if @winner == true
        puts 'The machine figure out your code!'
      else
        puts 'You beat the machine!'
      end
    end
  end

  # condense the select breaker..urn count into a game_run def and call that instead
  def play_game
    if @player.choice == '2'
      @player.maker_values
      @ai.first_try
      self.select_breaker
      self.check_winner
      self.check_match
      self.check_partial
      self.turn_count += 1
      until self.turn_count >= 12
        @ai.solve
        self.select_breaker
        self.check_winner
        self.check_match
        self.check_partial
        self.turn_count += 1
      end
      self.result
    else
    self.computer_maker
    until self.turn_count >= 12
      @player.breaker_values
      self.select_breaker
      self.check_winner
      self.check_match
      self.check_partial
      self.turn_count += 1
    end
    self.result
    end
  end
end

# player class creates instance for the player and validates player input
class Player
attr_accessor :input_code, :name, :choice

  def initialize
    puts 'What is your name?'
    @name = gets.chomp
    puts 'Enter 1 to be the code breaker or 2 to be the code maker.'
    @choice = gets.chomp
    @input_code = []
    @turn = 1
  end

  # prompt user to enter code and validate: 4 characters from ASCII 1 to 6
  # add validated input to @input_code 
  def breaker_values
    puts "Turn: #{@turn} - #{@name}, enter your code: four numbers in a row on one line"
    input = gets.chomp
    input_ascii = input.each_byte.to_a
    until input.length == 4 && input_ascii.all? { |e| e >= 49 && e <= 54}
      puts 'make sure you have entered a valid code!'
      input = gets.chomp
      input_ascii = input.each_byte.to_a
    end
    @input_code = input.split('')
    @turn += 1
  end

  def maker_values
    puts "#{@name}, enter the code for the computer to guess: four numbers (1-6) in a row."
    input = gets.chomp
    input_ascii = input.each_byte.to_a
    until input.length == 4 && input_ascii.all? { |e| e >= 49 && e <= 54}
      puts 'make sure you have entered a valid code or the computer will get upset!'
      input = gets.chomp
      input_ascii = input.each_byte.to_a
    end
    @input_code = input.split('')
  end
end 

class AI
  include CodeRange

  attr_accessor :input_code

  def initialize
    @input_code = []
    @turn = 1
  end

  def first_try
    i = 1
    while i <= 4 do
      value = CodeRange::RANGE.sample
      @input_code << value
      i += 1
    end
    print @input_code
    @turn += 1
  end

  def solve
    puts 'this is hard'
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

board = Board.new
board.play_game

puts 'Enter Y to play again or N to end.'
answer = gets.chomp
case answer
when 'Y' || 'y'
  board = Board.new
  board.play_game
else
  puts 'Thanks for playing!'
end