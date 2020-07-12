require 'pry'

module Actions
    def new_word

        #generates a new random word

        contents = File.read "5desk.txt"
        list_of_words = contents.split("\r\n")
        @word_to_guess = list_of_words[rand(list_of_words.length)].split(//)
        until @word_to_guess.length >= 5 && @word_to_guess.length <= 12
            @word_to_guess = list_of_words[rand(list_of_words.length)].split(//)
        end

    end

    def new_guess
        guess = gets.chomp.downcase
        until guess.length == 1 && ('a'..'z').to_a.include?(guess)
            puts "That's not a valid option, guess again!"
            guess = gets.chomp.downcase
        end
        return guess
    end

    # Updates the word_to_display to show which characters have been guessed right and which ones are empty
    def update_word_to_display

    end

    def check_for_win
        if word_to_display == word_to_guess
            puts "You win! You guessed the full word!"
            @guesses = 0
        else
            puts "Keep guessing!"
        end
    end
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

        def play_game

            new_word
            
            p @word_to_guess.join() # to delete
            
            i = 0
            until i == @word_to_guess.length
                @word_to_display.push("_")
                i += 1
            end
            p "This word is #{word_to_guess.length} characters long"
            p @word_to_display.join()

            until @guesses == 0
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

                else
                    @guesses -= 1
                    @missed_letters.push(guess_this_turn)
                    puts "That letter isn't in the word!"
                    puts "You have #{@guesses} guesses left!"
                end
            end

        end
    end
end

new_hangman_game = Game.new()
new_hangman_game.play_game