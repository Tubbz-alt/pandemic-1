# Mechanism

require_relative 'game'

class Mechanism

  attr_reader

  def initialize(game)
    @game = game
    @board = @game.board
  end

  def string_to_player(string)
    player = @game.players.select {|player| player.name == string}
    return player[0]
  end

  def string_to_player_card(string)
    if @board.player_card_event_names.include?(string)
      card = @board.player_cards.select {|card| card.event == string.to_sym}
    else
      card = @board.player_cards.select {|card| card.name == string}
    end
    return card[0]
  end

  def string_to_infection_card(string)
    card = @board.infection_cards.select {|card| card.cityname == string}
    return card[0]
  end


  def string_to_city(string)
    city = @board.cities.select {|city| city.name == string}
    return city[0]
  end

  def move_player(mover, to_string, moved = self)
    to = string_to_city(to_string)
    moved_current_city = string_to_city(moved.location)
    mover.move_pawn(to, moved)
    moved_current_city.pawn_move_from_city(moved)
    to.pawn_move_to_city(moved)
  end

  def deal_cards(from, number = 1, player)
    from.pop(number)
  end

  def discard_card_from_player_hand(player, card)
    player.discard_to_player_discard_pile(card)
    card.discard_to_player_discard_pile
  end

  def treat(player, city, color, number = 1)
    case color
      when :black
        var_in_game_class = @game.black_disease
      when :blue
        var_in_game_class = @game.blue_disease
      when :yellow
        var_in_game_class = @game.yellow_disease
      when :red
        var_in_game_class = @game.red_disease
      end
    end

    if player.role == :medic
      reduced = city.disease_reset(color)
    else
      city.treat(color, number)
      reduced = number
    end

    var_in_game_class.increase_cubes_available(reduced)

  end

end
