import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:majan_road/base/searchBar.dart';
import 'package:majan_road/localization/app_localization.dart';
import 'package:majan_road/trips/model/tripsModel.dart';
import 'package:majan_road/trips/tripCard.dart';
import 'package:majan_road/widgets/imageCarousel.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({Key? key}) : super(key: key);

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Trip> trips = [];
  List<Trip> filteredTrips = [];
  bool sortByPriceLowToHigh = false;

  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  Future<void> fetchTrips() async {
    final response =
        await http.get(Uri.parse('http://167.71.230.108/api/trips'));

    if (response.statusCode == 200) {
      List<dynamic> tripsData = json.decode(response.body);

      for (var trip in tripsData) {
        if (trip['pictures'] != null && trip['pictures'].isNotEmpty) {
          for (var picture in trip['pictures']) {
            picture['path'] = 'http://167.71.230.108/storage' +
                picture['path'].replaceFirst('public/', '/');
          }
        }
      }

      setState(() {
        trips = tripsData.map((trip) {
          return Trip(
            name: trip['name'],
            rating:
                4.5, // Assuming a default rating as it's not available in the API response
            location: trip[
                'destination'], // Assuming a default location as it's not available in the API response
            price: double.parse(trip['price']),
            description: trip['description'],
            tripImage: trip['pictures'] != null && trip['pictures'].isNotEmpty
                ? trip['pictures'][0]['path']
                : 'http://167.71.230.108/default-image.png',
            startDate: trip['start_date'],
            endDate: trip['end_date'],
            categories: trip['categories'] is String
                ? List<String>.from(json.decode(trip['categories']) ?? [])
                : List<String>.from(trip['categories'] ?? []),
            whatsIncluded: trip['whats_included'] is String
                ? List<String>.from(json.decode(trip['whats_included']) ?? [])
                : List<String>.from(trip['whats_included'] ?? []),
            whatsNotIncluded: trip['whats_not_included'] is String
                ? List<String>.from(
                    json.decode(trip['whats_not_included']) ?? [])
                : List<String>.from(trip['whats_not_included'] ?? []),
            whatToBring: trip['what_to_bring'] is String
                ? List<String>.from(json.decode(trip['what_to_bring']) ?? [])
                : List<String>.from(trip['what_to_bring'] ?? []),
            cancellationRefundPolicy: trip['cancellation_refund_policy']
                    is String
                ? List<String>.from(
                    json.decode(trip['cancellation_refund_policy']) ?? [])
                : List<String>.from(trip['cancellation_refund_policy'] ?? []),
          );
        }).toList();
        filteredTrips = trips;
      });
    } else {
      throw Exception('Failed to load trips');
    }
  }

  void filterTrips(String query) {
    final filtered = trips.where((trip) {
      final nameLower = trip.name.toLowerCase();
      final locationLower = trip.location.toLowerCase();
      final searchLower = query.toLowerCase();

      return nameLower.contains(searchLower) ||
          locationLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredTrips = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 2,
        backgroundColor: backgroundColor,
      ),
      key: _scaffoldKey,
      body: Padding(
        padding: EdgeInsets.only(
          right: screenWidth * 0.02,
          left: screenWidth * 0.02,
          top: screenWidth * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchBare(
              onChanged: (String value) {
                filterTrips(value);
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)?.translate('popular trips') ??
                      'Popular Trips',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xffF75D37),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showSortOptions(context);
                  },
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)?.translate('sorted by') ??
                            'Sorted by',
                        style: TextStyle(color: Color(0xffF75D37)),
                      ),
                      const Icon(Icons.sort),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTrips.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TripCard(
                      trip: filteredTrips[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }

  void _sortTripsByPrice() {
    filteredTrips.sort((a, b) {
      if (sortByPriceLowToHigh) {
        return a.price.compareTo(b.price);
      } else {
        return b.price.compareTo(a.price);
      }
    });
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final backgroundColor = isDarkMode ? Colors.black : Colors.white;
        final textColor = isDarkMode ? Colors.white : Colors.black;

        return Container(
          color: backgroundColor,
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.arrow_upward),
                title: Text(
                    AppLocalizations.of(context)
                            ?.translate('price low to high') ??
                        'Price (Low to High)',
                    style: TextStyle(color: textColor)),
                onTap: () {
                  setState(() {
                    sortByPriceLowToHigh = true;
                    _sortTripsByPrice();
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward),
                title: Text(
                    AppLocalizations.of(context)
                            ?.translate('price high to low') ??
                        'Price (High to Low)',
                    style: TextStyle(color: textColor)),
                onTap: () {
                  setState(() {
                    sortByPriceLowToHigh = false;
                    _sortTripsByPrice();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
