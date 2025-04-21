import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:stayzio_app/features/auth/data/model/user.dart';
import 'package:stayzio_app/features/auth/views/signin_screen.dart';
import 'package:stayzio_app/features/auth/views/signup_screen.dart';
import 'package:stayzio_app/features/booking/views/booking_screen.dart';
import 'package:stayzio_app/features/booking/views/checkout_screen.dart';
import 'package:stayzio_app/features/booking/views/request_to_book_screen.dart';
import 'package:stayzio_app/features/home/views/home_screen.dart';
import 'package:stayzio_app/features/hotel/views/hotel_detail_screen.dart';
import 'package:stayzio_app/features/main/main_screen.dart';
import 'package:stayzio_app/features/message/views/chat_screen.dart';
import 'package:stayzio_app/features/message/views/message_screen.dart';
import 'package:stayzio_app/features/profile/views/add_new_card_screen.dart';
import 'package:stayzio_app/features/profile/views/personal_info_screen.dart';
import 'package:stayzio_app/features/profile/views/profile_screen.dart';
import 'package:stayzio_app/features/profile/views/your_card_screen.dart';

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
        AutoRoute(
          page: PersonalInfoRoute.page,
        ),
        AutoRoute(
          page: YourCardRoute.page,
        ),
        AutoRoute(
          page: AddNewCardRoute.page,
        ),
        AutoRoute(
          page: MessageRoute.page,
        ),
        AutoRoute(
          page: ChatRoute.page,
        ),
        AutoRoute(
          page: HotelDetailRoute.page,
        ),
        AutoRoute(
          page: CheckoutRoute.page,
        ),
        AutoRoute(
          page: RequestToBookRoute.page,
        ),
      ];
}
