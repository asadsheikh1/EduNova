import 'dart:async';

import 'package:edu_nova/constants/component.dart';
import 'package:edu_nova/screens/sign_in_screen.dart';
import 'package:edu_nova/screens/tabs_screen.dart';
import 'package:edu_nova/utils/cache.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = '/splash';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserCacheData.userEmail = pref.getString('email');

    UserCacheData.userEmail == null
        ? Timer(
            const Duration(seconds: 1),
            () => Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false),
          )
        : Timer(
            const Duration(seconds: 1),
            () => Navigator.pushNamedAndRemoveUntil(context, TabsScreen.routeName, (route) => false),
          );
  }

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: size(context).height,
          width: size(context).width * 0.5,
          child: Image.asset(
            'assets/images/logo-light.png',
            height: size(context).height,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
