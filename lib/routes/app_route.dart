import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:stayzio_app/features/auth/views/signin_screen.dart';
import 'package:stayzio_app/features/auth/views/signup_screen.dart';
import 'package:stayzio_app/features/booking/views/booking_screen.dart';
import 'package:stayzio_app/features/home/views/home_screen.dart';
import 'package:stayzio_app/features/hotel/views/hotel_screen.dart';
import 'package:stayzio_app/features/main/main_screen.dart';
import 'package:stayzio_app/features/message/views/message_screen.dart';
import 'package:stayzio_app/features/profile/views/profile_screen.dart';

part 'app_route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SigninRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: SignupRoute.page,
        ),
        AutoRoute(
          page: MainRoute.page,
          children: [
            AutoRoute(
              page: HomeRoute.page,
              initial: true,
            ),
            AutoRoute(page: BookingRoute.page),
            AutoRoute(page: MessageRoute.page),
            AutoRoute(page: ProfileRoute.page),
          ],
        ),
      ];
}
