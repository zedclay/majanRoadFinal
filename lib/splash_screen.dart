import 'package:flutter/material.dart';
import 'package:majan_road/auth/loginPage.dart';
import 'package:majan_road/base/homePage.dart';
import 'package:majan_road/onboarding.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final Function(Locale) changeLanguage;
  final bool showOnboarding;
  final VoidCallback toggleDarkMode;

  const SplashScreen({
    Key? key,
    required this.changeLanguage,
    required this.showOnboarding,
    required this.toggleDarkMode,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _a = true;
      });
    });
    Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _b = true;
      });
    });
    Timer(const Duration(milliseconds: 1300), () {
      setState(() {
        _c = true;
      });
    });
    Timer(const Duration(milliseconds: 1700), () {
      setState(() {
        _e = true;
      });
    });
    Timer(const Duration(milliseconds: 3400), () {
      setState(() {
        _d = true;
      });
    });
    Timer(const Duration(milliseconds: 3850), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? hasSeenOnboarding = prefs.getBool('hasSeenOnboarding');
      String? token = prefs.getString('token');
      if (token != null) {
        Navigator.of(context).pushReplacement(
          ThisIsFadeRoute(
            route: Homepage(
              changeLanguage: widget.changeLanguage,
              toggleDarkMode: widget.toggleDarkMode,
            ),
            page: Homepage(
              changeLanguage: widget.changeLanguage,
              toggleDarkMode: widget.toggleDarkMode,
            ),
          ),
        );
      } else if (hasSeenOnboarding == true) {
        Navigator.of(context).pushReplacement(
          ThisIsFadeRoute(
            route: SignIn(changeLanguage: widget.changeLanguage),
            page: SignIn(changeLanguage: widget.changeLanguage),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          ThisIsFadeRoute(
            route: OnboardingScreen(changeLanguage: widget.changeLanguage),
            page: OnboardingScreen(changeLanguage: widget.changeLanguage),
          ),
        );
      }
    });
  }

  bool _a = false;
  bool _b = false;
  bool _c = false;
  bool _d = false;
  bool _e = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff55A5A4),
      body: Center(
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: _d ? 900 : 2500),
              curve: _d ? Curves.fastLinearToSlowEaseIn : Curves.elasticOut,
              height: _d
                  ? 0
                  : _a
                      ? h / 2
                      : 20,
              width: 20,
            ),
            AnimatedContainer(
              duration: Duration(
                  seconds: _d
                      ? 1
                      : _c
                          ? 2
                          : 0),
              curve: Curves.fastLinearToSlowEaseIn,
              height: _d
                  ? h
                  : _c
                      ? 80
                      : 20,
              width: _d
                  ? w
                  : _c
                      ? 200
                      : 20,
              decoration: BoxDecoration(
                  color: _b ? Colors.white : Colors.transparent,
                  borderRadius: _d
                      ? const BorderRadius.only()
                      : BorderRadius.circular(30)),
              child: Center(
                child: _e
                    ? Image.asset(
                        'assets/images/majanMobile.png',
                        width: 200,
                        height: 200,
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThisIsFadeRoute extends PageRouteBuilder {
  final Widget page;
  final Widget route;

  ThisIsFadeRoute({required this.page, required this.route})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: route,
          ),
        );
}
