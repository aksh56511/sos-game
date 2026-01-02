import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SOSGameApp());
}

class SOSGameApp extends StatelessWidget {
  const SOSGameApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOS Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
