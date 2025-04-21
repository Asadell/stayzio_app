import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:stayzio_app/routes/app_route.dart';

@RoutePage()
class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Text('signin'),
          ElevatedButton(
              onPressed: () {
                context.router.replace(const MainRoute());
                // context.router.push(
                //   const MainRoute(),
                // );
              },
              child: Text('MAIN'))
        ],
      )),
    );
  }
}
