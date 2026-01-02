class SOSPattern {
  final int startRow;
  final int startCol;
  final int endRow;
  final int endCol;
  final bool isPlayer1;

  SOSPattern({
    required this.startRow,
    required this.startCol,
    required this.endRow,
    required this.endCol,
    required this.isPlayer1,
  });
}

class SOSChecker {
  int gridSize;
  int sosCount = 0;
  List<SOSPattern> patterns = [];

  SOSChecker({required this.gridSize});

  void checkSOS(List<List<String>> board, int row, int col, String player, bool isPlayer1) {
    sosCount = 0;

    // Check all possible SOS patterns that include the newly placed cell at (row, col)
    
    // Horizontal patterns where the new cell is at different positions
    // Pattern: S-O-S where new cell is S (left)
    if (col <= gridSize - 3) {
      if (board[row][col] == 'S' && board[row][col + 1] == 'O' && board[row][col + 2] == 'S') {
        sosCount++;
        patterns.add(SOSPattern(
          startRow: row, startCol: col,
          endRow: row, endCol: col + 2,
          isPlayer1: isPlayer1,
        ));
      }
    }
    // Pattern: S-O-S where new cell is O (middle)
    if (col >= 1 && col <= gridSize - 2) {
      if (board[row][col - 1] == 'S' && board[row][col] == 'O' && board[row][col + 1] == 'S') {
        sosCount++;
        patterns.add(SOSPattern(
          startRow: row, startCol: col - 1,
          endRow: row, endCol: col + 1,
          isPlayer1: isPlayer1,
        ));
      }
    }
    // Pattern: S-O-S where new cell is S (right)
    if (col >= 2) {
      if (board[row][col - 2] == 'S' && board[row][col - 1] == 'O' && board[row][col] == 'S') {
        sosCount++;
        patterns.add(SOSPattern(
          startRow: row, startCol: col - 2,
          endRow: row, endCol: col,
          isPlayer1: isPlayer1,
        ));
      }
    }

    // Vertical patterns
    // Pattern: S-O-S where new cell is S (top)
    if (row <= gridSize - 3) {
      if (board[row][col] == 'S' && board[row + 1][col] == 'O' && board[row + 2][col] == 'S') {
        sosCount++;
        patterns.add(SOSPattern(
          startRow: row, startCol: col,
          endRow: row + 2, endCol: col,
          isPlayer1: isPlayer1,
        ));
      }
    }
    // Pattern: S-O-S where new cell is O (middle)
    if (row >= 1 && row <= gridSize - 2) {
      if (board[row - 1][col] == 'S' && board[row][col] == 'O' && board[row + 1][col] == 'S') {
        sosCount++;
        patterns.add(SOSPattern(
          startRow: row - 1, startCol: col,
          endRow: row + 1, endCol: col,
          isPlayer1: isPlayer1,
        ));
      }
    }
    // Pattern: S-O-S where new cell is S (bottom)
    if (row >= 2) {
      if (board[row - 2][col] == 'S' && board[row - 1][col] == 'O' && board[row][col] == 'S') {
        sosCount++;
        patterns.add(SOSPattern(
          startRow: row - 2, startCol: col,
          endRow: row, endCol: col,
          isPlayer1: isPlayer1,
        ));
      }
    }

    // Diagonal (top-left to bottom-right) patterns
    // Pattern: S-O-S where new cell is S (top-left)
    if (row <= gridSize - 3 && col <= gridSize - 3) {
      if (board[row][col] == 'S' && board[row + 1][col + 1] == 'O' && board[row + 2][col + 2] == 'S') {
        sosCount++;
        patterns.add(SOSPattern(
          startRow: row, startCol: col,
          endRow: row + 2, endCol: col + 2,
          isPlayer1: isPlayer1,
        ));
      }
    }
    // Pattern: S-O-S where new cell is O (middle)
    if (row >= 1 && row <= gridSize - 2 && col >= 1 && col <= gridSize - 2) {
      if (board[row - 1][col - 1] == 'S' && board[row][col] == 'O' && board[row + 1][col + 1] == 'S') {
        sosCount++;
        patterns.add(SOSPattern(
          startRow: row - 1, startCol: col - 1,
          endRow: row + 1, endCol: col + 1,
          isPlayer1: isPlayer1,
        ));
      }
    }
    // Pattern: S-O-S where new cell is S (bottom-right)
    if (row >= 2 && col >= 2) {
      if (board[row - 2][col - 2] == 'S' && board[row - 1][col - 1] == 'O' && board[row][col] == 'S') {
        sosCount++;
        patterns.add(SOSPattern(
          startRow: row - 2, startCol: col - 2,
          endRow: row, endCol: col,
          isPlayer1: isPlayer1,
        ));
      }
    }

    // Diagonal (top-right to bottom-left) patterns
    // Pattern: S-O-S where new cell is S (top-right)
    if (row <= gridSize - 3 && col >= 2) {
      if (board[row][col] == 'S' && board[row + 1][col - 1] == 'O' && board[row + 2][col - 2] == 'S') {
        sosCount++;
        patterns.add(SOSPattern(
          startRow: row, startCol: col,
          endRow: row + 2, endCol: col - 2,
          isPlayer1: isPlayer1,
        ));
      }
    }
    // Pattern: S-O-S where new cell is O (middle)
    if (row >= 1 && row <= gridSize - 2 && col >= 1 && col <= gridSize - 2) {
      if (board[row - 1][col + 1] == 'S' && board[row][col] == 'O' && board[row + 1][col - 1] == 'S') {
        sosCount++;
        patterns.add(SOSPattern(
          startRow: row - 1, startCol: col + 1,
          endRow: row + 1, endCol: col - 1,
          isPlayer1: isPlayer1,
        ));
      }
    }
    // Pattern: S-O-S where new cell is S (bottom-left)
    if (row >= 2 && col <= gridSize - 3) {
      if (board[row - 2][col + 2] == 'S' && board[row - 1][col + 1] == 'O' && board[row][col] == 'S') {
        sosCount++;
        patterns.add(SOSPattern(
          startRow: row - 2, startCol: col + 2,
          endRow: row, endCol: col,
          isPlayer1: isPlayer1,
        ));
      }
    }
  }
}
