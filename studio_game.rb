require_relative "player"
require_relative "game"
require_relative "clumsy_player"

player1 = Player.new("moe")
player2 = Player.new("larry", 60)
player3 = Player.new("curly", 125)
klutz = ClumsyPlayer.new("klutz", 105, 3)

knuckleheads = Game.new("Knuckleheads")
knuckleheads.load_players(ARGV.shift || "players.csv")
knuckleheads.add_player(klutz)

loop do 
    puts "\nHow many game rounds? ('quit' to exit)"
    answer = gets.chomp.downcase
    case answer
    when /^\d+$/
        knuckleheads.play(answer.to_i) do
            knuckleheads.total_points >= 2000
        end
    when "quit", "exit"
        knuckleheads.print_stats
        break
    else
        puts "Please enter a number or 'quit'"
    end
end

knuckleheads.save_high_scores