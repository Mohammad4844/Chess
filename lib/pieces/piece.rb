# frozen_string_literal: true

require_relative '../colorize'

class Piece
  attr_accessor :team, :x, :y, :point_value

  def initialize(team, x, y, point_value = nil)
    @team = team 
    @x = x
    @y = y
    @point_value = point_value
  end

  def change_coordinates(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    same_team?(other) && @x == other.x && @y == other.y &&
      self.class == other.class
  end

  def same_team?(other)
    self.team == other.team
  end

  def different_team?(other)
    self.team != other.team && self.team != '' && other.team != ''
  end

  def pawn?
    self.instance_of?(Pawn)
  end

  def no_piece?
    @team == ''
  end

  def white?
    @team == 'w'
  end

  def black?
    @team == 'b'
  end

  # Helper method to see if cooridnates are inside the board
  def inside_board?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end

  def to_s(unicode_w, unicode_b)
    case @team
    when 'w' then unicode_w
    when 'b' then unicode_b.black
    end
  end

  def to_json(args)
    JSON.generate({
      class: self.class,
      team: @team,
      x: @x,
      y: @y
    })
  end

  def self.from_json(s)
    data = JSON.parse(s)
    data['class'].new(data['team'], data['x'], data['y'])
  end
end
