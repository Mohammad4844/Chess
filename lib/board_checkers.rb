module BoardCheckers
  def inside_board?(x, y)
    x.between?(0, 7) && y.between?(0, 7)
  end
end