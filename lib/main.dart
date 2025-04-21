import 'package:flutter/material.dart';
import 'package:stayzio_app/style/theme/stayzio_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stayzio',
      theme: StayzioTheme.lightTheme,
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
