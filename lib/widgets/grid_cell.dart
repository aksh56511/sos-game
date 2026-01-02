import 'package:flutter/material.dart';

class GridCell extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  final Color textColor;

  const GridCell({
    Key? key,
    required this.value,
    required this.onTap,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
