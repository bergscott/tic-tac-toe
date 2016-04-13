class Tic_Tac_Toe

    class Board

	BLANK_LINE = "   |   |   "
	DIVIDING_LINE = "___|___|___"
	
	def initialize
	    @spaces = []
	    9.times {@spaces << new_space}
	end

	def new_space
	    Space.new
	end

	def render
	    render_top_row
	    render_middle_row
	    render_bottom_row
	end

	private
	    
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
    end
    
    def initialize(player1, player2)
	@player1 = player1
	@player2 = player2
    end

    def board
	@board ||= Board.new
    end
end
