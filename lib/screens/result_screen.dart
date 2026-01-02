import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int player1Score;
  final int player2Score;
  final bool isAI;

  const ResultScreen({
    Key? key,
    required this.player1Score,
    required this.player2Score,
    this.isAI = false,
  }) : super(key: key);

  String getWinner() {
    if (player1Score > player2Score) {
      return isAI ? 'You Win!' : 'Blue Player Wins!';
    } else if (player2Score > player1Score) {
      return isAI ? 'AI Wins!' : 'Red Player Wins!';
    } else {
      return 'It\'s a Draw!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Result'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getWinner(),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '${isAI ? "Your" : "Blue Player"} Score: $player1Score',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              '${isAI ? "AI" : "Red Player"} Score: $player2Score',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
