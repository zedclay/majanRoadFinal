import 'package:flutter/material.dart';
import 'package:majan_road/base/homePageContent.dart';
import 'package:majan_road/hotels/hotelPage.dart';
import 'package:majan_road/settings/settingsPage.dart';
import 'package:majan_road/trips/tripsPage.dart';

class HomePageView extends StatefulWidget {
  final PageController pageController;
  final Function(int) onPageChanged;

  HomePageView({
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        controller: widget.pageController,
        onPageChanged: widget.onPageChanged,
        children: [
          HomepageContent(),
          TripsPage(),
          HotelPage(),
          SettingsPage(),
        ],
      ),
    );
  }
}
