class TicTacToe

  class Board
    attr_reader :spaces, :lanes

    BLANK_LINE = "   |   |   "
    DIVIDING_LINE = "___|___|___"
    LANES = [%i(TL TM TR), %i(TL ML BL), %i(TL MM BR), %i(TM MM BM),
             %i(TR MM BL), %i(TR MR BR), %i(ML MM MR), %i(BL BM BR)]
    SPACE_NAMES = %i(TL TM TR ML MM MR BL BM BR)
    
    def initialize
        @spaces = {}
        SPACE_NAMES.each {|name| spaces[name] = new_space}
        @lanes = []
        LANES.each do |lane_members|
          lanes << Lane.new(lane_members.map {|space_name| spaces[space_name]})
        end
    end

    def render
        render_top_row
        render_middle_row
        render_bottom_row
    end

    # FIXME
    def mark_space(player, n)
      if spaces[n].open?
        spaces[n].owner = player
      else
        raise ArgumentError, "space is already claimed"
      end
    end

    def space_open?(n)
      spaces[n].open?
    end

    def full?
      spaces.values.none? {|space| space.open? }
    end

    def any_three_in_a_row?
      lanes.any? {|lane| lane.three_in_a_row?}
    end

    def winner
      lanes.each do |lane|
        winning_player = lane.winner
        return winning_player if winning_player
      end
      nil
    end

    private

    def new_space
        Space.new
    end
        
    def render_line(left, center, right)
        puts BLANK_LINE
        puts "#{spaces[left]}|#{spaces[center]}|#{spaces[right]}"
    end

    def render_top_row
        render_line(:TL, :TM , :TR)
        puts DIVIDING_LINE
    end

    def render_middle_row
        render_line(:ML, :MM, :MR)
        puts DIVIDING_LINE
    end

    def render_bottom_row
        render_line(:BL, :BM, :BR)
        puts BLANK_LINE
    end
  end

  class Lane
    attr_reader :spaces

    def initialize(list_of_spaces)
      @spaces = list_of_spaces
    end

    def three_in_a_row?
      spaces.all? {|space| space.filled? && space.owner == spaces.first.owner}
    end

    def winner
      three_in_a_row? ? spaces.first.owner : nil
    end

  end

  class Space
    attr_accessor :owner
    
    def initialize
      @owner = nil
    end

    def to_s
      case owner
      when "X"
        " X "
      when "O"
        " O "
      else
        "   "
      end
    end

    def open?
      owner.nil?
    end

    def filled?
      !self.open?
    end

  end

  class Player
    attr_reader :wins, :name

    def self.new_request_name(player_number)
      puts "Enter player #{player_number}'s name:"
      Player.new(gets.chomp)
    end

    def initialize(name)
      @name = name
      @wins = 0
    end

    def to_s
      name
    end

  end

  def self.play
    player1 = Player.new_request_name(1)
    player2 = Player.new_request_name(2)
    game = self.new(player1, player2)
    game.play_game(player1, player2)
  end

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
  end

  def play_game(p1, p2)
    reset_board
    loop do
      play_turn(p1, "X")
      break if declare_victor?
      play_turn(p2, "O")
      break if declare_victor?
    end
    show_board
    puts "Game over!"
    declare_victor
  end

  private

  def board
    @board ||= Board.new
  end

  def reset_board
    @board = Board.new
  end

  def play_turn(player, symbol)
    show_board
    puts "#{player}'s (#{symbol}'s) turn!"
    mark_space(symbol, get_move)
  end
  
  def show_board
    board.render
  end

  def get_move
    loop do
      puts "Mark which space? (enter '?' for help)"
      user = gets.chomp
      case user.upcase
      when "?"
        show_board
        show_choices
      when /^[TMB][LMR]$/
        return user.to_sym if valid_move?(user.to_sym)
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
    puts "Select a space by entering the corresponding letters: "
    puts "TL - Top Left"
    puts "TM - Top Middle"
    puts "TR - Top Right"
    puts "ML - Middle Left"
    puts "MM - Center (Middle Middle)"
    puts "MR - Middle Right"
    puts "BL - Bottom Left"
    puts "BM - Bottom Middle"
    puts "BR - Bottom Right"
  end

  def declare_victor?
    board.any_three_in_a_row? || board.full?
  end

  def declare_victor
    if board.any_three_in_a_row?
      puts "#{get_winner} won!"
    else
      puts "Cat's game."
    end
  end

  def get_winner
    board.winner
  end

end
