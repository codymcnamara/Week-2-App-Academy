require 'yaml'
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

  def save
    #puts "do you wanna save game?"
    puts "What would you like to call the file"
    filename = gets.chomp

    File.open("#{filename}.rb", 'w') do |f1|
      f1.puts self.to_yaml
    end
<<<<<<< HEAD
=======
    # puts "saved!"
>>>>>>> 843d70b0e04088306c756c3268301e0c493d21cb
  end

  def play

    loop do
      display
      puts "Do you want to reveal (r) or flag (f)?"
      input = gets.chomp

      puts "Please enter coordinates (x, y)"
      coords = gets.chomp.split(",").map(&:to_i)
      x, y = coords

      if input == 'f'
        @board[x][y].display = 'F'
      else
        if @board[x][y].reveal == "_"
          to_explore = @board[x][y].neighbors
          checked = [@board[x][y]]
          check_all_neighbors(to_explore, checked)
        end
      end

      if won?
        puts "YOU WON!"
        exit
      end

      puts "do you wanna save (y/n)"
      response = gets.chomp
      if response == "y"
        save
        exit
      end
    end

  end

  def won?
    @board.each do |row|
      row.each do |tile|
        # p "tile: #{tile}"
        # p "tile display: #{tile.display}"
        if tile.display == "*"
          return false
        end
      end
    end

    true
  end

  def check_all_neighbors(to_explore, checked)

    candidate = to_explore.pop
    #
    # x, y = candidate
    # candidate =
    #### changed neighbors method
    while candidate != nil
      if candidate.neighbor_bomb_count == 0 && !(checked.include?(candidate))
        candidate.reveal unless candidate.flagged?
        checked << candidate
        check_all_neighbors(candidate.neighbors, checked)
      elsif !(checked.include?(candidate))
        candidate.reveal unless candidate.flagged?
        checked << candidate
      else
        checked << candidate
      end

      candidate = to_explore.pop
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
        print  tile.display.to_s + " |"
      end
      puts ""
    end
  end
end

class Tile
    attr_accessor :display, :index, :bomb, :board, :board_class
    def initialize(board_class)
      @board_class = board_class
      @display = '*'
      @bomb = false
    end

    def set_bomb
      @bomb = true
      @display = "B"
    end

    def flagged?
      return true if @display == "F"

      false
    end

    def reveal
      if !flagged?
        if @bomb
          @display = "X"
          puts "YOU LOSE!"
          @board_class.display
          exit
        elsif self.neighbor_bomb_count > 0
          @display = self.neighbor_bomb_count
        else
          @display = "_"
        end
      else
        puts "cannot "
      end

      @display
    end

    # def check_all_neighbors(new_tile, checked)
      # candidates = tile.neighbors.map do |location|
      #   x, y = location
      #   @board[x][y]
      # end
      #
      # candidates.each do |canidate|
      #   if candidate.neighbor_bomb_count == 0
      #     checked << canidate
      #     canidate.
      #
    # end

    def neighbors
      mr_rogers = []

      (-1..1).each do |x_change|
        (-1..1).each do |y_change|
          new_indx = [x_change + index[0], y_change + index[1]]
          mr_rogers << new_indx if valid_index?(new_indx)
        end
      end

      mr_rogers.delete(index)
      mr_rogers.map{|arr| @board[arr[0]][arr[1]]}
    end

    def neighbor_bomb_count
      @board = @board_class.board

      mr_rogers = neighbors

      bomb_count = 0
      mr_rogers.each do |neighbor|
        if neighbor.bomb
          bomb_count += 1
        end
      end

      bomb_count
    end

    def valid_index?(ind)
      row, tile = ind

      return true if (0..8).to_a.include?(row) && (0..8).to_a.include?(tile)

      false
    end
end

puts "Wanna load an old game? (y/n)"
response = gets.chomp
if response == "y"
  puts "what's the name of the file?"
  load_file = gets.chomp
  old_board = YAML::load_file("#{load_file}.rb")
  old_board.play
else
  b = Board.new
  b.play
end
