import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stayzio_app/features/auth/data/provider/auth_provider.dart';
import 'package:stayzio_app/features/booking/data/provider/booking_provider.dart';
import 'package:stayzio_app/features/booking/data/provider/payment_card_provider.dart';
import 'package:stayzio_app/features/hotel/data/provider/hotel_provider.dart';
import 'package:stayzio_app/features/message/data/provider/message_provider.dart';
import 'package:stayzio_app/routes/app_route.dart';
import 'package:stayzio_app/style/theme/stayzio_theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => HotelProvider()),
      ChangeNotifierProvider(create: (_) => BookingProvider()),
      ChangeNotifierProvider(create: (_) => PaymentCardProvider()),
      ChangeNotifierProvider(create: (_) => MessageProvider()),
    ],
    child: MainApp(),
  ));
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
    );
  }
}
