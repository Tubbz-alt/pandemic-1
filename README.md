# Pandemic, a Ruby Project

Based on the board game Pandemic.

## README

### tl;dr

This document provides documentation to be used to play the Ruby Pandemics. For Pandemic rules, [click here on  wikipedia](http://tinyurl.com/hvr9nfr). Number of players = 2 to 4.

### Environment

1. Open bash (on Macbooks) or others similar you'd like available on your own machine.
2. Make sure Ruby is installed by running `$ ruby -v`.
3. Install `colorize`, a ruby gem, by running `$ gem install colorize`.
4. This game is run right on the command line. Go to your local `pandemic` folder in bash. Then see 'Starting the Game' section below.

### Starting the Game

Run `$ ruby pandemic.rb` on command line.

### Saving and Loading a Game

##### Saving

The game is autosaved after completing each action in a turn. Yaml serialization is used, and the file is saved in saved_games folder. When prompted to specify a filename to save the game, `.yml` extension is not required. E.g : if you want the game to be saved as `mygame.yml`, you can just input `mygame`.

##### Loading

Analogously, when prompted which filename of a game to load, type in only the filename without the extension.

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


### Help Commands

##### Related to the game state

These commands are inputted during the action `Help, Communicate with the board to get game status.`

- `players_order` to show the players order (who goes first, etc).
- `players` to show details of all players.
- `infection_rate` to show the current infection rate.
- `outbreak_index` to show the current outbreak index.
- `black_disease` to show the status of black disease. Other available commands are `blue_disease`, `red_disease`, and `yellow_disease`.
- `show_cities` to show cities with any cubes. Other commands allowed  are `show_cities(1)`, `show_cities(2)` and `show_cities(3)` to show cities which number of cubes is 1, 2, and 3, respectively.
- `research_st_cities` to show cities with research stations.

##### Related to Cities

- `city_info` to show the status of a city.
