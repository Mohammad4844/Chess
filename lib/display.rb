require_relative 'colorize'
require 'io/console'

module Display
  def print_initial_instructions
    puts <<~INSTRUCTIONS

      #{'Welcome to Chess!'.bold}

    INSTRUCTIONS
  end

  def print_board
    $stdout.clear_screen
    puts @board
  end

  def print_player_piece_select_input_text(player)
    puts "#{player.name}, enter coordinates of the piece you want to move: "
  end

  def print_player_piece_move_input_text(player)
    puts "#{player.name}, enter coordinates of the space you want to move to: "
  end

  def print_incorrect_input_message
    puts 'Invalid input! Please Enter something valid:'
  end

  def print_check_message
    puts 'Your King is in Check!'.red
  end

  def print_winner_by_checkmate_message(winner)
    puts "\u2728 Congratulations #{winner.name}! You won by Checkmate! \u2728".green.bold
    puts ''
  end
end