require_relative 'pieces/piece'

class Player
  attr_accessor :name, :team

  def initialize(name, team)
    @name = name
    @team = team
  end

  def in_players_team?(piece)
    piece.is_a?(Piece) && piece.team == @team
  end
end