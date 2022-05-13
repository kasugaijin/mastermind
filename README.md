# mastermind
This Ruby program is a take on the mastermind boardgame. It is one player versus the computer. The player can choose to be a code maker, or code breaker. The code is 4 digits long comprised of the numbers 1 through 6. When the player is the code breaker, the computer sets the code and the player has 12 turns to guess the right code, receiving a hint for matches and partial matches each time. When the player is the code maker, they set the code and the machine has 12 turns to guess the code. A result is declared at the end of each game and the game can be replayed. 

This is built using object oriented programming structure and uses a module, three classes, and many different methods for logic. The logic for the computer to figure out the code as "breaker" is simple, but effective enough to guess the code enough times to be fun, but not all the time so that it's boring. The probability of the computer solving the code could be improved by adding all prior guesses to an array and checking that before pushing a new guess...any non-unique guesses would be reavaluated to prevent the same guess pushing twice and wasting a turn.

If you have Ruby installed, you can download the ruby.rb file and run it locally, or play it online here: https://replit.com/@BenJ8/mastermind#main.rb 

Game play still:
![game still](./Images/mastermind.png?raw=true "")
