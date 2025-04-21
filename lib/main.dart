import 'package:flutter/material.dart';
import 'package:stayzio_app/routes/app_route.dart';
import 'package:stayzio_app/style/theme/stayzio_theme.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Stayzio',
      routerConfig: appRouter.config(),
      theme: StayzioTheme.lightTheme,
      // home: Scaffold(
      //   body: Center(
      //     child: Text('Hello World!'),
      //   ),
      // ),
    );
  }
}
