class TicTacToe

  class Board
    attr_reader :spaces

    BLANK_LINE = "   |   |   "
    DIVIDING_LINE = "___|___|___"
    
    def initialize
        @spaces = []
        9.times {@spaces << new_space}
    end

    def render
        render_top_row
        render_middle_row
        render_bottom_row
    end

    def mark_space(player, n)
      if @spaces[n].owner.nil?
        @spaces[n].owner = player
      else
        raise ArgumentError, "space is already claimed"
      end
    end

    def space_open?(n)
      spaces[n].open?
    end

    private

    def new_space
        Space.new
    end
        
    def render_line(left, center, right)
        puts BLANK_LINE
        puts "#{@spaces[left]}|#{@spaces[center]}|#{@spaces[right]}"
    end

    def render_top_row
        render_line(0, 1 , 2)
        puts DIVIDING_LINE
    end

    def render_middle_row
        render_line(3, 4, 5)
        puts DIVIDING_LINE
    end

    def render_bottom_row
        render_line(6, 7, 8)
        puts BLANK_LINE
    end
  end

  class Space
    attr_accessor :owner
    
    def initialize
      @owner = nil
    end

    def to_s
      case @owner
      when :player1
        " X "
      when :player2
        " O "
      else
        "   "
      end
    end

    def open?
      owner.nil?
    end

  end

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def play
    loop do
      play_turn(:player1, "X")
      break if declare_victor?
      play_turn(:player2, "O")
      break if declare_victor?
    end
  end

  def board
    @board ||= Board.new
  end

  private

  def play_turn(player, symbol)
    show_board
    puts "#{player}'s (#{symbol}'s) turn!"
    mark_space(player, get_move)
  end
  
  def show_board
    board.render
  end

  def get_move
    loop do
      puts "Mark which space (enter '?' for help)"
      user = gets.chomp
      case user
      when "?"
        show_choices
      when /^[0-8]$/
        return user.to_i if valid_move?(user.to_i)
        puts "Space is already taken. Try again!"
      else
        puts "Invalid input, try again!"
      end
    end
  end

  def mark_space(player, n)
    board.mark_space(player, n)
  end

  def valid_move?(n)
    board.space_open?(n)
  end

  def show_choices
    show_board
    puts "Select a space by entering the corresponding number: "
    puts "0. Top Left"
    puts "1. Top Middle"
    puts "2. Top Right"
    puts "3. Middle Left"
    puts "4. Center"
    puts "5. Middle Right"
    puts "6. Bottom Left"
    puts "7. Bottom Middle"
    puts "8. Bottom Right"
  end

  def declare_victor?
    false
  end

end
