# Chess
A 2 player command-line chess game made using Ruby. It implements all the functionality and rules of chess. If you aern't familiar with the rules, [this](https://en.wikipedia.org/wiki/Chess) might help. You can run this program on Replit:
<br><br>
[![Run on Repl.it](https://replit.com/badge/github/Mohammad4844/Chess)](https://replit.com/new/github/Mohammad4844/Chess)
<br>
## Features/Rules implemented
- A command-line display of the board
- Moving and capturing of pieces
- Check & checkmate detection
- Stalemate detection
- Special moves: promotion & en passant
- Games can be saved and played at a later time
## Summary of Library
1) `main.rb` Tis is the staring point of the program
2) `game.rb` This includes the `Game` class, which is responsible for setting up and modifying the state of the game. This includes setting the mode of the game, setting up the players, playing rounds by getting player input, and other save-related things like saving and loading up games. Includes the `Display` module used for all printing to the console.
3) `board.rb` This includes the `Board` class, which is the backbone of this program. It includes all the chess functionality, moving/taking pieces, checking moves for legality, detecting checks, detecting checkmates, ability for hypothetical moves (to see if moves can cause or remove check), detecting stalemates, and also special move types. Includes `BoardHelpers`, which has useful methods including the initial setup of the board.
4) `pieces/` This is a folder that contains all the pieces file. All the pieces inherit from the `Piece` class. The main role of these classes is to give the possible moves a piece can make in that position. A `NoPiece` class also exists that signifies an empty space, opening room for polymorphism.
## Features for the Future
- Castling movement
- Computer / Bot to play chess against
