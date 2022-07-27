require_relative 'colorize'
require 'io/console'

module Display
  def print_initial_instructions
    puts <<~INSTRUCTIONS

      #{'Welcome to Chess!'.bold}

      Do you want to (1) play a new game
                     (2) load a saved game

      Enter your choice:
    INSTRUCTIONS
  end

  def print_board
    $stdout.clear_screen
    puts @board
  end

  def print_player_piece_select_input_text(player)
    puts "#{player.name.bold}, enter coordinates of the piece you want to move or 'save' to save the game: "
  end

  def print_player_piece_move_input_text(player)
    puts "#{player.name.bold}, enter coordinates of the space you want to move to: "
  end

  def print_incorrect_input_message
    puts 'Invalid input! Please Enter something valid: '
  end

  def print_check_message
    puts 'Your King is in Check!'.red
  end

  def print_winner_by_checkmate_message(winner)
    puts "\u2728 Congratulations #{winner.name}! You won by Checkmate! \u2728\n".green.bold
  end

  def print_stalemate_message
    puts "Its a draw by stalemate!\n".blue
  end

  def print_game_save_message
    puts "\nYour game was saved successfully, overwriting the previous save\n".magenta
  end

  def print_file_load_error(type)
    puts "\nError in loading the saved #{type.bold} data. ".red +
         "Dir/File either doesn't exist or is empty\n".red
  end

  def print_player_pawn_promote_text(player)
    puts <<~TEXT
      #{player.name.bold}, you can promote a pawn of yours to either a"
        (1) Queen
        (2) Rook
        (3) Bishop
        (4) Knight
      Enter your choice:
    TEXT
  end
end
