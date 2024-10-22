# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = [
    rotations([[0, 1], [0, 0], [1, 1]]),
    [[[-2, 0], [-1, 0], [0, 0], [1, 0], [2, 0]],
     [[0, -2], [0, -1], [0, 0], [0, 1], [0, 2]]],
    rotations([[-1, 0], [0, 0], [-1, 1], [0, 1], [1, 1]]),
  ] + All_Pieces

  # your enhancements here

  # change next_piece refer to All_My_Pieces
  def self.next_piece (board)
    Piece.new(All_My_Pieces.sample, board)
  end

  def self.cheat_piece (board)
    Piece.new([[[0, 0]]], board)
  end
end

class MyBoard < Board
  # your enhancements here

  # change @current_block
  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
  end

  # gets the next piece
  def next_piece
    if @cheat == nil
      @current_block = MyPiece.next_piece(self)
    else
      @cheat = nil
      @current_block = MyPiece.cheat_piece(self)
    end
    @current_pos = nil
  end

  # change range from `3` to `(locations.length - 1)`
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.length - 1)).each{|index|
      current = locations[index];
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] =
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end

  # reduce 100 to score
  def enable_cheat
    if @score >= 100 and @cheat.nil?
      @score -= 100
      @cheat = true
    end
  end
end

class MyTetris < Tetris
  # your enhancements here

  # 'u' key to make the piece that is falling rotate 180 degrees
  def key_bindings
    super
    @root.bind('u', proc {2.times {@board.rotate_clockwise}})
    @root.bind('c', proc {@board.enable_cheat})
  end

  # change @board
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
end
