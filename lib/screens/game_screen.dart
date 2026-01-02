import 'dart:math';
import 'package:flutter/material.dart';
import '../logic/game_logic.dart';
import '../widgets/grid_cell.dart';
import '../widgets/score_board.dart';
import '../widgets/sos_line_painter.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final String gameMode;
  final bool isAI;

  const GameScreen({Key? key, required this.gameMode, this.isAI = false}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameLogic gameLogic;
  bool isPlayer1Turn = true;
  String player1SelectedLetter = 'S';
  String player2SelectedLetter = 'S';

  @override
  void initState() {
    super.initState();
    int gridSize = int.parse(widget.gameMode.split('x')[0]);
    gameLogic = GameLogic(gridSize: gridSize);
  }

  void _onCellTapped(int row, int col) {
    if (gameLogic.board[row][col] == '' && (isPlayer1Turn || !widget.isAI)) {
      setState(() {
        String letterToPlace = isPlayer1Turn ? player1SelectedLetter : player2SelectedLetter;
        gameLogic.makeMove(row, col, letterToPlace, isPlayer1Turn);
        isPlayer1Turn = !isPlayer1Turn;
      });

      if (gameLogic.isGameOver()) {
        _showResult();
      } else if (widget.isAI && !isPlayer1Turn) {
        // AI turn
        Future.delayed(const Duration(milliseconds: 500), () {
          _makeAIMove();
        });
      }
    }
  }

  void _makeAIMove() {
    // Smart AI: Try to win, block player, or make random move
    List<List<int>> emptyCells = [];
    for (int i = 0; i < gameLogic.gridSize; i++) {
      for (int j = 0; j < gameLogic.gridSize; j++) {
        if (gameLogic.board[i][j] == '') {
          emptyCells.add([i, j]);
        }
      }
    }
    
    if (emptyCells.isEmpty) return;
    
    // 1. Try to find a winning move (complete SOS for AI)
    for (var cell in emptyCells) {
      for (var letter in ['S', 'O']) {
        if (_wouldScore(cell[0], cell[1], letter)) {
          setState(() {
            gameLogic.makeMove(cell[0], cell[1], letter, false);
            isPlayer1Turn = true;
          });
          if (gameLogic.isGameOver()) _showResult();
          return;
        }
      }
    }
    
    // 2. Block player's winning move
    for (var cell in emptyCells) {
      for (var letter in ['S', 'O']) {
        if (_wouldScore(cell[0], cell[1], letter)) {
          setState(() {
            gameLogic.makeMove(cell[0], cell[1], letter, false);
            isPlayer1Turn = true;
          });
          if (gameLogic.isGameOver()) _showResult();
          return;
        }
      }
    }
    
    // 3. Make random move
    final random = Random();
    final randomCell = emptyCells[random.nextInt(emptyCells.length)];
    String aiLetter = random.nextBool() ? 'S' : 'O';
    
    setState(() {
      gameLogic.makeMove(randomCell[0], randomCell[1], aiLetter, false);
      isPlayer1Turn = true;
    });
    
    if (gameLogic.isGameOver()) _showResult();
  }
  
  bool _wouldScore(int row, int col, String letter) {
    // Check if placing this letter would complete an SOS
    
    // Horizontal checks
    // SOS where new cell is left S
    if (letter == 'S' && col + 2 < gameLogic.gridSize &&
        gameLogic.board[row][col + 1] == 'O' &&
        gameLogic.board[row][col + 2] == 'S') return true;
    
    // SOS where new cell is middle O
    if (letter == 'O' && col - 1 >= 0 && col + 1 < gameLogic.gridSize &&
        gameLogic.board[row][col - 1] == 'S' &&
        gameLogic.board[row][col + 1] == 'S') return true;
    
    // SOS where new cell is right S
    if (letter == 'S' && col - 2 >= 0 &&
        gameLogic.board[row][col - 2] == 'S' &&
        gameLogic.board[row][col - 1] == 'O') return true;
    
    // Vertical checks
    // SOS where new cell is top S
    if (letter == 'S' && row + 2 < gameLogic.gridSize &&
        gameLogic.board[row + 1][col] == 'O' &&
        gameLogic.board[row + 2][col] == 'S') return true;
    
    // SOS where new cell is middle O
    if (letter == 'O' && row - 1 >= 0 && row + 1 < gameLogic.gridSize &&
        gameLogic.board[row - 1][col] == 'S' &&
        gameLogic.board[row + 1][col] == 'S') return true;
    
    // SOS where new cell is bottom S
    if (letter == 'S' && row - 2 >= 0 &&
        gameLogic.board[row - 2][col] == 'S' &&
        gameLogic.board[row - 1][col] == 'O') return true;
    
    // Diagonal (top-left to bottom-right) checks
    // SOS where new cell is top-left S
    if (letter == 'S' && row + 2 < gameLogic.gridSize && col + 2 < gameLogic.gridSize &&
        gameLogic.board[row + 1][col + 1] == 'O' &&
        gameLogic.board[row + 2][col + 2] == 'S') return true;
    
    // SOS where new cell is middle O
    if (letter == 'O' && row - 1 >= 0 && col - 1 >= 0 &&
        row + 1 < gameLogic.gridSize && col + 1 < gameLogic.gridSize &&
        gameLogic.board[row - 1][col - 1] == 'S' &&
        gameLogic.board[row + 1][col + 1] == 'S') return true;
    
    // SOS where new cell is bottom-right S
    if (letter == 'S' && row - 2 >= 0 && col - 2 >= 0 &&
        gameLogic.board[row - 2][col - 2] == 'S' &&
        gameLogic.board[row - 1][col - 1] == 'O') return true;
    
    // Diagonal (top-right to bottom-left) checks
    // SOS where new cell is top-right S
    if (letter == 'S' && row + 2 < gameLogic.gridSize && col - 2 >= 0 &&
        gameLogic.board[row + 1][col - 1] == 'O' &&
        gameLogic.board[row + 2][col - 2] == 'S') return true;
    
    // SOS where new cell is middle O
    if (letter == 'O' && row - 1 >= 0 && col + 1 < gameLogic.gridSize &&
        row + 1 < gameLogic.gridSize && col - 1 >= 0 &&
        gameLogic.board[row - 1][col + 1] == 'S' &&
        gameLogic.board[row + 1][col - 1] == 'S') return true;
    
    // SOS where new cell is bottom-left S
    if (letter == 'S' && row - 2 >= 0 && col + 2 < gameLogic.gridSize &&
        gameLogic.board[row - 2][col + 2] == 'S' &&
        gameLogic.board[row - 1][col + 1] == 'O') return true;
    
    return false;
  }

  void _showResult() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          player1Score: gameLogic.player1Score,
          player2Score: gameLogic.player2Score,
          isAI: widget.isAI,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Score board
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: ScoreBoard(
                player1Score: gameLogic.player1Score,
                player2Score: gameLogic.player2Score,
                isPlayer1Turn: isPlayer1Turn,
              ),
            ),
            // Game grid with player controls on sides
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Blue Player (Player 1) - Left side
                    Container(
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isPlayer1Turn ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isPlayer1Turn ? Colors.blue : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Blue',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                player1SelectedLetter = 'S';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: player1SelectedLetter == 'S'
                                  ? Colors.blue
                                  : Colors.grey[400],
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              minimumSize: const Size(50, 40),
                            ),
                            child: const Text(
                              'S',
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                player1SelectedLetter = 'O';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: player1SelectedLetter == 'O'
                                  ? Colors.blue
                                  : Colors.grey[400],
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              minimumSize: const Size(50, 40),
                            ),
                            child: const Text(
                              'O',
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Game Grid - Center
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double size = constraints.maxHeight < constraints.maxWidth
                              ? constraints.maxHeight
                              : constraints.maxWidth;
                          return Center(
                            child: SizedBox(
                              width: size,
                              height: size,
                              child: Stack(
                                children: [
                                  GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: gameLogic.gridSize,
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1,
                                    ),
                                    itemCount: gameLogic.gridSize * gameLogic.gridSize,
                                    itemBuilder: (context, index) {
                                      int row = index ~/ gameLogic.gridSize;
                                      int col = index % gameLogic.gridSize;
                                      Color cellColor = Colors.black;
                                      if (gameLogic.board[row][col] != '') {
                                        cellColor = gameLogic.playerBoard[row][col] ? Colors.blue : Colors.red;
                                      }
                                      return GridCell(
                                        value: gameLogic.board[row][col],
                                        onTap: () => _onCellTapped(row, col),
                                        textColor: cellColor,
                                      );
                                    },
                                  ),
                                  // Draw SOS lines on top
                                  IgnorePointer(
                                    child: CustomPaint(
                                      size: Size(size, size),
                                      painter: SOSLinePainter(
                                        patterns: gameLogic.sosChecker.patterns,
                                        gridSize: gameLogic.gridSize,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Red Player (Player 2) - Right side
                    Container(
                      width: 80,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: !isPlayer1Turn ? Colors.red[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: !isPlayer1Turn ? Colors.red : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Red',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                player2SelectedLetter = 'S';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: player2SelectedLetter == 'S'
                                  ? Colors.red
                                  : Colors.grey[400],
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              minimumSize: const Size(50, 40),
                            ),
                            child: const Text(
                              'S',
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                player2SelectedLetter = 'O';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: player2SelectedLetter == 'O'
                                  ? Colors.red
                                  : Colors.grey[400],
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              minimumSize: const Size(50, 40),
                            ),
                            child: const Text(
                              'O',
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Back button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text('Back to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
