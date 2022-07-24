require_relative 'board'
require_relative 'display'
require_relative 'player'

class Game
  include Display

  def initialize
    @board = Board.new
    @players = []
  end

  def start
    print_initial_instructions
    setup_players
  end

  def setup_players
    2.times do |i|
      puts "Player #{i + 1}, please enter your name. You will be #{i.zero? ? 'White' : 'Black'}."
      @players << Player.new(gets.chomp, i.zero? ? 'w' : 'b')
    end
    @current_player = @players[0]
  end

  def play
    loop do
      print_board
      result = turn_order

      break if result == 'exit' # change later
    end
  end

  def turn_order
    if @board.check?(@current_player.team)
      print_check_message
      @board.set_current_piece(player_input)
      print_board
      @board.move_current_piece(player_input)
      # TODO
    else
      @board.set_current_piece(player_input)
      print_board
      @board.move_current_piece(player_input)
    end
    # TO BE COMPLETED

    switch_current_player
  end

  def player_input
    if current_piece_selected?
      print_player_piece_move_input_text(@current_player)
    else
      print_player_piece_select_input_text(@current_player)
    end

    loop do
      input = verify_input(gets.chomp)
      return input if input

      print_incorrect_input_message
    end
  end

  def verify_input(input)
    return nil unless input.match?(/\A[a-h]{1}[1-8]{1}\z/)

    input = Board.code_to_coordinates(input)

    if current_piece_selected?
      return input if @board.legal_move?(input)
    elsif @current_player.in_players_team?(@board.piece_at(input))
      if @board.check?(@current_player.team) && @board.piece_has_move_to_remove_check?(input)
        return input
      elsif !@board.piece_at(input).possible_moves(@board.spaces).empty?
        moves = @board.piece_at(input).possible_moves(@board.spaces)
        if moves.none? { |move| @board.hypothetical_move_causes_check?(input, move, @current_player.team) }
          return input
        end
      end
    end
    nil
  end

  def current_piece_selected?
    !@board.current_piece.nil?
  end

  def switch_current_player
    @players.rotate!(1)
    @current_player = @players[0]
  end
end
