require_relative "player"
require_relative "die"
require_relative "game_turn"
require_relative "treasure_trove"
require "csv"

module StudioGame
    class Game
        attr_reader :title

        def initialize(title)
            @title = title
            @players = []
        end

        def add_player(player)
            @players << player
        end

        def play(rounds)
            puts "There are #{@players.size} players in #{@title}: "
        
            @players.each do |player|
              puts player
            end

            treasures = TreasureTrove::TREASURES
            puts "\nThere are #{treasures.size} treasures to be found:"
            treasures.each do |treasure|
                puts "A #{treasure.name} is worth #{treasure.points} points"
            end
        
            1.upto(rounds) do |round|
                if block_given?
                    break if yield
                end
                puts "\nRound #{round}:"
                @players.each do |player|
                    GameTurn.take_turn(player)
                    puts player
                end
            end
        end

        def print_name_and_health(player)
            puts "#{player.name} (#{player.health})"
        end

        def print_stats
            strong, wimpy = @players.partition { |player| player.strong? }
            puts "\n#{title} Statistics:"

            puts "\n#{strong.size} strong players:"
            strong.each { |player| print_name_and_health(player) }

            puts "\n#{wimpy.size} wimpy players:"
            wimpy.each { |player| print_name_and_health(player) }

            puts "\n#{title} High Scores:"
            @players.sort.each do |player|
                puts high_score_entry(player)
            end

            @players.sort.each do |player|
                puts "\n#{player.name}'s point totals:"
                player.each_found_treasure do |treasure|
                  puts "#{treasure.points} total #{treasure.name} points"
                end
                puts "#{player.points} grand total points"
            end

            puts "#{total_points} total points from treasures found"
        end

        def total_points
            @players.reduce(0) { |sum, player| sum + player.points }
        end

        def load_players(from_file)
            CSV.foreach(from_file) do |row|
              player = Player.new(row[0], row[1].to_i)
              add_player(player)
            end
        end

        def save_high_scores(to_file="high_scores.txt")
            File.open(to_file, "w") do |file|
              file.puts "#{@title} High Scores:"
              @players.sort.each do |player|
                file.puts high_score_entry(player)
                end
            end
        end

        def high_score_entry(player)
            formatted_name = player.name.ljust(20, '.')
            "#{formatted_name} #{player.score}"
        end
    end
end