# Turn
require_relative 'round'
require_relative 'action'
require 'fileutils'

class Turn

  attr_reader :action_left, :acts, :player, :game, :one_quiet_night

  def initialize(player, round)
    @player = player
    @round = round
    @game = @round.game
    @mech = @game.mech
    @location = @mech.string_to_city(player.location)
    @action_left = 4
    @acts = Array.new(4)
    @one_quiet_night = false
  end

  def play_turn
    actions if @game.game_run
    take_card_from_player_deck if @game.game_run
    infect if @game.game_run && !@one_quiet_night
  end

  def reduce_action_left
    @action_left -= 1
  end

  def one_quiet_night_mode
    @one_quiet_night = true
  end

  def actions
    while @action_left > 0
      act = Action.new(self)
      puts @player.name.underline + "'s turn. You have ".underline + @action_left.to_s.underline + " actions left.".underline
      puts "Role : " + @player.role.to_s
      print "Cards : "
      @player.names_of_player_cards_in_hand_based_color.each do |color|
        case color[0]
        when "red"
          print color[1..-1].to_s.red + ". "
        when "yellow"
          print color[1..-1].to_s.yellow + ". "
        when "blue"
          print color[1..-1].to_s.blue + ". "
        when "black"
          print color[1..-1].to_s.black.on_white + ". "
        end
      end

      print player.desc_of_event_cards_in_hand.to_s unless player.desc_of_event_cards_in_hand.empty?
      puts
      print "Location : "
      @mech.print_city_name_in_color(@mech.string_to_city(@player.location))
      print ", a Research Station city." if @mech.string_to_city(@player.location).research_st
      puts
      puts
      act.print_actions
      action_number = act.execute_player_action
      @acts[@action_left-4] = action_number if act.action_reduction == 1
      if @game.game_over?
        @game.end_game
        break
      end
      @action_left -= act.action_reduction
      puts
      save_game_file(@game.filename)
    end
  end

  def take_card_from_player_deck
    dealt_cards = @mech.deal_cards(@game.player_deck, 2)
    print "The following cards are taken from the Player Deck to " + @player.name + "'s hands : "
    card_description_in_color(dealt_cards)
    puts
    @mech.put_player_cards_into_hand(dealt_cards, @player)
    @acts[4] = dealt_cards
    save_game_file(@game.filename)
  end

  def infect
    number_of_infection_cards_taken = @game.infection_rate
    dealt_cards = @mech.deal_cards(@game.infection_deck, number_of_infection_cards_taken)
    print "The following cards are taken from the Infection Deck : "
    card_description_in_color(dealt_cards)
    puts

    dealt_cards.each do |card|
      infected_city = @mech.string_to_city(card.cityname)
      infected_city_original_color = infected_city.original_color

      @mech.perform_infect(infected_city, infected_city_original_color, 1)
      @mech.discard_card(@game.infection_discard_pile, card)
    end
    @acts[5]=dealt_cards
    save_game_file(@game.filename)
  end

  def card_description_in_color(cards_array)
    cards_array.each do |card|
      @mech.print_card_in_color(card)
      print ". "
    end
    puts
  end

  def save_game_file(filename)
    FileUtils.mkdir 'saved_games' if !File.exist?('saved_games')
    File.open("saved_games/#{filename}.yml","w"){|file| file.write(@game.to_yaml)}
  end

  def mid_turn?
    @acts.compact.size != 6
  end

end
