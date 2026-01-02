# SOS Game

A Flutter web-based implementation of the classic SOS game where players compete to create SOS patterns on a grid.

## Features

- **Multiple Game Modes**
  - 8x8 Grid (2 Players)
  - 16x16 Grid (2 Players)
  - 8x8 Grid (vs Smart AI)

- **Smart AI Opponent**
  - Looks for winning moves to complete SOS patterns
  - Blocks opponent's potential SOS patterns
  - Makes strategic random moves when no patterns are available

- **Visual Feedback**
  - Color-coded letters (Blue for Player 1, Red for Player 2)
  - SOS patterns highlighted with colored lines
  - Active player indication
  - Real-time score tracking

- **Responsive Design**
  - Player controls positioned on sides of the board
  - Fullscreen grid layout
  - Clean, modern UI

## How to Play

1. Players take turns placing either 'S' or 'O' on empty cells
2. Select your letter (S or O) using the buttons on the side
3. Click an empty cell to place your selected letter
4. Complete an SOS pattern (horizontally, vertically, or diagonally) to score points
5. The player who creates the SOS pattern wins the point
6. Game ends when the board is full
7. Player with the most points wins!

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── screens/
│   ├── home_screen.dart       # Main menu
│   ├── game_screen.dart       # Game interface
│   └── result_screen.dart     # Results display
├── logic/
│   ├── game_logic.dart        # Game state management
│   └── sos_checker.dart       # SOS pattern detection
└── widgets/
    ├── grid_cell.dart         # Individual cell widget
    ├── score_board.dart       # Score display
    └── sos_line_painter.dart  # Visual line drawing
```

## Running the Game

### Prerequisites
- Flutter SDK (3.38.5 or higher)
- Web support enabled

### Build and Run
```bash
# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Run in debug mode
flutter run -d chrome

# Build for production
flutter build web --release

# Serve the built files
cd build/web
python3 -m http.server 8080
```

Then open http://localhost:8080 in your browser.

## Technologies Used

- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **Custom Painter** - For drawing SOS pattern lines
- **Material Design** - UI components

## Game Rules

- Both players can choose 'S' or 'O' on each turn (unlike traditional tic-tac-toe)
- Creating an SOS pattern awards points to the player who completed it
- Patterns can be:
  - Horizontal (→)
  - Vertical (↓)
  - Diagonal (↘ or ↙)
- Multiple patterns can be created in a single move
- All patterns are visually marked with colored lines

## License

MIT License