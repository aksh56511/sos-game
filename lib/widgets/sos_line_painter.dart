import 'package:flutter/material.dart';
import '../logic/sos_checker.dart';

class SOSLinePainter extends CustomPainter {
  final List<SOSPattern> patterns;
  final int gridSize;

  SOSLinePainter({required this.patterns, required this.gridSize});

  @override
  void paint(Canvas canvas, Size size) {
    double cellSize = size.width / gridSize;

    for (var pattern in patterns) {
      final paint = Paint()
        ..color = pattern.isPlayer1 ? Colors.blue.withOpacity(0.7) : Colors.red.withOpacity(0.7)
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round;

      // Calculate center points of start and end cells
      double startX = (pattern.startCol + 0.5) * cellSize;
      double startY = (pattern.startRow + 0.5) * cellSize;
      double endX = (pattern.endCol + 0.5) * cellSize;
      double endY = (pattern.endRow + 0.5) * cellSize;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(SOSLinePainter oldDelegate) {
    return oldDelegate.patterns.length != patterns.length;
  }
}
