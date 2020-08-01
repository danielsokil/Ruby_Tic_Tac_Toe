require 'curses'
require 'strings'

# Curses Library Resources
# - https://github.com/ruby/curses
# - http://www.cs.ukzn.ac.za/~hughm/os/notes/ncurses.html
# - https://atevans.com/2017/08/02/ruby-curses-for-terminal-apps.html
# - https://rosettacode.org/wiki/Terminal_control/Cursor_movement#Python
# - https://www.gnu.org/software/guile-ncurses/manual/html_node/index.html
# - https://www.youtube.com/playlist?list=PL2U2TQ__OrQ8jTf0_noNKtHMuYlyxQl4v
# - https://www.2n.pl/blog/basics-of-curses-library-in-ruby-make-awesome-terminal-apps
# - https://www.ibm.com/support/knowledgecenter/ssw_aix_72/generalprogramming/curses.html
# - https://stac47.github.io/ruby/curses/tutorial/2014/01/21/ruby-and-curses-tutorial.html

module TicTacToe
  module Interface
    # TUI
    class TextualInterface
      WINDOW_MARGIN = 2

      attr_accessor :game_board, :window, :cursor_coordinates

      def initialize(game_board)
        @game_board = game_board

        Curses.init_screen
        Curses.start_color
        Curses.use_default_colors # Use User Defined Terminal Colors
        Curses.curs_set(2) # Set Curser Very Visible
        Curses.noecho # Do Not Print Pressed Keys To The Screen
        Curses.cbreak # Ctrl+C Exits The Program

        @window = Curses::Window.new(0, 0, WINDOW_MARGIN, WINDOW_MARGIN) # Full Screen, With Some Margin

        window.nodelay = true # Do Not Block Waiting For Keyboard Input With `getch`
        window.keypad = true # Allow User To Move Around With The Keyboard (Up, Down, Left, Right)
        window.refresh # Refreshes The Screen

        @cursor_coordinates = {
          y: window.cury,
          x: window.curx
        }
      end

      def new_game
        welcome_message =
          %(Welcome to Ruby Tic Tac Toe
Tic-tac-toe is a game for two players, X and O, who take turns marking the spaces in a 3×3 grid.
The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row is the winner.
)

        window.addstr(Strings.wrap(welcome_message, 40))

        # Set Cursor To Bottom Of The Terminal, https://stackoverflow.com/a/54736503
        window.setpos(window.maxy - WINDOW_MARGIN, 0)
        window.addstr("Exit Game With Ctrl+C\n")
        window.setpos(0, 0)
      end

      def draw_board
        # TODO: How To Render In Free Space (After Welcome Message)? Versus Manually Hardcoding The Value
        window.setpos(10, 0)

        window.addstr("#{game_board[0][0]} | #{game_board[0][1]} | #{game_board[0][2]}\n")
        window.addstr("---------\n")
        window.addstr("#{game_board[1][0]} | #{game_board[1][1]} | #{game_board[1][2]}\n")
        window.addstr("---------\n")
        window.addstr("#{game_board[2][0]} | #{game_board[2][1]} | #{game_board[2][2]}\n")
      end

      def start_game_loop
        loop do # Render Loop
          yield # Assuming Block Givin
          window.refresh
        end
      rescue Interrupt => _e
        # Handling Ctrl+C, No Operation
        # Continue With Default Of Exiting The Program
      ensure
        # Close Screen Overlay After Game Loop Exits
        Curses.close_screen

        # Goodbye Message
        puts 'Thanks For Playing Tic Tac Toe, Goodbye!'
      end

      def handle_key_press
        # We Are Restoring Cursor Position Set By The User
        window.setpos(
          cursor_coordinates[:y],
          cursor_coordinates[:x]
        )

        key_press = window.getch

        case key_press
        when Curses::Key::UP
          cursor_coordinates[:y] = cursor_coordinates[:y] - 1
        when Curses::Key::DOWN
          cursor_coordinates[:y] = cursor_coordinates[:y] + 1
        when Curses::Key::LEFT
          cursor_coordinates[:x] = cursor_coordinates[:x] - 1
        when Curses::Key::RIGHT
          cursor_coordinates[:x] = cursor_coordinates[:x] + 1
        end
      end
    end
  end
end
