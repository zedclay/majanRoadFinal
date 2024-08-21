// import 'package:flutter/material.dart';
// import 'package:majan_road/localization/app_localization.dart';

// class EventsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         title: Text(
//           AppLocalizations.of(context)?.translate('oman_cultural_festival') ??
//               'Oman Cultural Festival',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Color(0xff55A5A4),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Stack(
//               children: [
//                 Image.asset(
//                   'assets/images/event.png',
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   height: 250,
//                 ),
//                 Container(
//                   height: 250,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.black.withOpacity(0.5),
//                         Colors.transparent,
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 16,
//                   left: 16,
//                   child: Container(
//                     color: Colors.black.withOpacity(0.5),
//                     padding: EdgeInsets.all(8),
//                     child: Text(
//                       AppLocalizations.of(context)
//                               ?.translate('oman_cultural_festival') ??
//                           'Oman Cultural Festival',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     AppLocalizations.of(context)?.translate('event_details') ??
//                         'Event Details',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xff55A5A4),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         AppLocalizations.of(context)?.translate('date') ??
//                             'Date:',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       Text(
//                         'June 25, 2024',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         AppLocalizations.of(context)?.translate('price') ??
//                             'Price:',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       Text(
//                         '\$50',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         AppLocalizations.of(context)?.translate('location') ??
//                             'Location:',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       Text(
//                         AppLocalizations.of(context)
//                                 ?.translate('muscat_oman') ??
//                             'Muscat, Oman',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16),
//                   Text(
//                     AppLocalizations.of(context)?.translate('description') ??
//                         'Description',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xff55A5A4),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     AppLocalizations.of(context)
//                             ?.translate('event_description') ??
//                         'Join us for the Oman Cultural Festival, a celebration of Omani heritage and culture. Enjoy traditional music, dance, food, and crafts from across the region. This event is a perfect opportunity to immerse yourself in the rich cultural tapestry of Oman and experience the warmth and hospitality of its people.',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 16),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Add your booking logic here
//                       },
//                       child: Text(
//                         AppLocalizations.of(context)?.translate('book_now') ??
//                             'Book Now',
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xff55A5A4),
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 50,
//                           vertical: 15,
//                         ),
//                         textStyle: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:majan_road/events/eventDetailpage.dart';
import 'package:majan_road/widgets/themeNotiffier.dart';
import 'package:majan_road/localization/app_localization.dart';
import '../widgets/imageCarousel.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> events = [];
  bool isLoading = true;
  String errorMessage = '';
  Map<String, dynamic> latestEvent = {};

  List<Holiday> holidays = [];
  List<Season> seasons = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
    fetchLatestEvent();
    fetchSeasons();
    fetchHolidays();
  }

  Future<void> fetchEvents() async {
    try {
      final response =
          await http.get(Uri.parse('http://167.71.230.108/api/events'));
      if (response.statusCode == 200) {
        List<dynamic> eventsData = json.decode(response.body);
        setState(() {
          events = eventsData.map((data) => Event.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load events';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> fetchLatestEvent() async {
    final response =
        await http.get(Uri.parse('http://167.71.230.108/api/event/latest'));
    if (response.statusCode == 200) {
      Map<String, dynamic> eventData = json.decode(response.body);
      List<String> pictures = (eventData['pictures'] as List).map((picture) {
        return 'http://167.71.230.108/storage' +
            picture['path'].replaceFirst('public/', '/');
      }).toList();
      setState(() {
        latestEvent = eventData..['pictures'] = pictures;
      });
    } else {
      throw Exception('Failed to load latest event');
    }
  }

  Future<void> fetchHolidays() async {
    try {
      final response =
          await http.get(Uri.parse('http://167.71.230.108/api/holidays'));
      if (response.statusCode == 200) {
        List<dynamic> holidaysData = json.decode(response.body);
        setState(() {
          holidays =
              holidaysData.map((data) => Holiday.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load holidays';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> fetchSeasons() async {
    try {
      final response =
          await http.get(Uri.parse('http://167.71.230.108/api/seasons'));
      if (response.statusCode == 200) {
        List<dynamic> seasonsData = json.decode(response.body);
        setState(() {
          seasons = seasonsData.map((data) => Season.fromJson(data)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load seasons';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          AppLocalizations.of(context)?.translate('Events in Oman') ??
              'Events in Oman',
          style: TextStyle(color: textColor),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage, style: TextStyle(color: textColor)))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildImageCarousel(),
                        const SizedBox(height: 20),
                        buildSectionTitle(
                          AppLocalizations.of(context)
                                  ?.translate('Explore Our Exclusive Events') ??
                              'Explore Our Exclusive Events',
                          textColor,
                        ),
                        const SizedBox(height: 20),
                        buildEventList(),
                        const SizedBox(height: 20),
                        buildSectionTitle(
                          AppLocalizations.of(context)
                                  ?.translate('Oman Seasons') ??
                              'Oman Seasons',
                          textColor,
                        ),
                        const SizedBox(height: 20),
                        buildSeasonList(),
                        const SizedBox(height: 20),
                        buildSectionTitle(
                          AppLocalizations.of(context)
                                  ?.translate('Oman Holidays') ??
                              'Oman Holidays',
                          textColor,
                        ),
                        const SizedBox(height: 20),
                        buildHolidayList(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget buildImageCarousel() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ImageCarousel(
        imageUrls: [
          'assets/images/event1.jpg',
          'assets/images/event2.jpg',
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title, Color textColor) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width / 25,
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildEventList() {
    return Container(
      height: 380,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(event: events[index]);
        },
      ),
    );
  }

  Widget buildSeasonList() {
    return Container(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: seasons.length,
        itemBuilder: (context, index) {
          return SeasonCard(season: seasons[index]);
        },
      ),
    );
  }

  Widget buildHolidayList() {
    return Container(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: holidays.length,
        itemBuilder: (context, index) {
          return HolidayCard(holiday: holidays[index]);
        },
      ),
    );
  }
}

class Event {
  final int id;
  final String title;
  final String startDate;
  final String endDate;
  final double price;
  final double latitude;
  final double longitude;
  final String location;
  final List<String> ages;
  final List<String> idealFor;
  final String description;
  final String openingHour;
  final String closingHour;
  final List<String> daysOpenedDuringWeek;
  final String phoneNumber;
  final List<String> pictures;

  Event({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.ages,
    required this.idealFor,
    required this.description,
    required this.openingHour,
    required this.closingHour,
    required this.daysOpenedDuringWeek,
    required this.phoneNumber,
    required this.pictures,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      price: double.parse(json['price']),
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      location: json['location'],
      ages: List<String>.from(jsonDecode(json['ages'])),
      idealFor: List<String>.from(jsonDecode(json['ideal_for'])),
      description: json['description'],
      openingHour: json['opening_hour'],
      closingHour: json['closing_hour'],
      daysOpenedDuringWeek:
          List<String>.from(jsonDecode(json['days_opened_during_week'])),
      phoneNumber: json['phone_number'],
      pictures: (json['pictures'] as List).map((picture) {
        return 'http://167.71.230.108/storage' +
            picture['path'].replaceFirst('public/', '/');
      }).toList(),
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailsPage(event: event),
          ),
        );
      },
      child: Container(
        width: 300,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Image.network(
                      event.pictures.isNotEmpty
                          ? event.pictures[0]
                          : 'assets/images/event_placeholder.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      color: Colors.black54,
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '${event.startDate} - ${event.endDate}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.location,
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Implement booking functionality
                          },
                          child: Text(
                            AppLocalizations.of(context)
                                    ?.translate('Book Now') ??
                                'Book Now',
                            style: TextStyle(
                              color: isDarkMode ? Colors.black : Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isDarkMode ? Colors.orange : Colors.green,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)?.translate('from') ??
                              'from' + ' \$${event.price}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.orange : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Holiday {
  final int id;
  final String title;
  final String startDate;
  final String endDate;
  final String description;
  final List<String> pictures;

  Holiday({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.pictures,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) {
    return Holiday(
      id: json['id'],
      title: json['title'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      description: json['description'],
      pictures: (json['pictures'] as List).map((picture) {
        return 'http://167.71.230.108/storage' +
            picture['path'].replaceFirst('public/', '/');
      }).toList(),
    );
  }
}

class Season {
  final int id;
  final String title;
  final String startDate;
  final String endDate;
  final String description;
  final List<String> pictures;

  Season({
    required this.id,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.pictures,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      title: json['title'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      description: json['description'],
      pictures: (json['pictures'] as List).map((picture) {
        return 'http://167.71.230.108/storage' +
            picture['path'].replaceFirst('public/', '/');
      }).toList(),
    );
  }
}

class SeasonCard extends StatelessWidget {
  final Season season;

  const SeasonCard({Key? key, required this.season}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              season.pictures.isNotEmpty
                  ? season.pictures[0]
                  : 'assets/images/season_placeholder.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  season.startDate,
                  style: TextStyle(color: textColor),
                ),
                Text(
                  season.title,
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                  ),
                ),
                Text(
                  season.description,
                  style: TextStyle(color: textColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HolidayCard extends StatelessWidget {
  final Holiday holiday;

  const HolidayCard({Key? key, required this.holiday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      width: 200,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              holiday.pictures.isNotEmpty
                  ? holiday.pictures[0]
                  : 'assets/images/holiday_placeholder.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  holiday.startDate,
                  style: TextStyle(color: textColor),
                ),
                Text(
                  holiday.title,
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                  ),
                ),
                Text(
                  holiday.description,
                  style: TextStyle(
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
