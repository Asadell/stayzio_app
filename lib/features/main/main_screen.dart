import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:stayzio_app/routes/app_route.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        BookingRoute(),
        MessageRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) {
              tabsRouter.setActiveIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(IconsaxPlusBold.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconsaxPlusBold.calendar_2),
                label: 'Booking',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconsaxPlusBold.message),
                label: 'Message',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconsaxPlusBold.profile),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
