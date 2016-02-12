Command

tl;dr
This document provides documentation on commands to be used to play the Ruby Pandemics.

Environment
1. Open bash (on Macbooks) or others similar you'd like available on your own machine. This game is run in pry, a gem for Ruby REPL.
2. Make sure Ruby is installed by running ruby -v
3. Install pry (if not installed yet) by running gem install pry
4. Once pry is installed, get into pry by typing pry
5. Start the game by initiating an object of class Game. See "Starting the game" below

Starting the game
Type the following when already in pry (exlcuding colon sign):
g = Game.new

Commands

Related to the game state

- g.player(1) to show details of player 1.
- g.players to show details of all players.
- g.infection_rate to show the current infection rate.
- g.outbreak_index to show the current outbreak index.
- g.black_disease to show the status of black disease. Other available colors are red, yellow and blue.

Related to Cities

- g.board.algiers.show_info; to show the info of Algier.
- g.board.algiers.show_neighbors; to show the info of Algier's neighbors.
