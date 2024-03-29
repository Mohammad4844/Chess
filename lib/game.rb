# frozen_string_literal: true

require_relative 'board'
require_relative 'display'
require_relative 'player'
require 'json'

class Game
  include Display

  def initialize
    @board = Board.new
    @players = []
  end

  def start
    print_initial_instructions
    loop do
      input = gets.chomp
      break setup_players_new_game if input == '1'
      break load_previous_game if input == '2'

      print_incorrect_input_message
    end
  end

  def setup_players_new_game
    2.times do |i|
      puts "Player #{i + 1}, please enter your name. You will be #{i.zero? ? 'White' : 'Black'}."
      @players << Player.new(gets.chomp, i.zero? ? 'w' : 'b')
    end
    @current_player = @players[0]
  end

  def load_previous_game
    unless Dir.exist?('saved_game')
      print_file_load_error('')
      exit(1)
    end
    load_board
    load_players
    @current_player = @players[0]
  end

  def load_board
    if File.zero?('saved_game/saved_board.json')
      print_file_load_error('Board')
      exit(1)
    end
    board_data = File.readlines('saved_game/saved_board.json').join
    @board = Board.from_json(board_data)
  end

  def load_players
    if File.zero?('saved_game/saved_players.json')
      print_file_load_error('Players')
      exit(1)
    end
    players_data = JSON.parse File.readlines('saved_game/saved_players.json').join
    @players = players_data.map { |data| Player.new(data['name'], data['team']) }
  end

  def play
    loop do
      print_board
      result = turn_order

      break end_game_with_stalemate if @board.stalemate?(@current_player.team)
      break end_game_with_checkmate if @board.checkmate?(@current_player.team)
      break save_game if result == 'save'
    end
  end

  def turn_order
    print_check_message if @board.check?(@current_player.team)

    input = player_input
    return input if input == 'save'

    @board.set_current_piece(input)
    print_board
    @board.move_current_piece(player_input)

    promote_pawn if @board.any_pawn_promotable?(@current_player.team)

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
    return 'save' if !current_piece_selected? && input == 'save'
    return nil unless input.match?(/\A[a-h]{1}[1-8]{1}\z/)

    input = Board.code_to_coordinates(input)

    return input if current_piece_selected? && @board.legal_move?(input)
    return nil unless @current_player.in_players_team?(@board.piece_at(input))
    return input if @board.piece_has_legal_move?(input)
  end

  def promote_pawn
    print_board
    print_player_pawn_promote_text(@current_player)
    loop do
      input = gets.chomp
      case input
      when '1' then break @board.promote(@current_player.team, 'Queen')
      when '2' then break @board.promote(@current_player.team, 'Rook')
      when '3' then break @board.promote(@current_player.team, 'Bishop')
      when '4' then break @board.promote(@current_player.team, 'Knight')
      end

      print_incorrect_input_message
    end
  end

  def end_game_with_checkmate
    print_board
    print_winner_by_checkmate_message(@players[1])
  end

  def end_game_with_stalemate
    print_board
    print_stalemate_message
  end

  def save_game
    Dir.mkdir('saved_game') unless Dir.exist?('saved_game')
    File.write('saved_game/saved_board.json', @board.to_json)
    File.write('saved_game/saved_players.json', @players.to_json)
    print_game_save_message
  end

  def current_piece_selected?
    !@board.current_piece.nil?
  end

  def switch_current_player
    @players.rotate!(1)
    @current_player = @players[0]
  end
end
