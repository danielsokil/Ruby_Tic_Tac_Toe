require_relative 'tic_tac_toe/interface.rb'
require_relative 'tic_tac_toe/game.rb'

module TicTacToe
  def self.start_game(
    game = TicTacToe::Game.new,
    interface = TicTacToe::Interface.new
  )
    puts interface.new_game

    # TODO: Game Logic To Check For Winner
    winner = false

    # Infinite Loop Until We Have A Winner
    until winner
      interface.draw_board(game.board)
      puts "\nPlayer X, Select Your Move!"
      player_x = interface.select_option
      game.update_board(player_x, 'X')

      interface.draw_board(game.board)
      puts "\nPlayer O, Select Your Move!"
      player_o = interface.select_option
      game.update_board(player_o, 'O')
    end
  end
end
