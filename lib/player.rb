require_relative 'pieces/piece'
require 'json'

class Player
  attr_accessor :name, :team

  def initialize(name, team)
    @name = name
    @team = team
  end

  def in_players_team?(piece)
    piece.is_a?(Piece) && piece.team == @team
  end

  def to_json(args)
    JSON.pretty_generate({
      name: @name,
      team: @team
    })
  end

  def from_json(s)
    data = JSON.parse(s)
    Player.new(data['name'], data['team'])
  end
end
