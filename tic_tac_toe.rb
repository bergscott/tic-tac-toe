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
      if owner.nil?
        "   "
      else
        " #{owner.symbol} "
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
    attr_reader :wins, :name, :symbol

    def self.new_request_name(symbol)
      puts "Enter player #{symbol}'s name:"
      Player.new(gets.chomp, symbol)
    end

    def initialize(name, symbol)
      @name = name
      @wins = 0
      @symbol = symbol
    end

    def add_win
      @wins += 1
    end

    def to_s
      name
    end

  end

  attr_reader :player1, :player2, :cats_games

  def self.play
    player1 = Player.new_request_name("X")
    player2 = Player.new_request_name("O")
    game = self.new(player1, player2)
    game.play_games
  end

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @cats_games = 0
  end

  def play_games
    loop do
      play_game(player1, player2)
      break if stop_playing?
      play_game(player2, player1)
      break if stop_playing?
    end
    puts "Final stats:"
    show_stats
    puts "Goodbye!"
  end

  def play_game(p1, p2)
    reset_board
    loop do
      play_turn(p1)
      break if declare_victor?
      play_turn(p2)
      break if declare_victor?
    end
    show_board
    puts "Game over!"
    victor = declare_victor
    log_victor(victor)
  end

  private

  def board
    @board ||= Board.new
  end

  def reset_board
    @board = Board.new
  end

  def play_turn(player)
    show_board
    puts "#{player}'s (#{player.symbol}'s) turn!"
    mark_space(player, get_move)
  end

  def stop_playing?
    loop do
      puts "Play another game (Y/N)? (type 'stats' to see statistics)"
      user = gets.chomp
      case user.upcase
      when "Y", "YES"
        return false
      when "N", "NO"
        return true
      when "STATS"
        show_stats
      else
        puts invalid_input
      end
    end
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
        puts invalid_input
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
      winner = get_winner
      puts "#{winner} won!"
      winner
    else
      puts "Cat's game."
      nil
    end
  end

  def get_winner
    board.winner
  end
  
  def log_victor(victor)
    victor ? victor.add_win : increment_cats
  end

  def increment_cats
    @cats_games += 1
  end

  def show_stats
    puts "#{player1} wins: #{player1.wins}"
    puts "#{player2} wins: #{player2.wins}"
    puts "Cat's games: #{cats_games}"
  end

  def invalid_input
    "Invalid input, try again!"
  end
  
end
