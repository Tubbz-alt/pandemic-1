# Pandemic, a Ruby Project

Based on the board game Pandemic.

## README

### tl;dr

This document provides documentation to be used to play the Ruby Pandemics. For Pandemic rules, [click here on  wikipedia](http://tinyurl.com/hvr9nfr).

### Environment

1. Open bash (on Macbooks) or others similar you'd like available on your own machine. This game is run in `pry`, a gem for Ruby REPL.
2. Make sure Ruby is installed by running `ruby -v`.
3. Install `pry` (if not installed yet) by running `gem install pry`.
4. Once `pry` is installed, open it by typing `pry`.
5. Start the game by initiating an object of class Game. See "Starting the game" below

### Starting the game

Type the following when already in pry (exlcuding colon sign):
`g = Game.new`

### List of Cities

By Color (then alphabetical)

| Blue | Red | Yellow | Black |
| :---: | :---: | :---: | :---: |
| Atlanta | Bangkok | Bogota | Algiers |
| Chicago | Beijing | Buenos Aires | Baghdad |
| Essen | Ho Chi Minh | Johannesburg | Cairo |
| London | Jakarta | Khartoum | Chennai |
| Madrid | Hong Kong | Kinshasa | Delhi |
| Milan | Manila | Lagos | Istanbul |
| Montreal | Osaka | Lima | Karachi |
| New York | Seoul | Los Angeles | Kolkata |
| Paris | Shanghai | Mexico City | Moscow |
| San Francisco | Sydney | Miami | Mumbai |
| St Petersburg | Taipei | Santiago | Riyadh |
| Washington | Tokyo | Sao Paolo | Tehran |


### Commands Lines

#### Related to the game state

- `g.player(1)` to show details of player 1.
- `g.players` to show details of all players.
- `g.infection_rate` to show the current infection rate.
- `g.outbreak_index` to show the current outbreak index.
- `g.black_disease` to show the status of black disease. Other available commands are `g.blue_disease`, `g.red_disease`, and `g.yellow_disease`.
- `g.research_station_availability` to show available research stations.
- `g.show_cities(1)` to show cities which number of cubes is 1. Other commands allowed  are `g.show_cities(2)` and `g.show_cities(3)`.

#### Related to Cities

- `g.board.algiers.show_info` to show the info of Algier.
- `g.board.algiers.show_neighbors` to show the info of Algier's neighbors.
- `g.show_cities(1)` to show cities which number of cubes is 1. Other commands allowed  are `g.show_cities(2)` and `g.show_cities(3)`.
