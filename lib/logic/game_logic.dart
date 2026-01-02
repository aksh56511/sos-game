import 'sos_checker.dart';

class GameLogic {
  late List<List<String>> board;
  late List<List<bool>> playerBoard; // true for player1, false for player2
  late int gridSize;
  int player1Score = 0;
  int player2Score = 0;
  late SOSChecker sosChecker;

  GameLogic({required this.gridSize}) {
    board = List.generate(gridSize, (_) => List.filled(gridSize, ''));
    playerBoard = List.generate(gridSize, (_) => List.filled(gridSize, true));
    sosChecker = SOSChecker(gridSize: gridSize);
  }

  void makeMove(int row, int col, String letter, bool isPlayer1) {
    if (board[row][col] == '') {
      board[row][col] = letter;
      playerBoard[row][col] = isPlayer1;
      sosChecker.checkSOS(board, row, col, letter, isPlayer1);
      
      if (isPlayer1) {
        player1Score += sosChecker.sosCount;
      } else {
        player2Score += sosChecker.sosCount;
      }
    }
  }

  bool isGameOver() {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (board[i][j] == '') {
          return false;
        }
      }
    }
    return true;
  }

  void resetGame() {
    board = List.generate(gridSize, (_) => List.filled(gridSize, ''));
    playerBoard = List.generate(gridSize, (_) => List.filled(gridSize, true));
    player1Score = 0;
    player2Score = 0;
  }
}
