require 'pry'
require 'yaml'

module Actions
    def new_word #generates a new random word
        contents = File.read "5desk.txt"
        list_of_words = contents.split("\r\n")
        @word_to_guess = list_of_words[rand(list_of_words.length)].split(//)
        until @word_to_guess.length >= 5 && @word_to_guess.length <= 12
            @word_to_guess = list_of_words[rand(list_of_words.length)].split(//)
        end
    end

    def new_guess #checks to see if user input is an alphabet letter
        guess = gets.chomp.downcase
        until guess.length == 1 && ('a'..'z').to_a.include?(guess)
            puts "That's not a valid option, guess again!"
            guess = gets.chomp.downcase
        end
        return guess
    end

    def check_for_win #checks to see if the user has guessed the full word
        if word_to_display == word_to_guess
            puts "You win! You guessed the full word!"
            @guesses = 0
        else
            puts "Keep guessing!"
        end
    end
end

def save_game(game)
    # code here saves the game to a new folder called saved games

    yaml = YAML::dump(game)
    puts "The yaml looks like this"
    p yaml

    Dir.mkdir("saved_games") unless Dir.exists? "saved_games"

    filename = "saved_games/saved_game.rb"

    File.open(filename, 'w') do |file|
        file.write yaml
    end
end

def load_game

    filename = YAML.load(File.read("saved_games/saved_game.rb"))
    filename.continue_game

end

class Game

    include Actions

    attr_accessor :guesses, :missed_letters, :correct_letters, :word_to_guess, :word_to_display

    def initialize
        @guesses = 6
        @missed_letters = []
        @correct_letters = []
        @word_to_guess = []
        @word_to_display = []

        def new_game

            new_word
            
            p @word_to_guess.join() # to delete when done coding program
            
            i = 0
            until i == @word_to_guess.length
                @word_to_display.push("_")
                i += 1
            end
            p "This word is #{word_to_guess.length} characters long"
            p @word_to_display.join()
            continue_game
        end

        def continue_game
            until @guesses == 0
                puts "Do you want to save the game, but keep playing? Yes or No?"
                def save_game_check
                    save = gets.chomp.downcase
                    if save == "yes"
                        save_game(self)
                    elsif save != "no"
                        puts "That's not a possible selection!"
                        save_game_check
                    end
                end
                save_game_check

                puts "What letter are you guessing?"
                guess_this_turn = new_guess
                if @word_to_guess.include?(guess_this_turn)
                    @correct_letters.push(guess_this_turn)

                    j = 0
                    until j == word_to_guess.length
                        if @correct_letters.include?(@word_to_guess[j])
                            @word_to_display[j] = @word_to_guess[j]
                        end
                        j += 1
                    end

                    puts word_to_display.join()
                    check_for_win
                elsif @missed_letters.include?(guess_this_turn) || @correct_letters.include?(guess_this_turn)
                    puts "You've already guessed that letter! You've guessed #{@missed_letters} incorrectly."
                else
                    @guesses -= 1
                    @missed_letters.push(guess_this_turn)
                    puts "That letter isn't in the word!"
                    puts "You have #{@guesses} guesses left!"
                    puts "You've guessed #{@missed_letters} incorrectly already."
                    if @guesses == 0
                        puts "Oh no! You didn't guess the word in time! You lose!"
                    end
                end
            end
        end

        def check_for_load

            puts "Do you want to load a previous game?"
            def load_game_check
                load = gets.chomp.downcase
                if load == "yes"
                    load_game
                elsif load != "no"
                    puts "That's not a possible selection!"
                    load_game_check
                else
                    new_game
                end
            end
            load_game_check
        end 

    end

end

new_hangman_game = Game.new()
new_hangman_game.check_for_load