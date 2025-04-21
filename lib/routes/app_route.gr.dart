// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_route.dart';

/// generated route for
/// [AddNewCardScreen]
class AddNewCardRoute extends PageRouteInfo<void> {
  const AddNewCardRoute({List<PageRouteInfo>? children})
    : super(AddNewCardRoute.name, initialChildren: children);

  static const String name = 'AddNewCardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AddNewCardScreen();
    },
  );
}

/// generated route for
/// [BookingScreen]
class BookingRoute extends PageRouteInfo<void> {
  const BookingRoute({List<PageRouteInfo>? children})
    : super(BookingRoute.name, initialChildren: children);

  static const String name = 'BookingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BookingScreen();
    },
  );
}

/// generated route for
/// [ChatScreen]
class ChatRoute extends PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    Key? key,
    required User user,
    required User currentUser,
    required bool isOnline,
    List<PageRouteInfo>? children,
  }) : super(
         ChatRoute.name,
         args: ChatRouteArgs(
           key: key,
           user: user,
           currentUser: currentUser,
           isOnline: isOnline,
         ),
         initialChildren: children,
       );

  static const String name = 'ChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ChatRouteArgs>();
      return ChatScreen(
        key: args.key,
        user: args.user,
        currentUser: args.currentUser,
        isOnline: args.isOnline,
      );
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.user,
    required this.currentUser,
    required this.isOnline,
  });

  final Key? key;

  final User user;

  final User currentUser;

  final bool isOnline;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, user: $user, currentUser: $currentUser, isOnline: $isOnline}';
  }
}

/// generated route for
/// [CheckoutScreen]
class CheckoutRoute extends PageRouteInfo<CheckoutRouteArgs> {
  CheckoutRoute({
    Key? key,
    required int hotelId,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required int guests,
    required double totalPayment,
    List<PageRouteInfo>? children,
  }) : super(
         CheckoutRoute.name,
         args: CheckoutRouteArgs(
           key: key,
           hotelId: hotelId,
           checkInDate: checkInDate,
           checkOutDate: checkOutDate,
           guests: guests,
           totalPayment: totalPayment,
         ),
         rawPathParams: {'hotelId': hotelId},
         initialChildren: children,
       );

  static const String name = 'CheckoutRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CheckoutRouteArgs>();
      return CheckoutScreen(
        key: args.key,
        hotelId: args.hotelId,
        checkInDate: args.checkInDate,
        checkOutDate: args.checkOutDate,
        guests: args.guests,
        totalPayment: args.totalPayment,
      );
    },
  );
}

class CheckoutRouteArgs {
  const CheckoutRouteArgs({
    this.key,
    required this.hotelId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.guests,
    required this.totalPayment,
  });

  final Key? key;

  final int hotelId;

  final DateTime checkInDate;

  final DateTime checkOutDate;

  final int guests;

  final double totalPayment;

  @override
  String toString() {
    return 'CheckoutRouteArgs{key: $key, hotelId: $hotelId, checkInDate: $checkInDate, checkOutDate: $checkOutDate, guests: $guests, totalPayment: $totalPayment}';
  }
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [HotelDetailScreen]
class HotelDetailRoute extends PageRouteInfo<HotelDetailRouteArgs> {
  HotelDetailRoute({
    Key? key,
    required int hotelId,
    List<PageRouteInfo>? children,
  }) : super(
         HotelDetailRoute.name,
         args: HotelDetailRouteArgs(key: key, hotelId: hotelId),
         rawPathParams: {'hotelId': hotelId},
         initialChildren: children,
       );

  static const String name = 'HotelDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<HotelDetailRouteArgs>(
        orElse:
            () => HotelDetailRouteArgs(hotelId: pathParams.getInt('hotelId')),
      );
      return HotelDetailScreen(key: args.key, hotelId: args.hotelId);
    },
  );
}

class HotelDetailRouteArgs {
  const HotelDetailRouteArgs({this.key, required this.hotelId});

  final Key? key;

  final int hotelId;

  @override
  String toString() {
    return 'HotelDetailRouteArgs{key: $key, hotelId: $hotelId}';
  }
}

/// generated route for
/// [MainScreen]
class MainRoute extends PageRouteInfo<void> {
  const MainRoute({List<PageRouteInfo>? children})
    : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainScreen();
    },
  );
}

/// generated route for
/// [MessageScreen]
class MessageRoute extends PageRouteInfo<void> {
  const MessageRoute({List<PageRouteInfo>? children})
    : super(MessageRoute.name, initialChildren: children);

  static const String name = 'MessageRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MessageScreen();
    },
  );
}

/// generated route for
/// [PersonalInfoScreen]
class PersonalInfoRoute extends PageRouteInfo<void> {
  const PersonalInfoRoute({List<PageRouteInfo>? children})
    : super(PersonalInfoRoute.name, initialChildren: children);

  static const String name = 'PersonalInfoRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PersonalInfoScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [RequestToBookScreen]
class RequestToBookRoute extends PageRouteInfo<RequestToBookRouteArgs> {
  RequestToBookRoute({
    Key? key,
    required int hotelId,
    List<PageRouteInfo>? children,
  }) : super(
         RequestToBookRoute.name,
         args: RequestToBookRouteArgs(key: key, hotelId: hotelId),
         rawPathParams: {'hotelId': hotelId},
         initialChildren: children,
       );

  static const String name = 'RequestToBookRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<RequestToBookRouteArgs>(
        orElse:
            () => RequestToBookRouteArgs(hotelId: pathParams.getInt('hotelId')),
      );
      return RequestToBookScreen(key: args.key, hotelId: args.hotelId);
    },
  );
}

class RequestToBookRouteArgs {
  const RequestToBookRouteArgs({this.key, required this.hotelId});

  final Key? key;

  final int hotelId;

  @override
  String toString() {
    return 'RequestToBookRouteArgs{key: $key, hotelId: $hotelId}';
  }
}

/// generated route for
/// [SigninScreen]
class SigninRoute extends PageRouteInfo<void> {
  const SigninRoute({List<PageRouteInfo>? children})
    : super(SigninRoute.name, initialChildren: children);

  static const String name = 'SigninRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SigninScreen();
    },
  );
}

/// generated route for
/// [SignupScreen]
class SignupRoute extends PageRouteInfo<void> {
  const SignupRoute({List<PageRouteInfo>? children})
    : super(SignupRoute.name, initialChildren: children);

  static const String name = 'SignupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignupScreen();
    },
  );
}

/// generated route for
/// [YourCardScreen]
class YourCardRoute extends PageRouteInfo<void> {
  const YourCardRoute({List<PageRouteInfo>? children})
    : super(YourCardRoute.name, initialChildren: children);

  static const String name = 'YourCardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const YourCardScreen();
    },
  );
}
