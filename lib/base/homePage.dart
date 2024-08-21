import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:majan_road/events/eventsPage.dart';
import 'package:majan_road/hotels/hotelDescriptionPage.dart';

import 'package:majan_road/hotels/hotelPage.dart';
import 'package:majan_road/settings/settingsPage.dart';
import 'package:majan_road/trips/model/tripsModel.dart';
import 'package:majan_road/trips/tripsDescriptionPage.dart';
import 'package:majan_road/trips/tripsPage.dart';
import 'package:majan_road/widgets/customAppBar.dart';
import 'package:majan_road/widgets/customDrawer.dart';
import 'package:majan_road/base/homePageContent.dart';
import 'package:majan_road/widgets/themeNotiffier.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class Homepage extends StatefulWidget {
  final Function(Locale) changeLanguage;
  final VoidCallback toggleDarkMode;

  const Homepage({
    Key? key,
    required this.changeLanguage,
    required this.toggleDarkMode,
  }) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late PageController _pageController;

  int _notificationCount = 5;

  List<Hotel> hotels = [];
  List<Trip> trips = [
    // Trip objects as defined earlier...
  ];

  Map<String, dynamic>? latestEvent;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    fetchHotels();
    fetchLatestEvent();
  }

  Future<void> fetchHotels() async {
    try {
      final response = await _dio.get('http://167.71.230.108/api/hotels');
      if (response.statusCode == 200) {
        List<dynamic> hotelsData = response.data;
        List<Hotel> fetchedHotels = hotelsData.map((data) {
          List<String> imageUrls =
              (data['pictures'] as List<dynamic>).map((picture) {
            return 'http://167.71.230.108/storage' +
                picture['path'].replaceFirst('public/', '/');
          }).toList();
          return Hotel(
            id: data['id'],
            name: data['name'],
            description: data['description'],
            imageUrls: imageUrls,
            rating: 4.5, // Assuming a static rating for now
            location: data['city']['name'],
            price: 100, // Assuming a static price for now
          );
        }).toList();

        setState(() {
          hotels = fetchedHotels;
        });
      } else {
        throw Exception('Failed to load hotels');
      }
    } catch (e) {
      print('Error fetching hotels: $e');
    }
  }

  Future<void> fetchLatestEvent() async {
    try {
      final response = await _dio.get('http://167.71.230.108/api/event/latest');
      if (response.statusCode == 200) {
        setState(() {
          latestEvent = response.data;
        });
        _checkEventPopUp(); // Ensure this is called after setting the latestEvent
      } else {
        throw Exception('Failed to load the latest event');
      }
    } catch (e) {
      print('Error fetching latest event: $e');
    }
  }

  void _checkEventPopUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? showPopUp = prefs.getBool('showEventPopUp') ?? true;
    if (showPopUp && latestEvent != null) {
      _showEventPopUp();
    }
  }

  void _showEventPopUp() {
    bool doNotShowAgain = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              if (latestEvent == null) {
                // Handle the case where latestEvent is null
                return AlertDialog(
                  content: Text('No event available.'),
                  actions: [
                    TextButton(
                      child: Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }

              return AlertDialog(
                backgroundColor: Color(0xffF75D37),
                contentPadding: EdgeInsets.zero,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EventsPage()),
                        );
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: Image.asset('assets/images/event.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  latestEvent!['title'] ?? 'No Title',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Date: ${latestEvent!['start_date'] ?? 'N/A'} - ${latestEvent!['end_date'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Location: ${latestEvent!['location'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Price From: \$${latestEvent!['price'] ?? 'N/A'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.white),
                    CheckboxListTile(
                      title: Text(
                        "Don't show this again",
                        style: TextStyle(color: Colors.white),
                      ),
                      value: doNotShowAgain,
                      onChanged: (bool? value) {
                        setState(() {
                          doNotShowAgain = value ?? false;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('showEventPopUp', !doNotShowAgain);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    });
  }

  void _onSearchChanged(String query) {
    print('Searching for: $query');

    final hotel = hotels.firstWhere(
      (hotel) => hotel.name.toLowerCase() == query.toLowerCase(),
      orElse: () {
        print('No matching hotel found for: $query');
        return Hotel(
          id: 0,
          name: '',
          description: '',
          imageUrls: [],
          rating: 0,
          location: '',
          price: 0,
        );
      },
    );

    if (hotel.name.isNotEmpty) {
      print('Navigating to hotel: ${hotel.name}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HotelDescription(
            tripName: hotel.name,
            tripDescription: hotel.description,
            imageUrls: hotel.imageUrls,
            rating: hotel.rating,
            location: hotel.location,
            price: hotel.price,
            hotelId: hotel.id, amenities: [], // Pass the hotel ID
          ),
        ),
      );
      return;
    }

    final trip = trips.firstWhere(
      (trip) => trip.name.toLowerCase() == query.toLowerCase(),
      orElse: () {
        print('No matching trip found for: $query');
        return Trip(
          name: '',
          rating: 0,
          location: '',
          price: 0,
          description: '',
          tripImage: '',
          startDate: '',
          endDate: '',
          categories: [],
          whatsIncluded: [],
          whatsNotIncluded: [],
          whatToBring: [],
          cancellationRefundPolicy: [],
        );
      },
    );

    if (trip.name.isNotEmpty) {
      print('Navigating to trip: ${trip.name}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripDescription(
            trip: trip,
          ),
        ),
      );
    } else {
      print('No matching hotel or trip found for: $query');
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
      ),
      key: _scaffoldKey,
      drawer: CustomDrawer(
        changeLanguage: widget.changeLanguage,
        onPageSelected: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              _currentIndex,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                HomepageContent(),
                TripsPage(),
                HotelPage(),
                SettingsPage(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
            _pageController.animateToPage(
              i,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.purple,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.backpack),
            title: const Text("Trips"),
            selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.hotel),
            title: const Text("Hotels"),
            selectedColor: Colors.orange,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.settings),
            title: const Text("Settings"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}

class Hotel {
  final int id;
  final String name;
  final String description;
  final List<String> imageUrls;
  final double rating;
  final String location;
  final double price;

  Hotel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrls,
    required this.rating,
    required this.location,
    required this.price,
  });
}
