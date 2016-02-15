# Pandemic, a Ruby Project

Based on the board game Pandemic.

## README

### tl;dr

This document provides documentation to be used to play the Ruby Pandemics. For Pandemic rules, [click here on  wikipedia](http://tinyurl.com/hvr9nfr).

### Environment

1. Open bash (on Macbooks) or others similar you'd like available on your own machine. This game is run in `pry`, a gem for Ruby REPL.
2. Make sure Ruby is installed by running `$ ruby -v`.
3. Install `pry` (if not installed yet) by running `$ gem install pry`.
4. Once `pry` is installed, open it = `$ pry`.
5. Start the game by initiating an object of class Game. See "Starting the game" below.
6. Exit pry = `$ exit`

### Starting the game

Type the following in sequence when already in `pry`:

```ruby
load 'game.rb'
g = Game.new
```

### List of roles

| Role | Pawn | Ability |
| :---: | :---: | :---: |
| Contingency Planner | ♲ | The contingency planner may, as an action, take an Event card from anywhere in the Player Discard Pile and place it on his Role Card. Only 1 Event Card can be on his role card at a time. It does not count against his hand limit. When the Contingency Planner plays the Event card on his role card, remove this Event card from the game (instead of discarding it).|
| Dispatcher | ✈ | The dispatcher may, as an action, either : move any pawn, if its owner agrees, to any city containing another pawn, or move another player's pawn, if its owner agrees, as if it were his own. When moving a player's pawn as if it were your own, discard cards for Direct and Charter Flights from your hand. A card discarded for a Charter Flight must match the city the pawn is moving from.|
| Medic | ⛑ | The medic removes all cubes, not 1, of the same color when doing the Treat Disease action. If a disease has been cured, he automatically removes all cubes of that color from a city, simply by entering it or being there. This does not take an action. The medic's automatic removal of cubes can occur on other players' turns, if he is moved by the dispatcher or the airlift event. |
| Operations Expert | ☖ | The operations expert may, as an action, either: build a research station in his current city without discarding (or using) a city card, or, once per turn, move from a research station to any city by discarding any city card. The dispatcher may not use the operation expert's special move ability when moving the operation expert's pawn. |
| Quarantine Specialist | ☢ | The quarantine specialist prevents both outbreaks and the placement of disease cubes in the city she is in and all cities connected to that city. She does not affect cubes placed during setup. |
| Researcher | ⚭ | When doing the share knowledge action, the researcher may give any city from her hand to another player in the same city as her, without this card having to match her city. The transfer must be from her hand to the other player's hand, but it can occur on either player's turn. |
| Scientist | ⚗ | The scientist needs only 4 (not 5) city cards of the same disease color to discover a cure for that disease. |

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


### Commands **in pry**

#### Related to the game state

- `g.players_order` to show the players order (who goes first, etc).
- `g.player(1)` to show details of player 1.
- `g.players` to show details of all players.
- `g.infection_rate` to show the current infection rate.
- `g.outbreak_index` to show the current outbreak index.
- `g.black_disease` to show the status of black disease. Other available commands are `g.blue_disease`, `g.red_disease`, and `g.yellow_disease`.
- `g.research_station_availability` to show available research stations.
- `g.show_cities` to show cities with any cubes. Other commands allowed  are `g.show_cities(1)`, `g.show_cities(2)` and `g.show_cities(3)` to show cities which number of cubes is 1, 2, and 3, respectively.
- `g.research_st_cities` to show cities with research stations.

#### Related to Cities

- `g.board.algiers.show_info` to show the info of Algier.
- `g.board.algiers.show_neighbors` to show the info of Algier's neighbors.
- `g.show_cities` to show cities with any cubes. Other commands allowed  are `g.show_cities(1)`, `g.show_cities(2)` and `g.show_cities(3)` to show cities which number of cubes is 1, 2, and 3, respectively.
