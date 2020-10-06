require_relative "die"
require_relative "treasure_trove"
require_relative "loaded_die"

module GameTurn
    def self.take_turn(player)
        die = Die.new
        number_rolled = die.roll
        case die.roll
        when 5..6
            player.w00t
        when 3..4
            puts "#{player.name} was skipped."
        else
            player.blam
        end
        treasure = TreasureTrove.random
        player.found_treasure(treasure)
    end
end