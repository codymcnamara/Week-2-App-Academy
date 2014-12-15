class Board
  attr_reader :board
  def initialize
    @board = Array.new(9) { Array.new(9) { Tile.new(self) } }
    find_index

    #set some bombs up
    @board.each do |row|
      row.each do |tile|
        if rand(1..10) > 8
          tile.set_bomb
        end
      end
    end

  end

  def find_index
    self.board.each_with_index do |row, row_index|
      row.each_with_index do |tile, tile_index|
        tile.index = [row_index, tile_index]
      end
    end
  end

  def display
    self.board.each do |row|
      row.each do |tile|
        print tile.display
      end
      puts ""
    end
  end
end

class Tile
    attr_accessor :display, :index, :bomb
    def initialize(board)
      @board = board
      @display = '*'
      @bomb = false
    end

    def set_bomb
      @bomb = true
    end

    def reveal
      if @bomb
        @display = "X"
      elsif self.neighbor_bomb_count < 1
        @display = "_"
      else
        @display = self.neighbor_bomb_count
      end

      @display
    end

    def neighbors
      mr_rogers = []

      (-1..1).each do |x_change|
        (-1..1).each do |y_change|
          new_indx = [x_change + index[0], y_change + index[1]]
          mr_rogers << new_indx if valid_index?(new_indx)
        end
      end

      mr_rogers.delete(index)
      mr_rogers
    end

    def neighbor_bomb_count
      # mr_rogers = neighbors
      #
      # bomb_count = 0
      # mr_rogers.each do |neighbor|
      #   x, y = neighbor
      #   if @board[x][y].bomb
      #     bomb_count += 1
      #   end
    end

    def valid_index?(ind)
      row, tile = ind

      return true if (0..8).to_a.include?(row) && (0..8).to_a.include?(tile)

      false
    end
end

b = Board.new
b.display
p b.board[3][3].neighbors