import 'package:flutter/material.dart';
import 'package:majan_road/auth/loginPage.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  final Function(Locale) changeLanguage;

  const OnboardingScreen({Key? key, required this.changeLanguage})
      : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  double _fillProgress = 0.0;

  List<Map<String, String>> onboardingData = [
    {
      'title': 'Welcome to MyApp',
      'description': 'Discover amazing features and functionalities.',
      'image': 'assets/images/Onboarding 1.png',
    },
    {
      'title': 'Explore the App',
      'description': 'Navigate through various sections easily.',
      'image': 'assets/images/Onboarding 2.png',
    },
    {
      'title': 'Get Started Now',
      'description': 'Join us and experience the MyApp journey.',
      'image': 'assets/images/Onboarding 3.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
                _fillProgress = page / (onboardingData.length - 1);
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: onboardingData[index]['title']!,
                description: onboardingData[index]['description']!,
                image: onboardingData[index]['image']!,
                isLastPage: index == onboardingData.length - 1,
                onSkipPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('hasSeenOnboarding', true);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SignIn(changeLanguage: widget.changeLanguage),
                    ),
                  );
                },
                changeLanguage: widget.changeLanguage,
              );
            },
          ),
          Positioned(
            left: 20.0,
            bottom: 40.0,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: onboardingData.length,
              effect: const WormEffect(
                activeDotColor: Color(0xff55A5A4),
              ),
            ),
          ),
          Positioned(
            top: 60.0,
            right: 30.0,
            child: _currentPage < 2
                ? GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('hasSeenOnboarding', true);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SignIn(changeLanguage: widget.changeLanguage),
                        ),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xff55A5A4),
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          Positioned(
            right: 20.0,
            bottom: 20.0,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: _fillProgress),
              duration: const Duration(milliseconds: 500),
              builder: (context, double value, child) {
                return GestureDetector(
                  onTap: () async {
                    if (_currentPage < onboardingData.length - 1) {
                      _pageController.animateToPage(
                        _currentPage + 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    } else {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('hasSeenOnboarding', true);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SignIn(changeLanguage: widget.changeLanguage),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff55A5A4),
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final bool isLastPage;
  final VoidCallback onSkipPressed;
  final Function(Locale) changeLanguage;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.isLastPage,
    required this.onSkipPressed,
    required this.changeLanguage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 200.0,
          ),
          const SizedBox(height: 20.0),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(height: 20.0),
          isLastPage
              ? GestureDetector(
                  onTap: onSkipPressed,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xff55A5A4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
